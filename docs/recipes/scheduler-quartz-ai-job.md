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
cp .env.example .env    # optional, fill in AI_URL, AI_SECRET_KEY, AI_MODEL
docker compose up -d --build
docker compose logs -f lucee
```

Without an AI endpoint the example still runs, using only the keyword rule.

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
			"class": "lucee.runtime.ai.openai.OpenAIEngine",
			"custom": {
				"url": "${AI_URL}",
				"secretKey": "${AI_SECRET_KEY}",
				"model": "${AI_MODEL}",
				"message": "You triage short messages. Answer only with the JSON that is asked for.",
				"timeout": 30000
			}
		}
	}
}
```

`OpenAIEngine` works with any OpenAI compatible API. For other providers see [[ai]]. Use the current Quartz extension version from the [extension list](https://download.lucee.org/).

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
	var useAI = len( trim( env.AI_URL ?: "" ) ) && len( trim( env.AI_MODEL ?: "" ) );

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
	// some models wrap JSON in a code fence
	var result = deserializeJSON( reReplace( trim( answer ), "^```(json)?\s*|\s*```$", "", "all" ) );
	return { "attention": result.attention ?: true, "reason": result.reason ?: "", "draft": result.draft ?: "", "source": "ai" };
}
```

The full component also remembers which items it has already handled (`output/seen.json`), so every item is only checked once.

## Design Notes

- **Rules first, AI second.** A plain rule filters the obvious cases; the AI only sees the candidates. That keeps runs fast and cheap and makes the job work without AI.
- **Fail soft.** A failing AI call is logged and the job continues with the rule result; one broken run does not stop the schedule.
- **Drafts, not actions.** The job writes drafts. Sending them (mail, chat, ticket) is a separate step you add when you trust the results, ideally with an approval step in between.
- **Secrets from the environment.** Endpoint, key and model come from env vars, see [[environment-variables-system-properties]].
- **Transient jobs.** `"mode": "transient"` creates a new component instance per run, so no state leaks between runs; persistent state lives in a file (or a database).

## Related

- [[scheduler-quartz]] — Quartz overview and configuration
- [[component-jobs-quartz-scheduler]] — component jobs and listeners
- [[ai]] — AI connections and functions
- [[Docker]] — Lucee Docker images
