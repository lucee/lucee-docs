# Lucee Quartz + AI Connection — Docker Example

A small Lucee server that runs a scheduled job with the [Quartz Scheduler extension](https://github.com/lucee/extension-quartz). Every 5 minutes the job reads a feed, picks the items that look relevant with a simple keyword rule, and asks an [AI connection](https://docs.lucee.org/recipes/ai.html) whether they really need attention and for a short reply draft.

Nothing is posted anywhere. Results go to the log and to `output/drafts.jsonl`, so you decide what to do with them.

The example is meant as a project to work in: add your own jobs by asking an AI coding assistant, and watch them with the included job listener. The recipe [Adding Scheduled Jobs with an AI Assistant (Quartz)](https://docs.lucee.org/recipes/scheduler-quartz-ai-job.html) explains how, including how jobs reach outside services (MCP, plain HTTP).

## What's Included

- `Dockerfile` — Lucee image (`LUCEE_IMAGE` build arg) plus the config files below
- `docker-compose.yml` — builds the image, reads `.env`, mounts `./output`
- `lucee-config.json` — installs the Quartz extension, defines the AI connection `watcher` from env vars, logs to the console
- `quartz/config.json` — the Quartz job definition (cron, component, job arguments)
- `jobs/FeedWatchJob.cfc` — the example job
- `listeners/JobStatsListener.cfc` — Quartz job listener: duration, ok/error and AI tokens of every run
- `listeners/JobStats.cfc` — small shared counter the job reports its AI token usage to
- `data/sample-feed.json` — sample feed used when `FEED_URL` is not set
- `.env.example` — the environment variables

## Quick Start

```bash
cd examples/docker/quartz-ai
cp .env.example .env    # optional, fill in your AI endpoint
docker compose up -d --build
docker compose logs -f lucee
```

Lucee downloads the Quartz extension on first startup, so the container needs network access. The first run is at the next full 5 minutes.

Without an AI key the job still runs: it only uses the keyword rule and logs `AI off`. If the AI call fails (wrong key or model, timeout, no JSON in the answer), the job logs a warning and falls back to the keyword rule.

## Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `AI_SECRET_KEY` | empty | API key for the AI connection; empty means AI off |
| `AI_MODEL` | `claude-sonnet-4-6` (in `.env.example`) | Model name |
| `AI_URL` | empty | Optional base URL; Claude defaults to `https://api.anthropic.com/v1/` |
| `FEED_URL` | empty | JSON feed to check, an array of `{ "id", "title", "body" }`; the bundled sample is used when empty |
| `WATCH_KEYWORDS` | `error,crash,outage,security,urgent,down` | Keywords for the pre filter |
| `LUCEE_ADMIN_PASSWORD` | `qwerty` | Lucee Administrator password |

`.env` is ignored by git, keep your key there or pass it from your secret store.

## AI Provider

The AI connection `watcher` uses Claude (`lucee.runtime.ai.anthropic.ClaudeEngine`) by default.

To use an OpenAI compatible API instead (OpenAI, Ollama, a local gateway, ...), change the AI connection in `lucee-config.json`:

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


## Ports

| Port   | Service           |
|--------|-------------------|
| `8057` | Nginx (main HTTP) |
| `8857` | Tomcat (direct)   |

The example has no web pages; the job runs in the background. The Quartz jobs are visible in the Lucee Administrator.

## Output

- `output/drafts.jsonl` — one JSON line per item that needs attention (`id`, `title`, `attention`, `reason`, `draft`, `source` = `ai` or `rule`)
- `output/job-stats.jsonl` — one JSON line per job run, written by the listener (`job`, `durationMs`, `status`, `error`, `aiTokens`)
- `output/seen.json` — ids already handled, so an item is only checked once. Delete it to check everything again.

## Adding Jobs

Open this folder in an AI coding assistant with the [Lucee skill](https://docs.lucee.org/recipes/lucee-skill.html) and ask, for example: *"Set up a new job that runs every hour, checks X and writes Y to the log."* It adds a component to `jobs/` and an entry to `quartz/config.json`. Review the code, then rebuild (`docker compose up -d --build`).

The Quartz extension does not watch `quartz/config.json`; it reads it at startup. A running server can re-read it with `sendGatewayMessage( "quartz-task", { "action": "reload" } )`, which only works when the file is mounted instead of copied into the image.

## Changing the Schedule

Edit `cron` in `quartz/config.json` (Quartz cron format, with seconds), for example `0 0 8 * * ?` for every day at 8:00, then rebuild.

## Watching the Jobs

`listeners/JobStatsListener.cfc` logs every run (`JobStats: [Feed watcher] ok in 5624ms, 301 AI tokens`) and writes it to `output/job-stats.jsonl`. It warns when a run fails or uses more than `tokenWarning` tokens (set in the `listeners` section of `quartz/config.json`). Token usage is read from the AI session's Java methods (`getHistory()`, `getTotalTokenUsed()`), which are not a documented CFML API.
