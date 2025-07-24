# Lucee Couchbase Cache Demo

This Docker setup demonstrates how to integrate Couchbase as a cache provider with Lucee 7.0 using Docker Compose.

## Quick Start

1. Start the containers:

```bash
docker compose up -d
```

2. Set up Couchbase (one-time setup):

   - Open http://localhost:8091 in your browser
   - Click "Setup New Cluster"
   - Set name: `couchbase`
   - Set username: `Administrator`, password: `password`
   - Accept default settings and finish setup
   - Go to "Buckets" and create a new bucket named `default`

3. Open the Lucee demo:

```
http://localhost:8888
```

## What This Demonstrates

The demo shows Lucee's integration with Couchbase as a cache provider:

### Cache Configuration

- Couchbase configured as a named cache in Lucee
- Connection via Docker network using service discovery
- JSON transcoder for cross-platform compatibility

### Cache Functions

- `cacheGetProperties()` - Inspect cache configuration and status
- Full Lucee cache API available: `cachePut()`, `cacheGet()`, `cacheRemove()`, etc.

## Configuration Details

The Couchbase cache is configured in `lucee-config.json` with:

- **Connection**: `couchbase://couchbase` (Docker service name)
- **Authentication**: Administrator/password
- **Default Bucket**: `default`
- **Transcoder**: JSON (for interoperability)
- **Auto-creation**: Enabled for buckets, scopes, and collections


## File Structure

```
├── docker-compose.yml      # Docker services configuration
├── lucee-config.json       # Lucee configuration
├── extensions/             # Lucee extensions directory 
└── www/
    └── index.cfm           # Demo template showing cache properties
```

## Docker Compose Configuration

```yaml
services:
  lucee:
    image: lucee/lucee:7.0.0.299-SNAPSHOT
    volumes:
      - "./www:/var/www"
      - "./lucee-config.json:/opt/lucee/server/lucee-server/context/.CFConfig.json"
    ports:
      - 8888:8888
    depends_on:
      - couchbase
    environment:
      - COUCHBASE_HOST=couchbase
      - COUCHBASE_PORT=8091
      - LUCEE_ADMIN_PASSWORD=password123

  couchbase:
    image: couchbase:community-7.2.4
    ports:
      - "8091-8096:8091-8096"
      - "11210:11210"
    volumes:
      - couchbase_data:/opt/couchbase/var

volumes:
  couchbase_data:
```

## Lucee Cache Configuration

This is the cache configuraton for Lucee in `lucee-config.json` under the `caches` section:

```json
"caches": {
  "couchbase": {
    "class": "org.lucee.extension.couchbase.Couchbase",
    "bundlename": "lucee.extension.couchbase",
    "bundleVersion": "1.0.0.34-SNAPSHOT",
    "custom": {
      "connectionString": "couchbase://couchbase",
      "username": "Administrator",
      "password": "password",
      "bucketName": "default",
      "scopeName": "",
      "collectionName": "",
      "createIfNecessaryBucket": true,
      "createIfNecessaryScope": true,
      "createIfNecessaryCollection": true,
      "transcoder": "JSON",
      "defaultExpire": "0",
      "connectionTimeout": "10000"
    },
    "readOnly": "false",
    "storage": "true"
  }
}
```

## Performance Notes

- JSON transcoder provides good interoperability but Object transcoder may be faster for Lucee-only usage
- Default expire time of 0 means cache entries never expire
- Connection timeout is set to 10 seconds
- Consider adjusting RAM allocation for production use

## Security Considerations

- Change default admin credentials for production
- Use TLS connection strings (`couchbases://`) for production
- Restrict network access to Couchbase ports
- Consider using Couchbase RBAC for fine-grained permissions