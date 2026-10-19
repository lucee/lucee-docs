# Lucee Quartz + AI Connection — Docker Example

A small Lucee server that runs a scheduled job with the [Quartz Scheduler extension](https://github.com/lucee/extension-quartz). Every 5 minutes the job reads a feed, picks the items that look relevant with a simple keyword rule, and asks an [AI connection](https://docs.lucee.org/recipes/ai.html) whether they really need attention and for a short reply draft.

Nothing is posted anywhere. Results go to the log and to `output/drafts.jsonl`, so you decide what to do with them.

The recipe [Scheduled AI Jobs with Quartz](https://docs.lucee.org/recipes/scheduler-quartz-ai-job.html) walks through the example.

## What's Included

- `Dockerfile` — Lucee image (`LUCEE_IMAGE` build arg) plus the config files below
- `docker-compose.yml` — builds the image, reads `.env`, mounts `./output`
- `lucee-config.json` — installs the Quartz extension, defines the AI connection `watcher` from env vars, logs to the console
- `quartz/config.json` — the Quartz job definition (cron, component, job arguments)
- `jobs/FeedWatchJob.cfc` — the job
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

Without an AI endpoint the job still runs: it only uses the keyword rule and logs `AI off`. If the AI call fails (wrong URL, timeout, invalid JSON), the job logs a warning and falls back to the keyword rule.

## Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `AI_URL` | empty | Base URL of an OpenAI compatible API, for example `https://api.example.com/v1/` |
| `AI_SECRET_KEY` | empty | API key for that endpoint |
| `AI_MODEL` | empty | Model name |
| `FEED_URL` | empty | JSON feed to check, an array of `{ "id", "title", "body" }`; the bundled sample is used when empty |
| `WATCH_KEYWORDS` | `error,crash,outage,security,urgent,down` | Keywords for the pre filter |
| `LUCEE_ADMIN_PASSWORD` | `qwerty` | Lucee Administrator password |

`.env` is ignored by git, keep your key there or pass it from your secret store.

## Ports

| Port   | Service           |
|--------|-------------------|
| `8057` | Nginx (main HTTP) |
| `8857` | Tomcat (direct)   |

The example has no web pages; the job runs in the background. The Quartz jobs are visible in the Lucee Administrator.

## Output

- `output/drafts.jsonl` — one JSON line per item that needs attention (`id`, `title`, `attention`, `reason`, `draft`, `source` = `ai` or `rule`)
- `output/seen.json` — ids already handled, so an item is only checked once. Delete it to check everything again.

## Changing the Schedule

Edit `cron` in `quartz/config.json` (Quartz cron format, with seconds), for example `0 0 8 * * ?` for every day at 8:00, then rebuild.
