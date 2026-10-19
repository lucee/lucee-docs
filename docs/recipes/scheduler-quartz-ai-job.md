<!--
{
  "title": "Scheduled AI Jobs with Quartz",
  "id": "scheduler-quartz-ai-job",
  "since": "7.0",
  "related": ["scheduler-quartz", "component-jobs-quartz-scheduler", "ai", "Docker", "function-createaisession", "function-inquiryaisession"],
  "categories": ["extensions", "recipes", "ai"],
  "description": "Run a Quartz job in Docker that uses an AI connection to decide which feed items need attention",
  "keywords": [
    "scheduler",
    "quartz",
    "AI",
    "AI connection",
    "LLM",
    "docker",
    "cron",
    "automation"
  ]
}
-->

# Scheduled AI Jobs with Quartz

A common task: check something regularly (a feed, an API, a log), decide what matters, and prepare a reaction. With Lucee you can do all of it in CFML: the [[scheduler-quartz]] extension runs the job, an [[ai]] connection makes the judgement call.

This recipe explains a small, runnable Docker example:

> **[github.com/lucee/lucee-docs/tree/master/examples/docker/quartz-ai](https://github.com/lucee/lucee-docs/tree/master/examples/docker/quartz-ai)**

The job reads a feed, picks candidates with a keyword rule, asks the AI connection whether they need attention and for a reply draft, and writes the result to a file. It never posts anything itself; that keeps a human in the loop.

## Run It

```bash
cd lucee-docs/examples/docker/quartz-ai
cp .env.example .env    # optional, set AI_SECRET_KEY (and AI_MODEL)
docker compose up -d --build
docker compose logs -f lucee
```

Without an AI key the example still runs, using only the keyword rule.

## 1. Install the Extension and Define the AI Connection

Everything is in `.CFConfig.json` (`lucee-config.json` in the example). The Quartz extension is installed from Maven at startup, and the AI connection reads its endpoint, key and model from environment variables, so no secret ends up in the image:

```json
{
	"extensions": [
		{
			"id": "E99E43A5-C10E-41E9-878BFC82BAAD99CE",
			"name": "Quartz Scheduler Extension",
			"version": "1.0.0.65"
		}
	],
	"ai": {
		"watcher": {
			"class": "lucee.runtime.ai.anthropic.ClaudeEngine",
			"custom": {
				"url": "${AI_URL}",
				"apiKey": "${AI_SECRET_KEY}",
				"model": "${AI_MODEL}",
				"message": "You triage short messages. Answer only with the JSON that is asked for.",
				"timeout": 30000
			}
		}
	}
}
```

The example uses Claude; `url` may stay empty, then the Anthropic default is used. To use an OpenAI compatible API instead (OpenAI, Ollama, a local gateway, ...), swap the AI connection:

```json
"watcher": {
	"class": "lucee.runtime.ai.openai.OpenAIEngine",
	"custom": {
		"url": "${AI_URL}",
		"secretKey": "${AI_SECRET_KEY}",
		"model": "${AI_MODEL}",
		"message": "You triage short messages. Answer only with the JSON that is asked for.",
		"timeout": 30000
	}
}
```

and set `AI_URL` (for example `https://api.openai.com/v1/`) and `AI_MODEL` to match. Note the key name: Claude uses `apiKey`, `OpenAIEngine` uses `secretKey`. The job itself does not change, it only knows the AI connection name.

For other providers see [[ai]]. Use the current Quartz extension version from the [extension list](https://download.lucee.org/).

## 2. Define the Schedule

The Quartz extension reads its jobs from `{lucee-config}/quartz/config.json`. The example copies this file into the image:

```json
{
	"jobs": [
		{
			"label": "Feed watcher",
			"component": "jobs.FeedWatchJob",
			"cron": "0 */5 * * * ?",
			"mode": "transient",
			"pause": false,
			"aiConnection": "watcher",
			"outputDirectory": "/opt/lucee/output",
			"sampleFeed": "/opt/lucee/sample-data/sample-feed.json"
		}
	]
}
```

- `component` is resolved through the component mappings; the example puts the job into `{lucee-config}/components/jobs/`, which is mapped by default.
- `cron` uses the Quartz format with seconds; this one runs every 5 minutes.
- All other keys are passed to the component's `init()` as arguments.

See [[component-jobs-quartz-scheduler]] for all job options.

## 3. Write the Job

A component job has an `init()` that receives the job arguments and an `execute()` that Quartz calls on every run. The core of `jobs/FeedWatchJob.cfc`:

```cfml
public void function execute() {
	var env = server.system.environment;
	var keywords = listToArray( env.WATCH_KEYWORDS ?: "error,crash,outage,security,urgent,down" );
	var useAI = len( trim( env.AI_SECRET_KEY ?: "" ) ) > 0;

	for ( var item in readFeed( env.FEED_URL ?: "" ) ) {
		// rule 1: cheap keyword pre filter, keeps AI calls low
		var text = item.title & " " & item.body;
		var matched = keywords.filter( ( k ) => findNoCase( trim( k ), text ) );
		if ( !matched.len() ) continue;

		// rule 2: let the AI decide, fall back to the keyword result
		var decision = { "attention": true, "reason": "keyword match", "draft": "", "source": "rule" };
		if ( useAI ) {
			try {
				decision = askAI( item );
			}
			catch ( any e ) {
				log log="scheduler" type="warn" text="AI call failed, using keyword rule only: #e.message#";
			}
		}

		if ( decision.attention ) {
			fileAppend( variables.outputDirectory & "/drafts.jsonl", serializeJSON( decision ) & chr( 10 ) );
		}
	}
}
```

The AI part asks for a small JSON answer, which is easy to check in code:

```cfml
private struct function askAI( required struct item ) {
	var aiSession = createAISession(
		name: variables.aiConnection,
		systemMessage: "You triage messages for a small team. "
			& "Reply only with JSON: {""attention"": true|false, ""reason"": ""one sentence"", ""draft"": ""a short reply draft or empty""}."
	);
	var answer = inquiryAISession( aiSession, "Title: #item.title#" & chr( 10 ) & "Body: #item.body#" );
	var result = parseAIAnswer( answer );
	return { "attention": result.attention ?: true, "reason": result.reason ?: "", "draft": result.draft ?: "", "source": "ai" };
}
```

Models do not always answer with bare JSON: some wrap it in a code fence or add a sentence around it. `parseAIAnswer()` therefore strips a fence and parses the first `{...}` block:

```cfml
private struct function parseAIAnswer( required string answer ) {
	var text = trim( arguments.answer );
	text = reReplace( text, "^```[a-zA-Z]*\s*", "" );
	text = reReplace( text, "\s*```\s*$", "" );
	var first = find( "{", text );
	var fromEnd = find( "}", reverse( text ) );
	var last = fromEnd ? len( text ) - fromEnd + 1 : 0;
	if ( !first || last <= first ) throw "AI answer contains no JSON object";
	return deserializeJSON( mid( text, first, last - first + 1 ) );
}
```

The full component also remembers which items it has already handled (`output/seen.json`), so every item is only checked once.

## Design Notes

- **Rules first, AI second.** A plain rule filters the obvious cases; the AI only sees the candidates. That keeps runs fast and cheap and makes the job work without AI.
- **Fail soft.** A failing AI call is logged and the job continues with the rule result; one broken run does not stop the schedule.
- **Drafts, not actions.** The job writes drafts. Sending them (mail, chat, ticket) is a separate step you add when you trust the results, ideally with an approval step in between.
- **Secrets from the environment.** Key, model and optional endpoint come from env vars, see [[environment-variables-system-properties]].
- **Transient jobs.** `"mode": "transient"` creates a new component instance per run, so no state leaks between runs; persistent state lives in a file (or a database).

## Related

- [[scheduler-quartz]] — Quartz overview and configuration
- [[component-jobs-quartz-scheduler]] — component jobs and listeners
- [[ai]] — AI connections and functions
- [[Docker]] — Lucee Docker images
