<!--
{
  "title": "Maven Based Extensions",
  "id": "maven-based-extensions",
  "since": "7.0",
  "categories": ["extensions", "java"],
  "description": "How to build Lucee extensions using Maven instead of OSGi bundles, including migration from legacy OSGi extensions",
  "keywords": [
    "extension",
    "Maven",
    "OSGi",
    "migration",
    "lex",
    "lite extension",
    "GAVSO",
    "manifest",
    "TLD",
    "FLD",
    "BIF",
    "classloading",
    "dependency",
    "CI",
    "Lucee Light",
    "Lucee Zero"
  ],
  "related": [
    "extension-installation",
    "extension-provider",
    "extension-utilities",
    "loader-api-changes-7",
    "javax-vs-jakarta",
    "maven",
    "java-class-interaction"
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

## Maven Based Cache Providers

OSGi-based cache extensions have always registered the cache class alongside the bundle that contains it, so Lucee can resolve the class later when a cache connection is created:

```
cache: "[{'class':'org.lucee.extension.myCache.MyCache','bundle-name':'my.cache.bundle','bundle-version':'1.0.0'}]"
```

Maven-based extensions work the same way — the manifest stores the class name and its Maven coordinates at install time:

```
cache: "[{'class':'org.lucee.extension.aws.dynamodb.DynamoDBCache','maven':'org.lucee:dynamodb:1.0.0.0'}]"
```

When a cache connection is later created using that class name — via the admin UI, application config, or programmatically — Lucee looks up the stored coordinates and loads the class via the Maven classloader.

Full support for all cache creation paths (including programmatic) landed in **7.1.0.93+**, **7.0.4.21+**, and **6.2.7.7+** ([LDEV-6270](https://luceeserver.atlassian.net/browse/LDEV-6270)).

See **[DynamoDB](https://github.com/lucee/extension-dynamodb)** for a complete reference implementation of this pattern.

## Maven Based JDBC Drivers

JDBC extensions (SQL Server, PostgreSQL, MySQL, etc.) are a special case: many installs still run Lucee versions that only understand OSGi `bundleName` / `bundleVersion` in the manifest. The recommended pattern for a **dual-path** JDBC extension is therefore:

1. Ship the **vendor JDBC JAR** under `/maven/` (Maven repository layout inside the `.lex`)
2. Keep **hardcoded OSGi fallback metadata** in the manifest (`bundleName`, `bundleVersion`) so older Lucee can still resolve the driver
3. Add **`maven:`** with the vendor coordinates so Lucee 7.1+ loads the driver via Maven

### Manifest Example (MSSQL)

```
start-bundles: false
jdbc: "[{'id':'mssql','connectionString':'jdbc:sqlserver://{host}:{port}','label':'Microsoft SQL Server (Vendor Microsoft)','class':'com.microsoft.sqlserver.jdbc.SQLServerDriver','bundleName':'org.lucee.mssql','bundleVersion':'12.10.2','maven':'com.microsoft.sqlserver:mssql-jdbc:13.4.0.jre11'}]"
```

| Field | Purpose |
| --- | --- |
| `bundleName` / `bundleVersion` | Fallback for Lucee 6.2 / 7.0 — points at the `org.lucee:*` OSGi wrapper on Maven Central or a bundled `/jars/` copy |
| `maven` | Primary path on Lucee 7.1+ — loads `com.microsoft.sqlserver:mssql-jdbc` directly |
| `class` | JDBC driver class name (same for both paths) |

You do **not** need to embed the OSGi wrapper JAR in `/jars/` if `bundleVersion` references a published `org.lucee:mssql` artifact that older Lucee can download. The vendor driver itself lives under `/maven/`.

> **Reference implementation:** [extension-jdbc-mssql](https://github.com/lucee/extension-jdbc-mssql) — Maven migration with dual manifest, extension CI against Lucee 6.2 / 7.0 / 7.1, and `TestDriverVersion.cfc`.

### How Lucee Chooses Maven vs OSGi

On **Lucee 7.1.0.184+**, when both `maven` and `bundleName` are present in a handler definition, Lucee prefers Maven ([LDEV-6413](https://luceeserver.atlassian.net/browse/LDEV-6413), [`c6fa482`](https://github.com/lucee/Lucee/commit/c6fa482e724c3af63d83eff8bcab5f30cb5a2388)):

- `ClassDefinitionImpl.toClassDefinition()` returns a **Maven** `ClassDefinition` when `maven` is set
- Extension install registers the JDBC driver via `_updateJDBCDriver()` for **both** `isBundle()` and `isMaven()` CDs (7.1.0.187+)
- `loadJDBCDrivers()` loads Maven definitions from config into `getJDBCDrivers()`
- `getJDBCDriverById("mssql")` returns a driver whose `cd.isMaven()` is `true` and `cd.getMavenRaw()` has the GAV string
- Actual class loading uses `cd.getClazz()` → Maven `RPCClassLoader`

On **Lucee 6.2 / 7.0**, the `maven` attribute is ignored for JDBC datasource resolution; only `bundleName` / `bundleVersion` apply.

### JDBC Version Requirements

| Capability | Minimum Lucee version |
| --- | --- |
| Manifest `jdbc:` with `maven:` (parse only) | 6.2.0.285+ / 7.0.0.68+ |
| Datasource / inline JDBC uses `maven` coordinates | **7.1.0.184-SNAPSHOT+** |
| Extension install registers Maven JDBC driver in config | **7.1.0.187-SNAPSHOT+** |
| `admin action="getJDBCDrivers"` exposes `maven` column | **7.1.0.189-SNAPSHOT+** |

### Verifying Registration

```cfml
var jdbc = getPageContext().getConfig().getJDBCDriverById( "mssql", nullValue() );

// Lucee 7.1+ after extension install:
// jdbc.cd.isMaven()     → true
// jdbc.cd.isBundle()    → false
// jdbc.cd.getMavenRaw() → "com.microsoft.sqlserver:mssql-jdbc:13.4.0.jre11"
```

Or via admin:

```cfml
admin action="getJDBCDrivers" type="server" password="..." returnVariable="drivers";
// Query column "maven" populated; bundleName/bundleVersion empty for Maven-registered drivers
```

### Testing JDBC Extensions in CI

A typical extension workflow:

1. `mvn clean install` → produces `target/*.lex` (remove `*.lite.lex` from `extensionDir` if testing the full offline package)
2. Checkout Lucee test sources (`ref: "7.0"` — **quote the ref** in GitHub Actions; unquoted `7.0` is parsed as YAML float `7`)
3. Run `lucee/script-runner` with `extensionDir: target/`, `testLabels: mssql`, `testAdditional: tests/`

Extension-local tests should:

- Use `dbinfo type="version"` against the test datasource for the **runtime** driver version
- Use `createObject( "java", class, { maven: [ gav ] } )` to load Maven driver classes — bare `createObject( "java", class )` fails because the class is not on the default classloader
- **Not** call `bundleInfo()` on Maven-loaded classes — it only works for OSGi bundles; report GAV coordinates instead
- Assert Maven driver version only when `resolution.mode eq "maven"`; skip version prefix checks on 6.2 / 7.0 bundle path

### JDBC Pitfalls (Session Notes)

| Problem | Cause | Fix |
| --- | --- | --- |
| Driver stays on old OSGi version (e.g. `12.2.0`) on 7.1 | [LDEV-6413](https://luceeserver.atlassian.net/browse/LDEV-6413) part 1 fixed parsing, but extension install only registered `isBundle()` CDs | Fixed in Lucee 7.1.0.187+ — register Maven CDs too |
| `REGISTEREDJDBCDRIVER` shows bundle despite Maven mode | Test harness merged manifest `bundleName`/`bundleVersion` fallback into reporting | Read `cd.isMaven()` from `getJDBCDriverById()`; omit manifest bundle fields when Maven is active |
| `createObject("java", driverClass)` → `ClassNotFoundException` on 7.1 | Maven driver not on default classloader | Pass `javasettings: { maven: [ "group:artifact:version" ] }` |
| `bundleInfo()` → *not from an OSGi bundle* | Maven-loaded class | Skip `bundleInfo()` in Maven mode; use GAV from resolution or `dbinfo` |
| `getJDBCDrivers` shows empty/wrong bundle for Maven driver | Admin query only had bundle columns | Fixed 7.1.0.189+ — added `maven` column |
| Dual manifest still useful? | Yes — 6.2 / 7.0 ignore `maven` | Keep `bundleName`/`bundleVersion` in manifest; do not remove OSGi fallback metadata |

### OSGi Fallback Without `/jars/`

For JDBC, the OSGi fallback does not require shipping a Felix bundle inside the `.lex`. A common pattern:

- **`maven:`** embeds `com.microsoft.sqlserver:mssql-jdbc:…` under `/maven/`
- **`bundleName` / `bundleVersion`** reference `org.lucee:mssql:12.10.2` (or similar) published to Maven Central for legacy resolution
- **`start-bundles: false`** — vendor JAR is never installed as an OSGi bundle

This keeps the `.lex` smaller while still supporting Lucee versions that cannot use manifest `maven:` for JDBC.

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

For extensions that provide custom tags (TLD) or Built-In Functions (FLD), the `maven=` attribute on class elements tells Lucee how to load the implementing class.

When migrating from OSGi, replace `bundle-name`/`bundle-version` with `maven="{maven}"` — `build.xml` substitutes the real coordinates at package time.

### TLD Example (Custom Tags)

```xml
<tag>
    <name>mail</name>
    <tag-class maven="{maven}">org.lucee.extension.mail.tag.Mail</tag-class>
    ...
</tag>
```

### FLD Example (Built-In Functions)

```xml
<function>
    <name>myFunction</name>
    <class maven="{maven}">org.lucee.extension.mylib.functions.MyFunction</class>
    ...
</function>
```

> **Note:** `mvn=` is also accepted as an alias for `maven=` in TLD/FLD elements. Add `javax-tag-class` with `maven="{maven}"` if dual javax/jakarta tag support is needed.

### Version Requirements for TLD/FLD Maven Support

- **7.1**: TLD `maven=` on custom tags added in [`d5dfad16b`](https://github.com/lucee/lucee/commit/d5dfad16b) — available from **7.1.0.2+**
- **7.0**: FLD `maven=` for BIF functions added in [`110d788f9`](https://github.com/lucee/lucee/commit/110d788f9) — available from **7.0.2.86+**
- **6.2**: Not available — BIF/tag extensions must use OSGi bundles (see [Lucee 6.2 Compatibility](#lucee-62-compatibility) below)

The **only** reason a Maven extension needs Lucee 7.1 is when it defines **custom tags** with `maven=` on `<tag-class>`. That feature was added with Lucee 7.1. Manifest-only handlers and FLD-based BIF functions can target Lucee 7.0.

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

For build file snippets, CI configuration, and pitfall details, see [`/docs/technical-specs/maven-extension-migration.yaml`](/docs/technical-specs/maven-extension-migration.yaml).

## Version Compatibility

| Feature | Lucee 7.1 | Lucee 7.0 | Lucee 6.2 |
| --- | --- | --- | --- |
| `/maven/` folder extraction from `.lex` | ✅ | 7.0.0.68+ | 6.2.0.300+ |
| Manifest `cache:`/`jdbc:` with `maven:` | ✅ | 7.0.0.68+ | 6.2.0.285+ |
| JDBC datasource uses manifest `maven:` at runtime | 7.1.0.184+ | ❌ (bundle only) | ❌ (bundle only) |
| JDBC extension install registers Maven driver | 7.1.0.187+ | ❌ | ❌ |
| `getJDBCDriverById()` returns Maven CD | 7.1.0.187+ | ❌ | ❌ |
| Maven cache provider (all creation paths) | 7.1.0.93+ | 7.0.4.21+ | 6.2.7.7+ |
| `start-bundles: false` | ✅ | ✅ | ✅ |
| GAVSO coordinate parsing | ✅ | ✅ | ✅ |
| TLD `maven=` (custom tags) | 7.1.0.2+ | ❌ | ❌ |
| FLD `maven=` (BIF functions) | 7.1.0.2+ | 7.0.2.86+ | ❌ |

### Minimum `lucee-core-version`

The `lucee-core-version` in `MANIFEST.MF` must reflect what your extension actually uses — not a blanket 7.1 for every Maven extension.

| Extension type | Typical minimum | Example |
| --- | --- | --- |
| Manifest handlers only (resource, cache, JDBC) | **7.0.0.68+** | [S3](https://github.com/lucee/extension-s3) declares `7.0.0.211-BETA` |
| BIF functions (FLD with `maven=`) | **7.0.2.86+** | Most function-only extensions |
| **Custom tags (TLD with `maven=`)** | **7.1.0.2+** | Rare — [Image](https://github.com/lucee/extension-image) defines `<cfimage>` |

### What This Means in Practice

| Extension type | 7.0.2.86+ / 7.1.0.2+ | 7.0.0.68–7.0.2.85 | 6.2.0.285+ |
| --- | --- | --- | --- |
| Cache handler (manifest `cache:`) | ✅ Maven | ✅ Maven | ✅ Maven |
| JDBC driver (manifest `jdbc:`) | ✅ Maven | ✅ Maven | ✅ Maven |
| Resource provider (manifest `resource:`) | ✅ Maven | ✅ Maven | ✅ Maven |
| BIF functions (FLD) | ✅ Maven | ❌ OSGi only | ❌ OSGi only |
| Custom tags (TLD) | ✅ Maven (7.1 only) | ❌ OSGi only | ❌ OSGi only |

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

> **TL;DR:** If you need 6.2 support for BIF/tag extensions, stick with shaded OSGi bundles. For 7.0.2.86+ (FLD) or 7.1.0.2+ (TLD), use the Maven pattern.

## Legacy: Bundled JARs

Older extensions use `/jars/`, `/jar/`, `/bundles/`, `/bundle/`, `/lib/`, or `/libs/` folders inside the `.lex` — all six are equivalent. Lucee examines each JAR to determine its type:

| JAR Type | Destination | Loaded Via |
| --- | --- | --- |
| OSGi bundle (has `Bundle-SymbolicName`) | `{lucee-server}/bundles/` | Felix OSGi framework |
| Plain JAR | `{lucee-server}/lib/` | Standard classloader |

The folder name in your extension is purely organisational — Lucee auto-detects based on the JAR's manifest headers.

## Migrating from OSGi

This section guides maintainers through converting a legacy OSGi Lucee extension to the Maven-based model. The worked example is the **[Image extension](https://github.com/lucee/extension-image)** (`3.0.x` OSGi → `3.1.x` Maven).

### When to Migrate

**Migrate** when the extension targets Lucee 7+, you want standard Maven dependency management, and you are ready to drop OSGi bundle wiring.

**Keep an OSGi line** when you must support Lucee 6.2 for BIF/tag extensions, or need a stable bugfix branch for older installs.

A common strategy: bump the major/minor version line for the Maven branch (e.g. Image `3.0.x` for 6.2, `3.1.x` for 7+).

### What Changes

1. **Build** — Maven compiles the JAR; Ant assembles the `.lex`
2. **Manifest** — `start-bundles: false`; keep the extension UUID unchanged
3. **FLD/TLD** — replace `bundle-name`/`bundle-version` with `maven="{maven}"`; `build.xml` substitutes coordinates at package time
4. **Dependencies** — move from `libs/` and manual copies into `source/java/pom.xml`
5. **Artifacts** — publish a **full** `.lex` (with embedded `maven/` repo) and optionally a **lite extension** (`.lite.lex`, Maven classifier `lite`)

### Migration Checklist

#### 1. Build system
- [ ] Add root `pom.xml` and `source/java/pom.xml`
- [ ] Wire `build.xml` via `maven-antrun-plugin`
- [ ] Ensure `maven-build` depends on `init` (wipes `target/` each build)
- [ ] Copy dependencies with Maven repository layout; run `copy-parent-poms.sh`
- [ ] Package full `.lex` and lite extension `.lite.lex`

#### 2. Extension metadata
- [ ] Set `start-bundles: false`
- [ ] Set `lucee-core-version` per table above
- [ ] Keep extension `id` (UUID) unchanged

#### 3. FLD / TLD (if applicable)
- [ ] Switch to `maven="{maven}"` on all `<class>` and `<tag-class>` entries
- [ ] Add `javax-tag-class` if dual javax/jakarta tag support is needed

#### 4. Dependencies
- [ ] Move JARs into `pom.xml`; `provided` scope for `org.lucee:lucee`
- [ ] Remove `system` scope, manual `build.xml` JAR copies, and legacy `org.lucee` repackages

#### 5. Java source
- [ ] Remove OSGi bundle manifest from extension JAR
- [ ] Replace OSGi-specific version lookups

#### 6. CI and testing
- [ ] `mvn clean install -Dgoal=install`
- [ ] Test with `lucee/script-runner`, `extensionDir: target/`
- [ ] Upload `target/*.lex` as artifacts

Details for each step: [`maven-extension-migration.yaml`](/docs/technical-specs/maven-extension-migration.yaml).

### Full vs Lite Extension

Most Maven extensions publish two install packages:

| Package | File | Contents |
| --- | --- | --- |
| **Full** | `{name}-extension-{version}.lex` | Metadata + embedded `maven/**` JARs |
| **Lite extension** | `{name}-extension-{version}.lite.lex` | Metadata only (no `maven/**`) |

The **lite extension** is for Lucee Light/Zero and Docker setups where dependencies resolve from Maven Central at install time. The **full** `.lex` is for offline/self-contained installs and is what CI typically tests against.

Maven coordinates for the lite extension use classifier `lite`:

```
org.lucee:image-extension:3.1.0.9-BETA:lex        # full
org.lucee:image-extension:3.1.0.9-BETA:lite:lex   # lite extension
```

See [[extension-installation]] for install methods.

### Testing

```bash
mvn -B -e -f pom.xml clean install -Dgoal=install
ls -lh target/*.lex
```

Run extension tests via script-runner with `extensionDir` pointing at `target/`. Label test components (e.g. `labels="image"`) and pass `testAdditional` for extension-local tests.

If tests use `_internalRequest` for `.cfm` fixtures, paths must use `contractPath()` — not raw filesystem paths. See the tech spec `test_patterns.internal_request` section.

### Common Issues

| Problem | Quick fix |
| --- | --- |
| Old JARs still in `.lex` after dependency removal | `maven-build` must depend on `init`; delete `target/` locally |
| Lite extension fails at runtime offline | Use full `.lex`, or pre-populate `{lucee-server}/../mvn/` |
| Tags fail on 7.0.x | Extension defines TLD tags — requires 7.1.0.2+ |
| `MissingIncludeException` in CI tests | Use `contractPath()` web paths in `_internalRequest` |

Full pitfall reference: tech spec `pitfalls` section.

## Reference Extensions

These extensions demonstrate the Maven pattern and can be used as templates:

| Extension | Use as template for |
| --- | --- |
| [extension-mail](https://github.com/lucee/extension-mail) | Simple Maven migration with TLD |
| [extension-s3](https://github.com/lucee/extension-s3) | Manifest-only handler, lite extension, **7.0** baseline |
| [extension-image](https://github.com/lucee/extension-image) | FLD + TLD (custom tags), dependency cleanup, **7.1** minimum |
| [extension-dynamodb](https://github.com/lucee/extension-dynamodb) | Cache handler, no FLD/TLD |
| [extension-jdbc-mssql](https://github.com/lucee/extension-jdbc-mssql) | JDBC driver, dual OSGi + Maven manifest, extension CI |
| [extension-ftp](https://github.com/lucee/extension-ftp) | Resource provider |
| [extension-debugger](https://github.com/lucee/extension-debugger) | Debugging extension |
