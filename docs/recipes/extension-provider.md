<!--
{
  "title": "Extension Provider",
  "id": "extension-provider",
  "since": "7.2",
  "categories": ["extensions"],
  "description": "How Lucee discovers and loads extensions via Maven",
  "keywords": [
    "extensions",
    "Maven",
    "provider",
    "GroupId",
    "repository",
    "lex",
    "CFConfig"
  ]
}
-->

# Extension Provider

This page describes how Lucee discovers and installs extensions, and how that mechanism has evolved across versions.

## Overview by Version

### Lucee 6.x and earlier

Extension providers were URL endpoints pointing to a custom REST service (provided by the Lucee Association Switzerland). Lucee queried those endpoints to list and download extensions. Providers were configured in the Lucee Administrator under **Extensions › Providers** or in `.CFConfig.json` as a list of URLs.

### Lucee 7.0 and 7.1

Lucee 7.0 and 7.1 can already resolve extensions directly from Maven, but the REST-based provider mechanism remains active as the primary discovery path. The Lucee Association Switzerland continues to operate the legacy REST interface during this transition period, until Lucee 7 reaches LTS status.

### Lucee 7.2+

Lucee 7.2 completes the migration. The legacy REST provider interface is removed entirely, and **Maven is the sole source for extension discovery and delivery**:

- Extensions are published as Maven artifacts (`.lex` files) in Maven repositories.
- The **Extensions › Providers** page in the Lucee Administrator now accepts Maven **GroupIds** instead of URLs.
- Lucee automatically scans each configured GroupId for artifacts whose `artifactId` ends with `-extension` (e.g. `yaml-extension`) and that provide a `.lex` file.
- The default GroupId is `org.lucee`, which covers all official Lucee extensions.

## Extension Identity

From Lucee 7.2, extensions are primarily identified by their Maven coordinates — `groupId` and `artifactId` — rather than by the UUID-based `id` field used in older releases.

The UUID `id` is still supported as a fallback identifier. This matters when installing extensions locally that have no Maven relation at all (e.g. a hand-built or legacy `.lex` file). In that case Lucee falls back to the UUID for identification. For extensions sourced from Maven, the `groupId`/`artifactId` pair is the canonical identity.

## Configuring Extension Providers

### In the Lucee Administrator

Navigate to **Extensions › Providers** and enter one or more Maven GroupIds. Lucee will scan those groups for available extensions.

### In `.CFConfig.json`

```json
{
  "extensionProviders": ["org.lucee", "com.example"]
}
```

### Via System Property

```
-Dlucee.extensionProviders=org.lucee,com.example
```

### Via Environment Variable

```
LUCEE_EXTENSIONPROVIDERS=org.lucee,com.example
```

> **Note:** Lucee automatically derives the environment variable name from the system property name by converting it to upper case and replacing `.` with `_`.

The `extensionProviders` setting accepts a list. Multiple GroupIds allow you to combine official Lucee extensions with extensions published by your organisation or third parties.

## Configuring Maven Repositories

By default, Lucee resolves extensions from the following repositories:

| Repository | Type | URL |
|---|---|---|
| Maven Central | Releases | `https://repo1.maven.org/maven2/` |
| Lucee CDN | Releases & Snapshots | `https://cdn.lucee.org/` |
| Sonatype Snapshots | Snapshots | `https://central.sonatype.com/repository/maven-snapshots/` |

> The Lucee CDN (`https://cdn.lucee.org/`) is a fallback for older extensions that have not yet been published to Maven Central.

### Overriding Repositories

Repository configuration is not yet exposed in the Lucee Administrator UI, but can be set via `.CFConfig.json`, system properties, or environment variables.

#### In `.CFConfig.json`

```json
{
  "maven": {
    "repository": [
      "https://repo1.maven.org/maven2/",
      "https://your-internal-repo.example.com/releases/"
    ],
    "snapshotRepository": [
      "https://central.sonatype.com/repository/maven-snapshots/",
      "https://your-internal-repo.example.com/snapshots/"
    ]
  }
}
```

