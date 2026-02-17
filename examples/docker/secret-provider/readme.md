# Lucee Secret Provider - Docker Example

This example demonstrates Lucee 7's secret provider feature, showing how to configure and use multiple secret providers simultaneously — including environment variables, JSON files, and AWS services mocked locally via LocalStack.

## What's Included

- `Dockerfile` — Lucee server image with pre-loaded configuration and artifacts
- `docker-compose.yml` — Orchestrates the Lucee server together with LocalStack
- `lucee-config.json` — Configures all secret providers (`env`, `json`, `sm`, `ps`)
- `www/index.cfm` — Live example page demonstrating all providers
- `localstack-init/init.sh` — Seeds LocalStack with example secrets on startup

## Quick Start
```bash
# Build the image first
docker build -t lucee-secret-provider .

# Then start all services
docker compose up -d
```

Then open [http://localhost:8054/index.cfm](http://localhost:8054/index.cfm) to see all secret providers in action.

## Secret Providers Configured

| Name | Provider | Description |
|------|----------|-------------|
| `env` | `EnvVarSecretProvider` | Reads from environment variables |
| `json` | `FileSecretProvider` | Reads from a local JSON file |
| `sm` | `AWSSecretManagerProvider` | AWS Secrets Manager (mocked via LocalStack) |
| `ps` | `AWSParameterStoreProvider` | AWS Parameter Store (mocked via LocalStack) |

## Ports

| Port | Service |
|------|---------|
| `8054` | Nginx (main HTTP) |
| `8854` | Tomcat (direct) |
| `4566` | LocalStack (AWS mock) |

## Building and Running Manually

If you prefer to build and run without Docker Compose:
```bash
# Build the image
docker build -t lucee-secret-provider .

# Run the container
docker run -d -p 8054:80 -p 8854:8888 -e LUCEE_ADMIN_PASSWORD=qwerty lucee-secret-provider
```

Note that running without Docker Compose means LocalStack won't be available, so the AWS provider examples (`sm`, `ps`) will fail.

## LocalStack Seeding

On startup, `localstack-init/init.sh` automatically seeds LocalStack with example secrets. If you need to seed manually:
```bash
docker compose exec localstack awslocal secretsmanager create-secret \
  --name "mysecret" \
  --secret-string '{"username":"admin","password":"supersecret"}'
```