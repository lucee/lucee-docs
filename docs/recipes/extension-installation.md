<!--
{
  "title": "Extension Installation",
  "id": "extension-installation",
  "since": "6.1",
  "description": "A comprehensive guide on how to install extensions in Lucee.",
  "keywords": [
    "extension",
    "install",
    "lucee administrator",
    "deploy directory",
    "CFConfig.json",
    "environment variable",
    "system property",
    "hot deployment",
    "automation"
  ],
  "categories": [
    "extensions"
  ],
  "related": [
    "deploying-lucee-server-apps",
    "troubleshooting"
  ]
}
-->

# Extension Installation

Extensions add capabilities to Lucee — JDBC drivers, resource providers (S3, Redis), image handling, PDF generation, and more. You can find available extensions at [download.lucee.org](https://download.lucee.org).

## Standard vs Light vs Zero

The standard Lucee jar bundles common extensions (PDF, image, etc.) so they are available out of the box. 

**Lucee Light** and **Lucee Zero** include no bundled extensions — you must explicitly declare every extension you need. This makes them ideal for containerised deployments where you want full control over what's installed.

Lucee Light includes the Lucee Admin archive (`.lar`), while Zero doesn't, saving about 2Mb.

In order to enable the Admin with Lucee light, you need to install the Admin Extension, which just adds a mapping to the the archive.

You can disable installing the bundled extensions on deploy by setting this ENV var to `false`:

[[content::sysprop-envvar#LUCEE_EXTENSIONS_INSTALL]]

## Version Resolution

Version is optional in all installation methods. When omitted, Lucee resolves the latest **release** version from Maven. SNAPSHOTs are only used as a fallback if no release exists. The resolved version is written back to the server's config file on disk.

> **Note (since 7.0.3.10):** Prior to this fix, a SNAPSHOT would be installed if one existed with a higher version number than the latest release.

**Pinning versions is strongly recommended.** An unpinned extension may install a different version after an upgrade or redeploy

Pinned versions also deploy faster as version resolution requires a remote lookup — pinning avoids that overhead at deploy time.

### Bootstrapping pinned versions

A useful workflow for setting up a new environment:

1. Deploy with extension IDs only (no version)
2. Lucee resolves and installs the latest release, writing the resolved version back to the config file
3. Extract the `extensions` block from the server's `.CFConfig.json` and use those pinned versions in your build config

## Installation Methods

### Lucee Administrator

Navigate to **Extensions > Applications** in the Lucee Server Administrator to install or uninstall extensions interactively.

Best for: one-off installs and exploration. Not suitable for automated deployments.

### `deploy` Directory

Copy an extension file (`.lex`) into `{lucee-installation}/lucee-server/deploy`. Lucee picks it up at startup or within a minute and installs it.

In a Docker image, you can download extensions at build time so they are baked into the image:

```dockerfile
RUN mkdir -p /opt/lucee/server/lucee-server/deploy && \
    wget -nv https://ext.lucee.org/s3-extension-2.0.2.21.lex \
         -O /opt/lucee/server/lucee-server/deploy/s3-extension-2.0.2.21.lex && \
    wget -nv https://ext.lucee.org/image-extension-2.0.0.29.lex \
         -O /opt/lucee/server/lucee-server/deploy/image-extension-2.0.0.29.lex
```

Best for: hot deployment on a running server, scripted installs where you already have the file locally. Some extensions require a restart to take effect.

### `.CFConfig.json`

Define extensions in your `.CFConfig.json` configuration file:

```json
{
  "extensions": [
    {
      "id": "07082C66-510A-4F0B-B5E63814E2FDF7BE",
      "version": "1.0.0.11"
    },
    {
      "id": "60772C12-F179-D555-8E2CD2B4F7428718",
      "path": "/opt/lucee/extensions/redis.extension-3.0.0.51.lex"
    },
    {
      "id": "17AB52DE-B300-A94B-E058BD978511E39E"
    }
  ]
}
```

`name` is always optional. You can provide a `path` to a local file or any Lucee virtual filesystem path (HTTPS, S3, FTP, etc.) instead of resolving from Maven.

**Important:** CFConfig extensions are only processed on a fresh install. They are not re-evaluated on subsequent startups. On a fresh install, Lucee also installs the [bundled extensions](https://github.com/lucee/Lucee/blob/7.0/core/src/main/java/META-INF/MANIFEST.MF#L364). Extensions already installed but absent from the list are left in place — CFConfig only adds, it does not remove.

For Multi-Mode (Server and Web Admin enabled, Lucee 6), add extensions to the server context config at `{lucee-installation}/lucee-server/context/.CFConfig.json`, not the web context.

Best for: declarative, config-as-code setups.

### Environment Variable / System Property

Set `LUCEE_EXTENSIONS` (env var) or `-Dlucee.extensions` (system property) to a comma-separated list of extensions. Lucee re-processes it when the value changes (checked every 10 seconds).

```plaintext
LUCEE_EXTENSIONS=99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6;version=12.2.0.jre8,671B01B8-B3B3-42B9-AC055A356BED5281;version=42.7.3
```

Or with Gradle-style coordinates (7.0.1+):

```plaintext
LUCEE_EXTENSIONS=org.lucee:s3-extension:2.0.2.21,org.lucee:redis-extension:3.0.0.56
```

[[content::sysprop-envvar#LUCEE_EXTENSIONS_INSTALL]]

Best for: Docker/container deployments, CI/CD pipelines, infrastructure-as-code.

## Format Reference

All installation methods that accept extension identifiers support the same formats.

### UUID only (version resolved automatically)

```plaintext
99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6,
671B01B8-B3B3-42B9-AC055A356BED5281
```

### UUID with attributes

```plaintext
99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6;name=MSSQL;label=MS SQL Server;version=12.2.0.jre8,
671B01B8-B3B3-42B9-AC055A356BED5281;name=PostgreSQL;version=42.7.3
```

### Gradle-style coordinates (Lucee 7.0.1+)

```plaintext
org.lucee:lucene-search-extension:3.0.0.163,
org.lucee:redis-extension:3.0.0.56
```

Version can be omitted — `org.lucee:s3-extension` resolves the latest release:

```plaintext
org.lucee:s3-extension,
org.lucee:redis-extension
```

### Custom path

Use `;path=` to load from a specific location instead of Maven. Combine with a UUID or Gradle coordinates:

```plaintext
60772C12-F179-D555-8E2CD2B4F7428718;path=/opt/lucee/extensions/redis.extension-3.0.0.51.lex,
17AB52DE-B300-A94B-E058BD978511E39E;path=https://ext.lucee.org/s3-extension-2.0.1.25.lex,
org.lucee:redis-extension:3.0.0.56;path=s3:///mybucket/extensions/redis.lex
```

All Lucee virtual file systems are supported (local, HTTP/HTTPS, S3, FTP, ZIP/TAR, Git, RAM, etc.).

### Mixed formats

You can combine formats freely:

```plaintext
99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6;version=12.2.0.jre8,
org.lucee:lucene-search-extension:3.0.0.163,
671B01B8-B3B3-42B9-AC055A356BED5281;path=s3:///mybucket/extensions/postgresql.lex
```

## LUCEE_BASE_CONFIG Interaction

When `LUCEE_BASE_CONFIG` is set, Lucee uses that file as the server config instead of the default `.CFConfig.json` in the server context directory. Any config updates — including resolved extension versions written back after install — go to that file.

If your base config is shared, version-controlled, or read-only, this can be a problem. To install extensions without modifying your base config, drop a `.CFConfig.json` snippet into the `deploy/` directory. Lucee imports it, applies the changes to the running server's own config, then deletes the file — leaving your base config untouched.

## Logging and Troubleshooting

Check `{lucee-installation}/lucee-server/context/logs/deploy.log` for details on what was installed and any errors. It defaults to info level and logs all deploy actions including resolved versions.
