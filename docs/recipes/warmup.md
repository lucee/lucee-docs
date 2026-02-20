<!--
{
  "title": "Warmup",
  "id": "warmup",
  "since": "6.2",
  "categories": ["docker", "configuration", "startup"],
  "description": "Docker warmup and eager config loading for fail-fast validation in Lucee",
  "keywords": [
    "Warmup",
    "Docker",
    "Fail-Fast",
    "Configuration Validation",
    "Container",
    "Startup",
    "onBuild"
  ]
}
-->

# Warmup

Since Lucee 6.2, Lucee includes a native warmup mode designed for containerized (Docker) environments. It performs a full startup cycle — exploding the Lucee JAR, installing bundles and extensions, running the `onBuild` lifecycle hook — then shuts down cleanly. This ensures your Lucee image is fully initialized before deployment.

For general Docker setup and usage, see [Running Lucee with Docker](docker.md). For details on the `onBuild` lifecycle hook, see [Docker onBuild](docker-onbuild.md).

## What's New in Lucee 7

In Lucee 6.2, warmup already performed JAR extraction, extension installation, and `onBuild` execution — but it did **not** validate lazy-loaded configuration sections. A broken datasource or invalid mapping would pass warmup silently and only fail later at runtime when first accessed.

Lucee 7 adds **eager config loading** during warmup: all configuration sections are now forced to load, so any invalid setting produces an immediate error and fails the build.

## Enabling Warmup

Set the environment variable `LUCEE_ENABLE_WARMUP=true` or the system property `lucee.enable.warmup`. The legacy property `lucee.build` is also supported as an alias.

When enabled, the startup sequence is:

1. **Engine Initialization**: Lucee starts normally — loads the config server, installs required extensions
2. **`onBuild` Hook**: If a `Server.cfc` exists, Lucee invokes `onBuild` instead of `onServerStart`
3. **Config Validation** *(Lucee 7)*: All configuration sections are eagerly loaded and validated
4. **Shutdown**: Lucee logs completion and exits cleanly

The official Lucee Docker image runs warmup automatically during image build. See [Running Lucee with Docker](docker.md) for details.

## onBuild vs onServerStart

Lucee supports two lifecycle hooks in `Server.cfc`:

| Method | When It Runs | Purpose |
|--------|-------------|---------|
| `onServerStart(reload)` | Normal startup (runtime) | Runtime initialization |
| `onBuild(reload)` | Warmup only (`LUCEE_ENABLE_WARMUP=true`) | Build-time validation |

During warmup, **only `onBuild` is called**. During normal startup, **only `onServerStart` is called**. This separation lets you put build-time checks in `onBuild` and runtime setup in `onServerStart` without either interfering with the other.

```javascript
// Server.cfc
component {

    public function onBuild(reload) {
        // Runs during warmup (docker build)
        try {
            queryExecute("SELECT 1", {}, { datasource: "myDB" });
        }
        catch (any e) {
            throw(message="Datasource 'myDB' validation failed: #e.message#");
        }
    }
    
    public function onServerStart(reload) {
        // Runs during normal startup (container runtime)
    }
}
```

For more details and examples, see [Docker onBuild](docker-onbuild.md).

## Docker Example

```dockerfile
FROM lucee/lucee:7.0

COPY ./.CFConfig.json /opt/lucee/server/lucee-server/context/.CFConfig.json
COPY ./app /var/www/

# Validate configuration at build time
RUN LUCEE_ENABLE_WARMUP=true /usr/local/tomcat/bin/catalina.sh run
```

If any configuration is invalid, the `RUN` step fails and the Docker build aborts — preventing a broken image from being deployed.

## Upgrading to Lucee 7

Because Lucee 7 now validates all configuration sections during warmup, upgrading may cause your warmup to fail on settings that previously passed silently in Lucee 6.2. This is intended — it surfaces misconfigurations that were always there but hidden by lazy loading. Fix the reported settings and rebuild.

## Related Documentation

- **[Running Lucee with Docker](docker.md)** - Complete Docker setup and configuration guide
- **[Docker onBuild](docker-onbuild.md)** - The `onBuild` lifecycle hook in detail
- **[Extensions](extensions.md)** - Managing Lucee extensions

## Getting Help

- **Community**: Ask questions on the [Lucee Dev forum](https://dev.lucee.org)
- **Issues**: Report bugs on the [Lucee GitHub repository](https://github.com/lucee/Lucee/issues)