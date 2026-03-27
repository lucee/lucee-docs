<!--
{
  "title": "Maven Based Extensions",
  "id": "maven-based-extensions",
  "since": "7.0",
  "categories": ["extensions", "java"],
  "description": "How to build Lucee extensions using Maven instead of OSGi bundles",
  "keywords": [
    "extension",
    "Maven",
    "OSGi",
    "lex",
    "GAVSO",
    "manifest",
    "TLD",
    "FLD",
    "BIF",
    "classloading",
    "dependency"
  ],
  "related": [
    "extension-installation",
    "extension-provider",
    "extension-utilities",
    "loader-api-changes-7"
  ]
}
-->

# Maven Based Extensions

Lucee 7 introduces a new way to build extensions using Maven-based dependency management and classloading instead of OSGi bundles. This approach is simpler to build, easier to debug, and aligns with standard Java tooling.

## Why Maven?

OSGi bundles have their own classloader, which creates isolation but also complexity — particularly around dependency resolution, `Require-Bundle` mismatches, and cold-start failures. The Maven approach uses standard Java classloading and lets Lucee resolve dependencies from Maven coordinates at runtime.

Key benefits:

- **Standard JARs** — no OSGi manifest headers required
- **Maven-style dependency resolution** — familiar tooling, no bundle wiring issues
- **Offline installation** — JARs can be embedded directly inside the `.lex` file
- **Simpler builds** — standard Maven compilation, no Felix runtime to contend with