Both `repository` and `snapshotRepository` accept arrays of URLs.

`repository` can also be specified as `releaseRepository` — both keys are equivalent.

#### Via System Property

```
-Dlucee.mvn.repo.releases=https://repo1.maven.org/maven2/,https://your-repo.example.com/releases/
-Dlucee.mvn.repo.snapshots=https://central.sonatype.com/repository/maven-snapshots/
```

#### Via Environment Variable

```
LUCEE_MVN_REPO_RELEASES=https://repo1.maven.org/maven2/,https://your-repo.example.com/releases/
LUCEE_MVN_REPO_SNAPSHOTS=https://central.sonatype.com/repository/maven-snapshots/
```

### Release vs. Snapshot Repositories

| Setting | Purpose |
|---|---|
| `repository` / `releaseRepository` | Stable release artifacts — Lucee Core (`.lco`), Loader (`.jar`), Extensions (`.lex`), and standard Java libraries. Defaults to Maven Central + Lucee CDN. |
| `snapshotRepository` | Pre-release / snapshot versions for testing and development. Defaults to Sonatype Snapshots (last 90 days). |

## How Extension Discovery Works

When Lucee scans a GroupId for extensions it:

1. Queries the configured release repositories for all artifacts under that GroupId.
2. Filters to artifacts whose `artifactId` ends with `-extension`.
3. Further filters to artifacts that contain a `.lex` file.
4. Lists the matching extensions in the Administrator and makes them available for installation.

For example, the artifact `org.lucee:yaml-extension:1.0.0.0-SNAPSHOT` with a `.lex` attachment would be discovered when `org.lucee` is configured as a provider.

## Migration to Lucee 7.2

If you are upgrading from Lucee 6.x or 7.0/7.1 to 7.2 or later:

1. **Remove URL-based provider entries.** The REST interface is no longer used. Any URL entries in `.CFConfig.json` or the Administrator will be ignored.
2. **Add GroupIds instead.** The default `org.lucee` GroupId is pre-configured and covers all official extensions. You only need to add additional GroupIds for third-party extension publishers.
3. **Repository defaults are sensible.** Unless you need a custom or internal Maven repository, no repository configuration is required.
4. **Locally installed extensions continue to work.** Extensions installed from a local `.lex` file with no Maven relation are still supported; they are identified by their UUID rather than Maven coordinates.

### `.CFConfig.json` before 7.2

```json
{
  "extensionProviders": [
    "https://extension.lucee.org/rest/extension/provider/",
    "https://custom.example.com/extension/provider/"
  ]
}
```

### `.CFConfig.json` from 7.2 onwards

```json
{
  "extensionProviders": ["org.lucee"]
}
```

## Complete Configuration Reference

| Key | Location | Type | Default | Description |
|---|---|---|---|---|
| `extensionProviders` | root | Array of strings | `["org.lucee"]` | Maven GroupIds to scan for extensions |
| `maven.repository` | `maven` object | Array of URLs | Maven Central + Lucee CDN | Repositories for release artifacts |
| `maven.snapshotRepository` | `maven` object | Array of URLs | Sonatype Snapshots | Repositories for snapshot artifacts |

System property and environment variable equivalents:

| Key | System Property | Environment Variable |
|---|---|---|
| `extensionProviders` | `lucee.extensionProviders` | `LUCEE_EXTENSIONPROVIDERS` |
| `maven.repository` | `lucee.mvn.repo.releases` | `LUCEE_MVN_REPO_RELEASES` |
| `maven.snapshotRepository` | `lucee.mvn.repo.snapshots` | `LUCEE_MVN_REPO_SNAPSHOTS` |

## See Also

- [Extensions](extensions.md)
- [Lucee Administrator](lucee-administrator.md)
- [CFConfig Reference](cfconfig.md)