<!--
{
  "title": "Lucee Versions and Extensions",
  "id": "versions",
  "since": "7.0",
  "categories": ["system"],
  "description": "List and inspect available Lucee versions and extensions",
  "keywords": [
    "versions",
    "extensions",
    "LuceeVersionsList",
    "LuceeVersionsDetail",
    "LuceeExtension",
    "Maven",
    "S3",
    "upgrade"
  ]
}
-->

# Lucee Versions and Extensions

Lucee provides built-in functions to list available versions and extensions, and to retrieve detailed artifact information. Data is sourced from Maven Central with an S3 fallback.

> **Note**: These are currently internal functions. They will be made public in a future release.

## Version Functions

### `LuceeVersionsList(type)` / `LuceeVersionsDetail(version)`

The generic functions — source-independent. They return a consistent, normalized result regardless of where the data comes from, making them the right choice for most use cases.

**`LuceeVersionsList(type)`** — returns an array of version strings.

| Argument | Type | Required | Description |
|----------|------|----------|-------------|
| `type` | string | No | Filter versions (see type values below) |

**Returns:** Array of version strings

**`LuceeVersionsDetail(version)`** — returns artifact URLs and metadata for a specific version.

| Argument | Type | Required | Description |
|----------|------|----------|-------------|
| `version` | string | Yes | The version string to look up |

**Returns:** Struct with the following keys:

| Key | Description |
|-----|-------------|
| `jar` | URL to the `.jar` artifact |
| `lco` | URL to the `.lco` artifact |
| `pom` | URL to the `.pom` file |
| `lastModified` | Date the artifact was last modified |

**Type values (for all list functions):**

| Value | Description |
|-------|-------------|
| `all` | All available versions |
| `snapshot` | Snapshot versions only |
| `release` | Release versions only |
| `latest` | Latest version per development cycle (any stability) |
| `latest:release` | Latest release per development cycle |
| `latest:snapshot` | Latest snapshot per development cycle |


## Extension Function

### `LuceeExtension(artifact, version)`

Lists available Lucee extensions or retrieves details for a specific one. Data is sourced from Maven only.

> **Future**: A `groupId` argument will be added in a future release to support extensions published under custom Maven group IDs.

| Argument | Type | Required | Description |
|----------|------|----------|-------------|
| `artifact` | string | No | Extension artifact ID (alias: `artifactid`). Omit to list all extensions; provide to list versions of that extension |
| `version` | string | No | Specific version to get details for |

**Returns:**

- No arguments → Array of extension artifact IDs
- `artifact` only → Array of version strings for that extension
- `artifact` + `version` → Struct with artifact details

**Detail struct keys:**

| Key | Description |
|-----|-------------|
| `lex` | URL to the `.lex` artifact |
| `pom` | URL to the `.pom` file |
| `local` | Local cache path (if already downloaded) |
| `lastModified` | Date the artifact was last modified |

---

## Basic Usage

```javascript
// List latest releases per development cycle
versions = LuceeVersionsList("latest:release");
dump(versions);

// Get details for the newest release
detail = LuceeVersionsDetail(versions[len(versions)]);
dump(detail);
```

**Example output for `LuceeVersionsList("latest:release")`:**

```json
["5.0.0.254","5.1.4.19","5.2.9.31","5.3.10.120","5.4.8.2",
 "6.0.4.10","6.1.2.47","6.2.5.48","7.0.2.105-RC","7.1.0.43-BETA","7.2.0.35-ALPHA"]
```

**Example output for `LuceeVersionsDetail("7.2.0.35-ALPHA")`:**

```json
{
  "jar": "https://repo1.maven.org/maven2/org/lucee/lucee/7.2.0.35-ALPHA/lucee-7.2.0.35-ALPHA.jar",
  "lco": "https://repo1.maven.org/maven2/org/lucee/lucee/7.2.0.35-ALPHA/lucee-7.2.0.35-ALPHA.lco",
  "pom": "https://repo1.maven.org/maven2/org/lucee/lucee/7.2.0.35-ALPHA/lucee-7.2.0.35-ALPHA.pom",
  "lastModified": "March, 06 2026 15:40:44 +0100"
}
```

```javascript
// List all available extensions
dump(LuceeExtension());

// List all versions of a specific extension
dump(LuceeExtension("s3-extension"));

// Get details for a specific version
dump(LuceeExtension("s3-extension", "2.0.3.1"));
```

**Example output for `LuceeExtension()`:**

```json
["administrator-extension","ajax-extension","argon2-extension","aws-sm-extension",
 "chart-extension","compress-extension","form-extension","ftp-extension",
 "hibernate-extension","image-extension","lucene-search-extension","mail-extension",
 "mongodb-extension","pdf-extension","s3-extension","websocket-extension","yaml-extension", ...]
```

**Example output for `LuceeExtension("s3-extension", "2.0.3.1")`:**

```json
{
  "lex": "https://repo1.maven.org/maven2/org/lucee/s3-extension/2.0.3.1/s3-extension-2.0.3.1.lex",
  "pom": "https://repo1.maven.org/maven2/org/lucee/s3-extension/2.0.3.1/s3-extension-2.0.3.1.pom",
  "local": "/lucee-server/mvn/org/lucee/s3-extension/2.0.3.1/s3-extension-2.0.3.1.lex",
  "lastModified": "January, 31 2026 17:30:43 +0100"
}
```

---

## Examples

### Check for a Newer Lucee Version

```javascript
versions = LuceeVersionsList("latest:release");
latestVersion = versions[len(versions)];
currentVersion = server.lucee.version;

if (latestVersion != currentVersion) {
    writeOutput("Update available: #latestVersion#");
}
```

### Get the Download URL for the Latest LCO

```javascript
versions = LuceeVersionsList("latest:release");
detail = LuceeVersionsDetail(versions[len(versions)]);
writeOutput("Download: " & detail.lco);
```

### Get the Latest Version of an Extension

```javascript
versions = LuceeExtension("s3-extension");
latest = versions[len(versions)];
detail = LuceeExtension("s3-extension", latest);
writeOutput("Install from: " & detail.lex);
```