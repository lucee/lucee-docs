# Lucee S3 Virtual File System — MinIO Example

This example demonstrates Lucee 7's `s3://` virtual file system working against a local
[MinIO](https://min.io) instance — a self-hosted, S3-compatible object store.

## What's Included

- `Dockerfile` — Lucee server image with S3 extension pre-configured
- `docker-compose.yml` — Orchestrates Lucee + MinIO + a one-shot init container
- `lucee-config.json` — Registers the S3 extension and resource provider
- `www/index.cfm` — Live demo page exercising all standard S3 file operations
- `ministack-init/init.sh` — Seeds MinIO with example buckets and objects on startup

## Quick Start

```bash
# Build the image first
docker build -t lucee-s3-ministack .

# Then start all services
docker compose up -d
```

Then open [http://localhost:8054/index.cfm](http://localhost:8054/index.cfm) to see the S3 operations in action.

## Ports

| Port   | Service                  |
|--------|--------------------------|
| `8054` | Nginx (main HTTP)        |
| `8854` | Tomcat (direct)          |
| `9000` | MinIO S3 API             |
| `9001` | MinIO Console UI         |

MinIO Console login: `minioadmin` / `minioadmin`

## How It Works

### Credentials via Environment Variables

Lucee's S3 extension reads credentials from environment variables automatically,
so `s3://` paths in your code don't need to embed credentials:

```
LUCEE_S3_ACCESSKEYID     — MinIO access key (MINIO_ROOT_USER)
LUCEE_S3_SECRETACCESSKEY — MinIO secret key (MINIO_ROOT_PASSWORD)
LUCEE_S3_HOST            — MinIO host:port (minio:9000 inside Docker)
LUCEE_S3_REGION          — Any region string (MinIO doesn't enforce this)
```

These are set in `docker-compose.yml` and picked up by the Lucee container at startup.

### URL Format

With env-var credentials (recommended):
```
s3:///bucket-name/path/to/object.txt
```

With inline credentials (useful outside Docker or for multiple endpoints):
```
s3://ACCESS_KEY:SECRET@host:9000/bucket-name/path/to/object.txt
```

### Using S3 in CFML

Because `s3://` is a virtual file system, every standard Lucee file function works as-is:

```cfscript
// Read
content = fileRead("s3:///my-bucket/hello.txt");

// Write
fileWrite("s3:///uploads/myfile.txt", "Hello World");

// Check existence
exists = fileExists("s3:///my-bucket/hello.txt");

// List bucket contents
files = directoryList("s3:///my-bucket/", false, "query");

// Copy between buckets
fileCopy("s3:///my-bucket/hello.txt", "s3:///uploads/hello-copy.txt");

// Delete
fileDelete("s3:///uploads/myfile.txt");
```

### Extension Registration

`lucee-config.json` registers the S3 extension and resource provider so the `s3://`
scheme is available immediately on startup without visiting the Lucee administrator:

```json
{
    "extensions": [
        { "id": "17AB52DE-B300-A94B-E058BD978511E39E", "name": "S3 Extension" }
    ],
    "resourceProviders": [
        {
            "bundleName": "org.lucee.s3.extension",
            "arguments": { "lock-timeout": "10000" },
            "scheme": "s3",
            "class": "org.lucee.extension.resource.s3.S3ResourceProvider"
        }
    ]
}
```

## Startup Order

Docker Compose ensures services start in the correct order:

1. **MinIO** starts and passes its healthcheck
2. **minio-init** runs `init.sh`, creates buckets, and seeds example objects
3. **Lucee** starts once `minio-init` has completed successfully
