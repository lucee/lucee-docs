<!--
{
  "title": "OSGi to Maven Extension Migration",
  "id": "osgi-to-maven-extension-migration",
  "since": "7.0",
  "categories": ["extensions", "java"],
  "description": "Guide for converting a legacy OSGi Lucee extension to a Maven-based extension",
  "keywords": [
    "extension",
    "OSGi",
    "Maven",
    "migration",
    "lex",
    "lite extension",
    "FLD",
    "TLD",
    "BIF",
    "CI",
    "Lucee Light",
    "Lucee Zero"
  ],
  "related": [
    "maven-based-extensions",
    "extension-installation",
    "javax-vs-jakarta",
    "loader-api-changes-7"
  ]
}
-->

# OSGi to Maven Extension Migration

This recipe guides maintainers (and AI-assisted sessions) through converting a legacy OSGi Lucee extension to the **Maven-based extension model** in Lucee 7.

For build file snippets, version matrices, CI configuration, and pitfall details, see the technical specification at [`/docs/technical-specs/maven-extension-migration.yaml`](/docs/technical-specs/maven-extension-migration.yaml).

The worked example is the **[Image extension](https://github.com/lucee/extension-image)** (`3.0.x` OSGi → `3.1.x` Maven). For concepts, see [[maven-based-extensions]].

## When to Migrate

**Migrate** when the extension targets Lucee 7+, you want standard Maven dependency management, and you are ready to drop OSGi bundle wiring.

**Keep an OSGi line** when you must support Lucee 6.2 for BIF/tag extensions, or need a stable bugfix branch for older installs.

A common strategy: bump the major/minor version line for the Maven branch (e.g. Image `3.0.x` for 6.2, `3.1.x` for 7+).

## Minimum Lucee Core Version

The `lucee-core-version` in `MANIFEST.MF` must reflect what your extension actually uses — not a blanket 7.1 for every migration.

| Extension type | Typical minimum | Example |
| --- | --- | --- |
| Manifest handlers only (resource, cache, JDBC) | **7.0.0.68+** | [S3](https://github.com/lucee/extension-s3) declares `7.0.0.211-BETA` |
| BIF functions (FLD with `maven=`) | **7.0.2.86+** | Most function-only extensions |
| **Custom tags (TLD with `maven=`)** | **7.1.0.2+** | Rare — [Image](https://github.com/lucee/extension-image) defines `<cfimage>` |

Image requires **7.1.0.2+** not because Maven extensions in general need 7.1, but because it ships a **TLD with custom tags**. S3-style extensions (manifest-only, no FLD/TLD) follow the **7.0** baseline.

## What Changes

At a high level:

1. **Build** — Maven compiles the JAR; Ant assembles the `.lex` (see [[maven-based-extensions]])
2. **Manifest** — `start-bundles: false`; keep the extension UUID unchanged
3. **FLD/TLD** — replace `bundle-name`/`bundle-version` with `maven="{maven}"`; `build.xml` substitutes coordinates at package time
4. **Dependencies** — move from `libs/` and manual copies into `source/java/pom.xml`
5. **Artifacts** — publish a **full** `.lex` (with embedded `maven/` repo) and optionally a **lite extension** (`.lite.lex`, Maven classifier `lite`)

## Migration Checklist

### 1. Build system
- [ ] Add root `pom.xml` and `source/java/pom.xml`
- [ ] Wire `build.xml` via `maven-antrun-plugin`
- [ ] Ensure `maven-build` depends on `init` (wipes `target/` each build)
- [ ] Copy dependencies with Maven repository layout; run `copy-parent-poms.sh`
- [ ] Package full `.lex` and lite extension `.lite.lex`

### 2. Extension metadata
- [ ] Set `start-bundles: false`
- [ ] Set `lucee-core-version` per table above
- [ ] Keep extension `id` (UUID) unchanged

### 3. FLD / TLD (if applicable)
- [ ] Switch to `maven="{maven}"` on all `<class>` and `<tag-class>` entries
- [ ] Add `javax-tag-class` if dual javax/jakarta tag support is needed

### 4. Dependencies
- [ ] Move JARs into `pom.xml`; `provided` scope for `org.lucee:lucee`
- [ ] Remove `system` scope, manual `build.xml` JAR copies, and legacy `org.lucee` repackages

### 5. Java source
- [ ] Remove OSGi bundle manifest from extension JAR
- [ ] Replace OSGi-specific version lookups

### 6. CI and testing
- [ ] `mvn clean install -Dgoal=install`
- [ ] Test with `lucee/script-runner`, `extensionDir: target/`
- [ ] Upload `target/*.lex` as artifacts

Details for each step: [`maven-extension-migration.yaml`](/docs/technical-specs/maven-extension-migration.yaml).

## Full vs Lite Extension

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

## Testing

```bash
mvn -B -e -f pom.xml clean install -Dgoal=install
ls -lh target/*.lex
```

Run extension tests via script-runner with `extensionDir` pointing at `target/`. Label test components (e.g. `labels="image"`) and pass `testAdditional` for extension-local tests.

If tests use `_internalRequest` for `.cfm` fixtures, paths must use `contractPath()` — not raw filesystem paths. See the tech spec `test_patterns.internal_request` section.

## Common Issues

| Problem | Quick fix |
| --- | --- |
| Old JARs still in `.lex` after dependency removal | `maven-build` must depend on `init`; delete `target/` locally |
| Lite extension fails at runtime offline | Use full `.lex`, or pre-populate `{lucee-server}/../mvn/` |
| Tags fail on 7.0.x | Extension defines TLD tags — requires 7.1.0.2+ |
| `MissingIncludeException` in CI tests | Use `contractPath()` web paths in `_internalRequest` |

Full pitfall reference: tech spec `pitfalls` section.

## Reference Repositories

| Extension | Use as template for |
| --- | --- |
| [extension-s3](https://github.com/lucee/extension-s3) | Manifest-only handler, lite extension, **7.0** baseline |
| [extension-mail](https://github.com/lucee/extension-mail) | Simple Maven migration with TLD |
| [extension-image](https://github.com/lucee/extension-image) | FLD + TLD (custom tags), dependency cleanup, **7.1** minimum |
| [extension-dynamodb](https://github.com/lucee/extension-dynamodb) | Cache handler, no FLD/TLD |
| [extension-ftp](https://github.com/lucee/extension-ftp) | Resource provider |

## AI Session Quick Start

1. Read [[maven-based-extensions]] and [`maven-extension-migration.yaml`](/docs/technical-specs/maven-extension-migration.yaml)
2. Pick the closest reference repo (S3 for manifest-only; Image for FLD+TLD)
3. Determine `lucee-core-version`: **7.0** default; **7.1.0.2+** only if the extension defines TLD custom tags
4. Follow the checklist above; verify `target/*.lex` after build
5. Add a lite extension if transitive dependencies are large
6. Keep the OSGi branch until 6.2 support is officially dropped
