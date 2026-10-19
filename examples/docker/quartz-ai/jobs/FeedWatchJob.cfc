/**
 * Quartz job: checks a feed, decides which items need attention and writes a draft note for them.
 *
 * 1. a cheap keyword rule picks candidates
 * 2. an AI connection (if configured) decides if a candidate really needs attention and drafts a note
 * 3. results go to the log and to drafts.jsonl in the output directory, nothing is sent anywhere
 *
 * Arguments come from the job entry in quartz/config.json.
 */
component {

	public void function init(
		string aiConnection = "watcher",
		string outputDirectory = "/opt/lucee/output",
		string sampleFeed = ""
	) {
		variables.aiConnection = arguments.aiConnection;
		variables.outputDirectory = arguments.outputDirectory;
		variables.sampleFeed = arguments.sampleFeed;
	}

	public void function execute() {
		var env = server.system.environment;
		var keywords = listToArray( env.WATCH_KEYWORDS ?: "error,crash,outage,security,urgent,down" );
		var useAI = len( trim( env.AI_URL ?: "" ) ) && len( trim( env.AI_MODEL ?: "" ) );

		if ( !directoryExists( variables.outputDirectory ) ) directoryCreate( variables.outputDirectory );
		var stateFile = variables.outputDirectory & "/seen.json";
		var seen = fileExists( stateFile ) ? deserializeJSON( fileRead( stateFile ) ) : {};

		var items = readFeed( env.FEED_URL ?: "" );
		var flagged = 0;

		for ( var item in items ) {
			var id = toString( item.id ?: hash( item.title ?: "" ) );
			if ( structKeyExists( seen, id ) ) continue;
			seen[ id ] = now();

			// rule 1: keyword pre filter, keeps AI calls (and costs) low
			var text = ( item.title ?: "" ) & " " & ( item.body ?: "" );
			var matched = keywords.filter( ( k ) => findNoCase( trim( k ), text ) );
			if ( !matched.len() ) continue;

			// rule 2: let the AI decide, fall back to the keyword result
			var decision = { "attention": true, "reason": "keyword match: " & matched.toList(), "draft": "", "source": "rule" };
			if ( useAI ) {
				try {
					decision = askAI( item );
				}
				catch ( any e ) {
					log log="scheduler" type="warn" text="FeedWatchJob: AI call failed, using keyword rule only: #e.message#";
				}
			}

			if ( decision.attention ) {
				flagged++;
				var entry = { "id": id, "title": item.title ?: "", "created": dateTimeFormat( now(), "iso" ) };
				structAppend( entry, decision );
				fileAppend( variables.outputDirectory & "/drafts.jsonl", serializeJSON( entry ) & chr( 10 ) );
				log log="scheduler" type="info" text="FeedWatchJob: needs attention [#id#] #entry.title# (#decision.source#): #decision.reason#";
			}
		}

		fileWrite( stateFile, serializeJSON( seen ) );
		log log="scheduler" type="info" text="FeedWatchJob: checked #items.len()# items, #flagged# flagged, AI #useAI ? 'on' : 'off (AI_URL/AI_MODEL not set)'#";
	}

	private array function readFeed( required string feedUrl ) {
		var raw = "";
		if ( len( trim( arguments.feedUrl ) ) ) {
			http url=arguments.feedUrl method="get" timeout=20 result="local.res";
			if ( res.status_code != 200 ) throw "feed returned #res.statuscode#";
			raw = res.fileContent;
		}
		else {
			raw = fileRead( variables.sampleFeed );
		}
		var data = deserializeJSON( raw );
		return isArray( data ) ? data : ( data.items ?: [] );
	}

	private struct function askAI( required struct item ) {
		var aiSession = createAISession(
			name: variables.aiConnection,
			systemMessage: "You triage messages for a small team. "
				& "Reply only with JSON: {""attention"": true|false, ""reason"": ""one sentence"", ""draft"": ""a short, friendly reply draft or empty""}."
		);
		var answer = inquiryAISession( aiSession, "Title: #item.title ?: ''#" & chr( 10 ) & "Body: #item.body ?: ''#" );

		// some models wrap JSON in a code fence
		var json = reReplace( trim( answer ), "^```(json)?\s*|\s*```$", "", "all" );
		var result = deserializeJSON( json );
		return {
			"attention": isBoolean( result.attention ?: "" ) ? result.attention : true,
			"reason": result.reason ?: "",
			"draft": result.draft ?: "",
			"source": "ai"
		};
	}
}
