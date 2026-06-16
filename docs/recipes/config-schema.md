<!--
{
  "title": "Lucee Config Schema & Environment Variables",
  "id": "config-schema",
  "since": "7.2",
  "categories": ["configuration", "devops", "ai"],
  "description": "Machine-readable JSON Schema and environment-variable catalogs published with every Lucee release on Maven Central — for IDE validation, CI, and AI assistants",
  "keywords": [
    "CFConfig",
    "config-schema",
    "env-vars",
    "JSON Schema",
    "Maven",
    "environment variables",
    "system properties",
    "IDE",
    "validation",
    "AI"
  ],
  "related": [
    "configuration",
    "environment-variables-system-properties",
    "lucee-skill",
    "setting-system-properties-and-env-vars"
  ]
}
-->

# Lucee Config Schema & Environment Variables

Every Lucee Maven release ships two JSON artifacts alongside the JARs:

| Artifact | Maven classifier | Describes |
|----------|------------------|-----------|
| **Config schema** | `config-schema` | Full JSON Schema for `.CFConfig.json` — keys, types, defaults, allowed values |
| **Env vars catalog** | `env-vars` | Every supported system property and environment variable for that Lucee version |

They are generated during the build from Lucee's own configuration model (`Prop` definitions and `sysprop-envvar.json`), so they always match the version you run — not a hand-maintained doc page.

At runtime you can also call `ConfigSchema()` and `EnvVars()` (Lucee 7.2+) to get the same data from a running server.

## Download URLs (Maven Central)

Replace `{version}` with your exact Lucee version string (for example `8.0.0.113-ALPHA`, `7.2.0.57`, `8.0.0.123`):

```
https://repo1.maven.org/maven2/org/lucee/lucee/{version}/lucee-{version}-config-schema.json
https://repo1.maven.org/maven2/org/lucee/lucee/{version}/lucee-{version}-env-vars.json
```

**Examples:**

```
https://repo1.maven.org/maven2/org/lucee/lucee/8.0.0.113-ALPHA/lucee-8.0.0.113-ALPHA-config-schema.json
https://repo1.maven.org/maven2/org/lucee/lucee/8.0.0.113-ALPHA/lucee-8.0.0.113-ALPHA-env-vars.json
```

Browse all files for a version: `https://repo1.maven.org/maven2/org/lucee/lucee/{version}/`

> **Note:** `config-schema` is published from Lucee 8 alpha builds onward. The `env-vars` artifact uses the same Maven layout and is attached in `loader/pom.xml`; it will appear on Maven Central with the next releases that publish it. Until then, generate it locally with `EnvVars()` or from `loader/target/env-vars.json` after a build.

These URL patterns are also listed in [`lucee.skill`](https://docs.lucee.org/lucee.skill) under **Technical Specs** so AI assistants can fetch the correct file for your Lucee version.

---

## Config schema (`config-schema.json`)

JSON Schema Draft 2020-12 for the entire Lucee configuration tree — server and web context, datasources, caches, mappings, AI engines, scheduled tasks, and everything else in `.CFConfig.json`.

Top-level `$id`: `https://lucee.org/schema-strict.json`

Each property includes:

- **type** — string, boolean, number, object, array, …
- **description** — what the setting does
- **default** — value when omitted
- **enum** / **pattern** — allowed values where applicable

`ConfigSchema(strict=true)` (the default) lists canonical Lucee names only. `ConfigSchema(strict=false)` also includes compatibility aliases useful when validating configs imported from other CFML engines.

### IDE validation (VS Code / Cursor)

Pin the schema to your Lucee version in `.vscode/settings.json`:

```json
{
  "json.schemas": [
    {
      "fileMatch": [
        "**/.CFConfig.json",
        "**/lucee-server/**/.CFConfig.json",
        "**/lucee-web/**/.CFConfig.json"
      ],
      "url": "https://repo1.maven.org/maven2/org/lucee/lucee/8.0.0.74-ALPHA/lucee-8.0.0.74-ALPHA-config-schema.json"
    }
  ]
}
```

Replace the URL version when you upgrade Lucee. You get autocomplete, hover docs, and inline errors while editing config.

Other editors with JSON Schema support (IntelliJ, Neovim with schemastore plugins, etc.) accept the same URL.

### CI validation

Validate config before deploy:

```sh
VERSION=8.0.0.74-ALPHA
curl -fsSL "https://repo1.maven.org/maven2/org/lucee/lucee/${VERSION}/lucee-${VERSION}-config-schema.json" -o schema.json
npx ajv validate -s schema.json -d .CFConfig.json --spec=draft2020
```

### AI assistants

When an AI writes or reviews `.CFConfig.json`, point it at the schema for **your** Lucee version instead of guessing keys:

```
Fetch https://repo1.maven.org/maven2/org/lucee/lucee/{version}/lucee-{version}-config-schema.json
and validate the config against it before answering.
```

Combined with [[lucee-skill]] for narrative recipes and [[mcp]] for live function lookup, the schema gives exact allowed structure.

### From a running Lucee server

```cfml
schema = ConfigSchema();           // strict (canonical names)
// schema = ConfigSchema(false);  // include compatibility aliases

fileWrite(getTempDirectory() & "config-schema.json", serializeJSON(schema, true));
```

---

## Environment variables catalog (`env-vars.json`)

Structured catalog of every system property and environment variable Lucee understands for that release — static entries from `sysprop-envvar.json` merged with properties declared on `Prop` definitions in the Java codebase.

Structure:

```json
{
  "$schema": "https://lucee.org/schemas/env-vars-1.json",
  "title": "Lucee System Properties & Environment Variables",
  "entries": [
    {
      "sysprop": "lucee.admin.password",
      "envvar": "LUCEE_ADMIN_PASSWORD",
      "desc": "Password used for the Lucee admin …",
      "category": "security",
      "type": "string",
      "default": null
    }
  ]
}
```

### What you can do with it

| Use case | How |
|----------|-----|
| **Docker / Kubernetes** | Look up the exact `LUCEE_*` env var for a setting instead of guessing the name |
| **Documentation** | Generate env-var tables for your runbook from the JSON for your Lucee version |
| **AI deployment help** | Give the AI the catalog URL so it proposes correct env vars for `docker-compose.yml` or `.CFConfig.json` placeholders |
| **Diff between versions** | Download catalogs for two versions and diff `entries` when upgrading |

### Example: find env var for a setting

```cfml
catalog = EnvVars();
// or fetch from Maven / fileWrite after curl

for (var entry in catalog.entries) {
    if (entry.sysprop == "lucee.thread.virtual") {
        writeOutput(entry.envvar); // LUCEE_THREAD_VIRTUAL
    }
}
```

### AI prompt pattern

```
Before suggesting environment variables for Lucee {version}, fetch:
https://repo1.maven.org/maven2/org/lucee/lucee/{version}/lucee-{version}-env-vars.json
Use only env vars listed in entries[].envvar.
```

---

## Local copies after a build

After `mvn package` or `ant fast` from `/loader`:

```
loader/target/config-schema.json
loader/target/env-vars.json
```

These are the same files attached to the Maven release.

---

## See Also

- [Configuration - CFConfig.json](configuration.md)
- [Environment Variables / System Properties](environment-variables-system-properties.md) — human-readable list (may lag behind the JSON catalog for bleeding-edge versions)
- [Lucee Skill for AI Assistants](lucee-skill.md) — includes Maven URL patterns in the Technical Specs table
- [Setting System Properties and Environment Variables](setting-system-properties-and-env-vars.md)