> **Common OSGi pitfall:** With OSGi bundles, `Require-Bundle` must use the `Bundle-SymbolicName`, NOT the Maven `groupId:artifactId`. These are often completely different strings. Mixing them up causes flaky resolution failures that only surface on cold starts — see [LDEV-6189](https://luceeserver.atlassian.net/browse/LDEV-6189) for a real-world example. The Maven approach eliminates this class of bug entirely.

> **Lucee 7.1 OSGi improvement:** If you do still need OSGi bundles, [LDEV-6044](https://luceeserver.atlassian.net/browse/LDEV-6044) (7.1.0.21+) removes the static system packages list and lets Felix 7.x auto-detect packages from the JVM module system. This fixes long-standing issues where OSGi bundles couldn't import modern JDK packages like `java.util.stream` and `java.time`.

## Extension Structure

Each Maven-based extension publishes **two artifacts** to Maven Central:

| Artifact | Purpose | Example |
| --- | --- | --- |
| `{name}` | The JAR library | `org.lucee:mail` |
| `{name}-extension` | The `.lex` extension package | `org.lucee:mail-extension` |

> **Important:** The `artifactId` must follow the `{name}-extension` pattern (e.g., `crypto-extension`, `jsonata-extension`, `redis-extension`). This is how Lucee discovers extensions when scanning a Maven GroupId (see [[extension-provider]]). Note that GitHub repos use the reverse convention (`extension-{name}`), but the Maven `artifactId` must be `{name}-extension` to match the UUID mapping in `ExtensionProvider.java`.

### Directory Layout

```
{name}-extension/
├── pom.xml                    # Root POM (packaging=pom)
├── build.xml                  # Ant build — handles .lex packaging
├── maven-install.sh           # Local build script
├── source/
│   ├── java/
│   │   ├── pom.xml            # Java POM (packaging=jar)
│   │   └── src/
│   │       └── org/lucee/extension/{name}/
│   ├── tld/                   # Tag Library Definitions (if needed)
│   ├── fld/                   # Function Library Definitions (if needed)
│   └── images/
│       └── logo.png
└── tests/
```

The root POM orchestrates the build. The `source/java/pom.xml` handles actual Java compilation. The `build.xml` assembles everything into the final `.lex` package.

## Manifest Configuration

The extension manifest tells Lucee how to load the extension. Two key settings distinguish the Maven approach from legacy OSGi:

```
Manifest-Version: 1.0
version: "1.0.0.0"
id: "E0ACA85A-22DB-48FF-B2D6CD89D5D1709F"
name: "My Extension"
description: "..."
start-bundles: false
lucee-core-version: "7.0.0.110"
```

### `start-bundles: false`

This tells Lucee **not** to load the extension's JARs as OSGi bundles. Without this, Lucee would attempt to install JARs into the Felix OSGi framework.

### Class Definitions with Maven Coordinates

For extensions that register specific handlers (cache, JDBC, resources, etc.), use `maven:` in the manifest JSON:

```
cache: "[{'class':'org.lucee.extension.aws.dynamodb.DynamoDBCache','maven':'org.lucee:dynamodb:1.0.0.0'}]"
jdbc: "[{'class':'org.postgresql.Driver','maven':'org.postgresql:postgresql:42.7.1'}]"
```

The `maven:` attribute tells Lucee to use Maven-style classloading (via `getRPCClassLoader()`) to find the class, rather than looking for it in OSGi bundles.

## Maven Dependency Format (GAVSO)

Maven coordinates in Lucee use **colon-separated** Gradle-style notation:

```
groupId:artifactId:version
```

The full format with optional fields:

```
groupId:artifactId:version:scope:optional:checksum
```

Multiple dependencies are comma-separated:

```
maven: org.postgresql:postgresql:42.7.1,com.google.guava:guava:32.1.3-jre
```

> **Warning:** The checksum field is the 6th colon-separated value. A checksum like `sha256:abc123` would produce 7 parts and fail parsing. Use a plain hex digest without an algorithm prefix.

### How Lucee Processes Maven Dependencies

1. `ExtensionMetadata` reads the raw `maven:` string from the manifest
2. `MavenUtil.toGAVSOs()` parses it into GAVSO objects (GroupId, ArtifactId, Version, Scope, Optional)
3. At install time, Lucee resolves the JARs — first from the embedded `/maven/` folder inside the `.lex`, then from Maven Central (or configured repositories)

## Embedded Maven Repository

The recommended pattern bundles JARs **inside the `.lex`** in a Maven repository layout. This allows offline installation without requiring internet access at deploy time.

### `.lex` Structure

```
my-extension.lex
├── META-INF/
│   ├── MANIFEST.MF
│   └── logo.png
├── tlds/
│   └── my-tags.tldx
└── maven/
    └── org/
        └── lucee/
            └── mylib/
                └── 1.0.0/
                    ├── mylib-1.0.0.jar
                    ├── mylib-1.0.0.pom
                    └── [transitive dependencies in repo layout]
```

When installing an extension, Lucee looks for `/maven/` (or `/mvn/`) folders in the `.lex` and copies them to the Lucee maven directory (`{lucee-server}/../mvn/`), preserving the repository layout. The JARs are then loaded via standard Java classloading, **not** through Felix OSGi.

### Building the Embedded Repo

The `build.xml` uses Maven's `dependency:copy-dependencies` goal with repository layout:

```xml
<!-- Copy dependencies with Maven repo layout -->
<exec dir="source/java" executable="mvn" failonerror="true">
    <arg value="-DoutputDirectory=${temp}/dependency"/>
    <arg value="-Dmdep.copyPom=true"/>
    <arg value="-Dmdep.useRepositoryLayout=true"/>
    <arg value="-DexcludeScope=provided"/>
    <arg value="dependency:copy-dependencies"/>
</exec>
```

The key flag is `-Dmdep.useRepositoryLayout=true`, which outputs dependencies in the `groupId/artifactId/version/` structure that Lucee expects.

### Embedded vs External Dependencies

| Approach | Pros | Cons |
| --- | --- | --- |
| Embedded `/maven/` | Offline install, self-contained | Larger `.lex` file |
| External `maven:` only | Smaller `.lex`, deduplication | Requires internet at install time |

The recommended pattern uses embedded dependencies — the JAR is bundled with the extension AND loaded via Maven classloading.

## TLD and FLD with Maven

For extensions that provide custom tags (TLD) or Built-In Functions (FLD), the `maven=` attribute on class elements tells Lucee how to load the implementing class:

### TLD Example (Custom Tags)

```xml
<tag>
    <name>mail</name>
    <tag-class maven="org.lucee:mail:1.0.0">org.lucee.extension.mail.tag.Mail</tag-class>
    ...
</tag>
```

### FLD Example (Built-In Functions)

```xml
<function>
    <name>myFunction</name>
    <class maven="org.lucee:mylib:1.0.0">org.lucee.extension.mylib.functions.MyFunction</class>
    ...
</function>
```

> **Note:** `mvn=` is also accepted as an alias for `maven=` in TLD/FLD elements.

### Version Requirements for TLD/FLD Maven Support

The `maven=` attribute was added to TLD/FLD processing in `ClassDefinitionImpl.toClassDefinition()` at different points on each branch:

- **7.1**: TLD tags added in [`d5dfad16b`](https://github.com/lucee/lucee/commit/d5dfad16b) (Nov 2025), FLD functions merged later — available from **7.1.0.2+**
- **7.0**: Both TLD and FLD added together in [`110d788f9`](https://github.com/lucee/lucee/commit/110d788f9) (Feb 2026), follow-up [`1c3f0e2ca`](https://github.com/lucee/lucee/commit/1c3f0e2ca) added `getMavenRaw()` accessor — available from **7.0.2.86+**
- **6.2**: Not available — BIF/tag extensions must use OSGi bundles (see [Lucee 6.2 Compatibility](#lucee-62-compatibility) below)

## Build Flow

The typical build process for a Maven-based extension:

1. **Root `pom.xml`** invoked with `mvn clean install`
2. **Maven Antrun plugin** executes `build.xml`
3. **`build.xml`** orchestrates:
   - Runs Maven in `source/java/` to compile the JAR
   - Copies dependencies to `target/extension/maven/` in repository layout
   - Generates the extension `MANIFEST.MF`
   - Packages everything into a `.lex` file (ZIP format)
4. **Maven deploy** publishes both the JAR and `.lex` to Maven Central

## Version Compatibility

| Feature | Lucee 7.1 | Lucee 7.0 | Lucee 6.2 |
| --- | --- | --- | --- |
| `/maven/` folder extraction from `.lex` | ✅ | 7.0.0.68+ | 6.2.0.300+ |
| Manifest `cache:`/`jdbc:` with `maven:` | ✅ | 7.0.0.68+ | 6.2.0.285+ |
| `start-bundles: false` | ✅ | ✅ | ✅ |
| GAVSO coordinate parsing | ✅ | ✅ | ✅ |
| TLD `maven=` (custom tags) | 7.1.0.2+ | 7.0.2.86+ | ❌ |
| FLD `maven=` (BIF functions) | 7.1.0.2+ | 7.0.2.86+ | ❌ |

### What This Means in Practice

| Extension type | 7.0.2.86+ / 7.1.0.2+ | 7.0.0.68–7.0.2.85 | 6.2.0.285+ |
| --- | --- | --- | --- |
| Cache handler (manifest `cache:`) | ✅ Maven | ✅ Maven | ✅ Maven |
| JDBC driver (manifest `jdbc:`) | ✅ Maven | ✅ Maven | ✅ Maven |
| Resource provider (manifest `resource:`) | ✅ Maven | ✅ Maven | ✅ Maven |
| BIF functions (FLD) | ✅ Maven | ❌ OSGi only | ❌ OSGi only |
| Custom tags (TLD) | ✅ Maven | ❌ OSGi only | ❌ OSGi only |

## Lucee 6.2 Compatibility

For extensions that provide BIF functions or custom tags on Lucee 6.2, the Maven pattern cannot be used for TLD/FLD class resolution. Instead, you need a **shaded OSGi bundle** with all dependencies included.

**Why shading is required:**

- OSGi bundles have their own classloader
- The OSGi classloader cannot see classes in the `/maven/` folder (different classloader)
- Third-party dependencies must be shaded into the OSGi bundle JAR

The approach:

- Use the Maven shade plugin to include dependencies in your extension JAR
- Build as an OSGi bundle with `Bundle-SymbolicName`, `Bundle-Version`, etc.
- Place the shaded JAR in the `/jars/` folder
- Reference the bundle name/version in FLD/TLD files

> **TL;DR:** If you need 6.2 support for BIF/tag extensions, stick with shaded OSGi bundles. For 7.0.2.86+ or 7.1.0.2+, use the Maven pattern.

## Legacy: Bundled JARs

Older extensions use `/jars/`, `/jar/`, `/bundles/`, `/bundle/`, `/lib/`, or `/libs/` folders inside the `.lex` — all six are equivalent. Lucee examines each JAR to determine its type:

| JAR Type | Destination | Loaded Via |
| --- | --- | --- |
| OSGi bundle (has `Bundle-SymbolicName`) | `{lucee-server}/bundles/` | Felix OSGi framework |
| Plain JAR | `{lucee-server}/lib/` | Standard classloader |

The folder name in your extension is purely organisational — Lucee auto-detects based on the JAR's manifest headers.

## Reference Extensions

These extensions demonstrate the Maven pattern and can be used as templates:

- **[Mail](https://github.com/lucee/extension-mail)** — recommended starting point, has TLD files
- **[FTP](https://github.com/lucee/extension-ftp)** — similar pattern to Mail
- **[DynamoDB](https://github.com/lucee/extension-dynamodb)** — cache handler pattern, no TLD/FLD files
- **[Debugger](https://github.com/lucee/extension-debugger)** — debugging extension
