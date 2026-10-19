<!--
{
  "title": "Adding Scheduled Jobs with an AI Assistant (Quartz)",
  "id": "scheduler-quartz-ai-job",
  "since": "7.0",
  "related": ["scheduler-quartz", "component-jobs-quartz-scheduler", "ai", "mcp", "lucee-skill", "Docker", "function-createaisession", "function-inquiryaisession"],
  "categories": ["extensions", "recipes", "ai"],
  "description": "Add Quartz jobs to a Lucee server by asking an AI coding assistant in plain language, watch them with a job listener (duration, failures, AI token usage), and connect them to outside services with MCP or plain HTTP",
  "keywords": [
    "scheduler",
    "quartz",
    "AI",
    "AI connection",
    "vibe coding",
    "MCP",
    "listener",
    "token usage",
    "docker",
    "cron",
    "automation"
  ]
}
-->

# Adding Scheduled Jobs with an AI Assistant (Quartz)

Many small automations follow the same pattern: every hour (or every morning) check something, decide what matters, and prepare a reaction. With the [[scheduler-quartz]] extension a job is just a component plus one entry in a JSON file, which makes it a very good fit for an AI coding assistant: you describe the job in plain language, the assistant writes the component and the schedule, you review it, done.

This recipe uses a small, runnable Docker example as the project you work in:

