# Lucee S3 Virtual File System — MiniStack Example

This example demonstrates Lucee 7's `s3://` virtual file system working against a local
[MiniStack](https://ministack.org) instance — a free, open-source AWS emulator and
drop-in replacement for LocalStack.

## What's Included

- `Dockerfile` — Lucee server image with S3 extension pre-configured
- `docker-compose.yml` — Orchestrates Lucee + MiniStack + a one-shot init container
- `lucee-config.json` — Registers the S3 extension and resource provider
- `www/index.cfm` — Live demo page exercising S3 file operations
- `ministack-init/init.sh` — Seeds MiniStack with example buckets and objects on startup

## Quick Start

```bash
# Build the image first
docker build -t lucee-s3-ministack .

# Then start all services
docker compose up -d
```

Then open [http://localhost:8854/index.cfm](http://localhost:8854/index.cfm) to see the S3 operations in action.

## Ports

| Port   | Service                  |
|--------|--------------------------|
| `8854` | Tomcat (direct)          |
| `4566` | MiniStack AWS API        |

## How It Works

### Credentials via Environment Variables

Lucee's S3 extension reads credentials from environment variables, so `s3://` paths
in your code don't need to embed credentials:

```
LUCEE_S3_ACCESSKEYID     — MiniStack access key (any value works, we use "test")
LUCEE_S3_SECRETACCESSKEY — MiniStack secret key (any value works, we use "test")
LUCEE_S3_HOST            — MiniStack host:port (ministack:4566 inside Docker)
LUCEE_S3_REGION          — Any region string (us-east-1)
```

These are set in `docker-compose.yml` and picked up by the Lucee container at startup.

### URL Format

With env-var credentials (recommended):
```
s3:///bucket-name/path/to/object.txt
```

With inline credentials (useful outside Docker or for multiple endpoints):
```
s3://ACCESS_KEY:SECRET@host:4566/bucket-name/path/to/object.txt
```

### Using S3 in CFML

Because `s3://` is a virtual file system, every standard Lucee file function works as-is:

```cfscript
// Read
content = fileRead("s3:///my-bucket/hello.txt");

// Write
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

1. **MiniStack** starts and becomes available on port 4566
2. **ministack-init** runs `init.sh`, creates buckets, and seeds example objects
3. **Lucee** starts once `ministack-init` has completed successfully