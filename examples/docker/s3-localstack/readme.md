# Lucee S3 Virtual File System — LocalStack Example

This example demonstrates Lucee 7's `s3://` virtual file system working against a local
[LocalStack](https://localstack.cloud) instance — a local AWS cloud emulator.

## What's Included

- `Dockerfile` — Lucee server image with S3 extension pre-configured
- `docker-compose.yml` — Orchestrates Lucee + LocalStack + a one-shot init container
- `lucee-config.json` — Registers the S3 extension and resource provider
- `www/index.cfm` — Live demo page exercising S3 file operations
- `localstack-init/init.sh` — Seeds LocalStack with example buckets and objects on startup

## Quick Start

```bash
# Build the image first
docker build -t lucee-s3-localstack .

# Then start all services
docker compose up -d
```

Then open [http://localhost:8854/index.cfm](http://localhost:8854/index.cfm) to see the S3 operations in action.

## Ports

| Port   | Service                  |
|--------|--------------------------|
| `8854` | Tomcat (direct)          |
| `4566` | LocalStack AWS API       |

## How It Works

### Credentials via Environment Variables

Lucee's S3 extension reads credentials from environment variables, so `s3://` paths
in your code don't need to embed credentials:

```
LUCEE_S3_ACCESSKEYID     — LocalStack access key (any value works, we use "test")
LUCEE_S3_SECRETACCESSKEY — LocalStack secret key (any value works, we use "test")
LUCEE_S3_HOST            — LocalStack host:port (localstack:4566 inside Docker)
LUCEE_S3_REGION          — Any region string (us-east-1)
```

These are set in `docker-compose.yml` and picked up by the Lucee container at startup.

### Using S3 in CFML

```cfscript
// Read via virtual file system
content = fileRead("s3:///my-bucket/hello.txt");

// Write via virtual file system
fileWrite("s3:///my-bucket/myfile.txt", "Hello World");

// Native S3 function
content = s3read("my-bucket", "hello.txt");
```

### Extension Registration

`lucee-config.json` registers the S3 extension and resource provider so the `s3://`
scheme is available immediately on startup without visiting the Lucee administrator:

```json
{
    "extensions": [
        {
            "id": "17AB52DE-B300-A94B-E058BD978511E39E",
            "version": "2.1.0.4-BETA",
            "name": "S3 Extension"
        }
    ]
}
```

## Startup Order

Docker Compose ensures services start in the correct order:

1. **LocalStack** starts and passes its healthcheck on `/_localstack/health`
2. **localstack-init** runs `init.sh`, creates buckets, and seeds example objects
3. **Lucee** starts once `localstack-init` has completed successfully