> **[github.com/lucee/lucee-docs/tree/master/examples/docker/quartz-ai](https://github.com/lucee/lucee-docs/tree/master/examples/docker/quartz-ai)**

It covers:

1. [Getting jobs in](#getting-jobs-in-ask-for-them): ask an assistant for a new job
2. [Watching jobs](#watching-what-jobs-do-listeners): a job listener that records duration, failures and AI token usage
3. [Reaching outside services](#reaching-outside-services-mcp-and-plain-http): MCP and plain HTTP
4. [The example project](#the-example-project) itself

## Run the Example

```bash
cd lucee-docs/examples/docker/quartz-ai
cp .env.example .env    # optional, set AI_SECRET_KEY (and AI_MODEL)
docker compose up -d --build
docker compose logs -f lucee
```

Without an AI key everything still runs; the example job then only uses its keyword rule.

## Getting Jobs In: Ask for Them

The interesting part is not one specific job, it is how new jobs get added. The project layout is deliberately simple, so an assistant can follow it:

| What | Where |
|------|-------|
| Job components | `jobs/*.cfc` (an `init()` for the arguments, an `execute()` per run) |
| Schedules | `quartz/config.json`, one entry per job (`component`, `cron` or `interval`, arguments) |
| Listeners | `listeners/*.cfc`, registered in the `listeners` section of `quartz/config.json` |
| AI connections, extensions | `lucee-config.json` |

### Set Up the Session

Open the example folder in an AI coding assistant (Cursor, Claude Code, or any agent that can edit files). Give it accurate Lucee knowledge, so it does not guess:

- the **Lucee skill**, see [[lucee-skill]] for the install steps per tool; it routes the assistant to the right recipes, including this one and [[component-jobs-quartz-scheduler]]
- the public **Lucee MCP server** for exact function and tag signatures, see [[mcp]]

Then just ask.

### Example Prompts

> Set up a new job that runs every hour, reads the Lucee release feed from GitHub and writes a line to the log when there is a release it has not seen yet.

> Add a job that every morning at 7:00 checks the status page `https://status.example.com/api/status.json` and, when anything is not "operational", asks the AI connection `watcher` for a short summary and appends it to `output/status.jsonl`.

> The feed watcher runs too often, change it to every 15 minutes on weekdays only, and pause it on weekends.

### What the Assistant Produces

For the first prompt you should get a new component in `jobs/`:

```cfml
// jobs/ReleaseWatchJob.cfc
component {

	public void function init( string feedUrl = "", string outputDirectory = "/opt/lucee/output" ) {
		variables.feedUrl = arguments.feedUrl;
		variables.stateFile = arguments.outputDirectory & "/releases-seen.json";
	}

	public void function execute() {
		http url=variables.feedUrl method="get" timeout=20 result="local.res";
		if ( res.status_code != 200 ) throw "release feed returned #res.statuscode#";

		var seen = fileExists( variables.stateFile ) ? deserializeJSON( fileRead( variables.stateFile ) ) : {};
		for ( var release in deserializeJSON( res.fileContent ) ) {
			if ( structKeyExists( seen, release.tag_name ) ) continue;
			seen[ release.tag_name ] = now();
			log log="scheduler" type="info" text="ReleaseWatchJob: new release #release.tag_name#";
		}
		fileWrite( variables.stateFile, serializeJSON( seen ) );
	}
}
```

and a new entry in `quartz/config.json`:

```json
{
	"label": "Release watcher",
	"component": "jobs.ReleaseWatchJob",
	"cron": "0 0 * * * ?",
	"mode": "transient",
	"pause": false,
	"feedUrl": "https://api.github.com/repos/lucee/Lucee/releases",
	"outputDirectory": "/opt/lucee/output"
}
```

- `cron` is the Quartz format with seconds: `0 0 * * * ?` is every full hour, `0 0 7 * * ?` every day at 7:00, `0 */15 * ? * MON-FRI` every 15 minutes on weekdays.
- Every key other than the job settings (`label`, `component`, `cron`, `mode`, ...) is passed to `init()`, so the URL stays configuration, not code.
- For the third prompt the assistant only changes `cron` and `pause` of the existing entry.

### How the Change Is Picked Up

The Quartz extension reads `quartz/config.json` when its event gateway (`quartz-task`) starts. It does **not** watch the file, so after an edit either:

- **restart** — in the example `docker compose up -d --build`, because the files are copied into the image, or
- **reload without restart** — tell the running gateway to re-read the file:

  ```cfml
  sendGatewayMessage( "quartz-task", { "action": "reload" } );
  ```

  Jobs and listeners are added, updated and removed to match the file; only a changed `store` restarts the scheduler. For a live reload the file has to be the one the gateway reads (in the Docker image `/opt/lucee/server/lucee-server/context/quartz/config.json`), so mount it instead of copying it if you want to work that way.

New or changed job components are compiled on their next run. Alternatively, a `config.quartz` file dropped into the Lucee `deploy` folder is merged into the running configuration within about 10 seconds, see [[scheduler-quartz]].

### Review Before It Runs

A generated job is code that will run unattended, with your credentials, on a schedule. Read it before you deploy it:

- What does it call, and with which credentials? Keys belong in environment variables, see [[environment-variables-system-properties]].
- Does it send, post or delete anything? Start with jobs that only write drafts or log lines, and add the action later, ideally with an approval step.
- Is the schedule what you asked for? Cron expressions are easy to get wrong; the Quartz pages in the Lucee Administrator show the next fire time.
- Can it run twice at the same time? Use `"mode": "transient"` and keep state in a file or database.

## Watching What Jobs Do: Listeners

A Quartz **job listener** is called before and after every run of every job. That is the place for cross-cutting monitoring: durations, failures, and how many AI tokens a job used. See [[component-jobs-quartz-scheduler]] for the listener interface.

The example ships `listeners/JobStatsListener.cfc`, registered in `quartz/config.json`:

```json
"listeners": [
	{
		"component": "listeners.JobStatsListener",
		"outputDirectory": "/opt/lucee/output",
		"tokenWarning": 5000
	}
]
```

After every run it writes one line to `output/job-stats.jsonl` and to the log, and warns when a run failed or used more than `tokenWarning` tokens:

```
JobStats: [Feed watcher] ok in 5624ms, 301 AI tokens
```

```json
{"job":"Feed watcher","finished":"2026-10-19T19:44:50+02:00","durationMs":5624,"status":"ok","error":"","aiTokens":301}
```

The core of the listener:

```cfml
component implementsJava="org.quartz.JobListener" {

	public string function getName() { return "JobStatsListener"; }

	public void function jobToBeExecuted( context ) {
		new JobStats().takeTokens( getLabel( context ) ); // start with a clean counter
	}

	public void function jobWasExecuted( context, jobException ) {
		var run = {
			"job": getLabel( context ),
			"durationMs": context.getJobRunTime(),
			"status": isNull( jobException ) ? "ok" : "error",
			"aiTokens": new JobStats().takeTokens( getLabel( context ) )
		};
		fileAppend( variables.outputDirectory & "/job-stats.jsonl", serializeJSON( run ) & chr( 10 ) );
	}

	public void function jobExecutionVetoed( context ) {}
}
```

Duration and errors come from Quartz itself (a component job that throws reaches the listener as `jobException`). Token usage has to come from the job: after an AI call it reports what the session used to a small shared counter (`listeners/JobStats.cfc`), and the listener collects it after the run:

```cfml
var aiSession = createAISession( name: "watcher", systemMessage: "..." );
var answer = inquiryAISession( aiSession, question );
new listeners.JobStats().addTokens( variables.label, aiSession );
```

`addTokens()` adds up the token count of every answer in the session's history:

```cfml
for ( var conversation in aiSession.getHistory() ) {
	tokens += conversation.getResponse().getTotalTokenUsed();
}
```

Note that `getHistory()` and `getTotalTokenUsed()` are Java methods of the AI session object, not documented CFML functions, so they may change between versions; the example catches a failure and then counts 0. There is no built-in CFML listener for AI connections that reports token usage; the `listener` argument of [[function-inquiryaisession]] receives the streamed answer chunks, not usage.

Ideas for the same listener: a daily token budget per job (pause the job via the gateway when it is exceeded), a notification after three failures in a row, or writing the rows to a datasource for a dashboard.

## Reaching Outside Services: MCP and Plain HTTP

Jobs usually need data from somewhere else. Two ways work well.

### Plain HTTP

Most services have an HTTP API or a feed, and a job does not need more than `http` plus parsing:

```cfml
// JSON API
http url=variables.apiUrl method="get" timeout=20 result="local.res" {
	httpparam type="header" name="Authorization" value="Bearer #server.system.environment.MY_API_TOKEN#";
}
var data = deserializeJSON( res.fileContent );

// RSS / Atom feed
http url=variables.feedUrl timeout=20 result="local.res";
var items = xmlSearch( xmlParse( res.fileContent ), "//item" );
for ( var item in items ) {
	log log="scheduler" text=item.title.xmlText;
}
```

For HTML pages without an API, `htmlParse()` turns the page into XML you can query with `xmlSearch()`. Plain HTTP is predictable, cheap, and easy to test; it should be the default.

### MCP

When a service offers an [MCP](https://modelcontextprotocol.io) server, there are two options, see [[mcp]]:

- **Let the AI connection use it.** Claude and OpenAI-compatible connections can pass MCP server references to the provider (configured in the AI connection, see [[mcp]] and [[ai]]). The model then decides which tools to call while answering `inquiryAISession()`. Note that the provider connects to the MCP server from its cloud, so the server has to be publicly reachable over HTTPS.
- **Call the MCP server directly.** MCP over HTTP is JSON-RPC, so a job can call a tool itself with `http`, no AI involved:

```cfml
http url=variables.mcpUrl method="post" timeout=20 result="local.res" {
	httpparam type="header" name="Content-Type" value="application/json";
	httpparam type="body" value=serializeJSON( {
		"jsonrpc": "2.0",
		"id": 1,
		"method": "tools/call",
		"params": { "name": "get_lucee_function", "arguments": { "name": "dateAdd" } }
	} );
}
var result = deserializeJSON( res.fileContent ).result;
var text = result.content[ 1 ].text;
```

Use `"method": "tools/list"` to see which tools a server offers. Servers that require a session handshake or authentication need the matching headers; check the server's documentation.

## The Example Project

The bundled job is only an illustration: `jobs/FeedWatchJob.cfc` runs every 5 minutes, reads a feed (a sample file by default, `FEED_URL` to change it), picks candidates with a keyword rule, asks the AI connection `watcher` whether they need attention and for a short reply draft, and writes the result to `output/drafts.jsonl`. It never sends anything.

The setup is all configuration:

- `lucee-config.json` installs the Quartz extension and defines the AI connection, with key, model and optional URL from environment variables:

```json
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
```

  For an OpenAI-compatible API use `lucee.runtime.ai.openai.OpenAIEngine` with `secretKey` instead of `apiKey`; the readme of the example shows the full entry. For other providers see [[ai]].
- `quartz/config.json` holds the jobs and the listener.
- The Dockerfile copies `jobs/` and `listeners/` into `{lucee-config}/components/`, which is mapped by default, so `jobs.FeedWatchJob` resolves without a mapping.

Patterns worth keeping when you add jobs:

- **Rules first, AI second.** Cheap rules filter the obvious cases; the AI only sees the candidates.
- **Fail soft.** A failing AI call is logged and the job continues with the rule result.
- **Drafts, not actions.** Sending is a separate step you add once you trust the results.
- **Secrets from the environment**, never in the config files or the image.

## Related

- [[scheduler-quartz]] — Quartz overview and configuration
- [[component-jobs-quartz-scheduler]] — component jobs and listeners
- [[ai]] — AI connections and functions
- [[mcp]] — MCP in Lucee
- [[lucee-skill]] — the Lucee skill for AI assistants
- [[Docker]] — Lucee Docker images
