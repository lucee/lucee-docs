<!--
{
  "title": "Configuration Precedence - Environment Variables, System Properties and the Administrator",
  "id": "configuration-precedence",
  "categories": ["configuration", "server", "devops"],
  "description": "How Lucee resolves settings when the same value is defined as an environment variable, a Java system property, in .CFConfig.json, or via the Administrator.",
  "keywords": [
    "configuration",
    "precedence",
    "override",
    "environment variables",
    "system properties",
    "LUCEE_",
    "CFConfig",
    "Administrator",
    "inspectTemplate"
  ],
  "related": [
    "config",
    "environment-variables-system-properties",
    "running-lucee-system-properties",
    "admin-password"
  ]
}
-->

# Configuration Precedence - Environment Variables, System Properties and the Administrator

When the same setting is defined in more than one place, Lucee picks a single winner. This page documents that order and how it shows up in the Administrator.

For the overall configuration hierarchy (including web config and `Application.cfc`), see [[config]]. For how to set environment variables and system properties, see [[running-lucee-system-properties]]. For the full list of supported names, see [[environment-variables-system-properties]].

## Precedence order

For settings that support environment variables / system properties:

1. **Environment variable or Java system property** (see below for which of the two wins when both are set)
2. **`.CFConfig.json`** / the Lucee Administrator (they share the same config file)
3. **Built-in default**

An environment variable or system property always overrides the same setting in `.CFConfig.json` or the Administrator. Changing the value in the Admin does not clear or replace an env / sysprop value.

### Environment variable vs system property

Lucee resolves a single name through `SystemUtil.getSystemPropOrEnvVar`. Callers pass the dotted system-property form (for example `lucee.inspect.template`). Lookup is:

1. Environment variable with that **exact** name (uncommon for dotted names)
2. Java system property with that name (for example `-Dlucee.inspect.template=always`)
3. Environment variable in **MACRO_CASE** (dots to underscores, uppercased), for example `LUCEE_INSPECT_TEMPLATE`

So for the usual pair `LUCEE_INSPECT_TEMPLATE` and `-Dlucee.inspect.template`, **the system property wins when both are set**.

## Naming

| Form | Example |
|------|---------|
| Environment variable | `LUCEE_INSPECT_TEMPLATE=always` |
| Java system property | `-Dlucee.inspect.template=always` |
| `.CFConfig.json` / Admin key | `"inspectTemplate": "always"` |

Rule of thumb: take the JSON / Admin key, lowercase it with dots between words for the system property (`inspectTemplate` → `lucee.inspect.template`), then uppercase with underscores for the env var (`LUCEE_INSPECT_TEMPLATE`).

## Example: `inspectTemplate`

```bash
# Environment variable
LUCEE_INSPECT_TEMPLATE=always

# Or JVM system property
-Dlucee.inspect.template=always
```

```json
{
  "inspectTemplate": "never"
}
```

With either the env var or the system property set to `always`, Lucee uses `always` even if `.CFConfig.json` or the Administrator says `never`.

## What the Administrator shows

- **Lucee 7.x** — The Administrator still shows the effective value (the env / sysprop one). Saving a different value appears to succeed, but the env / sysprop value remains in effect after reload. There is no read-only indicator.
- **Lucee 8** — The Administrator detects settings that come from an environment variable or system property and treats them as read-only (update attempts fail with a clear error that names the env var / system property).

## Quoting pitfall

Do not wrap values in quotes in `.env` files or JVM arguments. The quotes become part of the value and are not a valid setting:

```bash
# Wrong — value is the five characters "always" including quotes
LUCEE_INSPECT_TEMPLATE="always"
-Dlucee.inspect.template="always"

# Correct
LUCEE_INSPECT_TEMPLATE=always
-Dlucee.inspect.template=always
```

The same applies to CommandBox `.env` / `server.json` and similar loaders: the value Lucee receives must be the bare token (`always`, `never`, `auto`, …).

## Exception: Admin password

`LUCEE_ADMIN_PASSWORD` / `-Dlucee.admin.password` is an exception to the general rule. It is only used as a **fallback** when no password is already set in `.CFConfig.json` (`hspw` / `salt`). It does not override an existing hashed password. See [[admin-password]].

## How to check what Lucee sees

```cfml
dump( server.system.environment.LUCEE_INSPECT_TEMPLATE ?: "not set" );
dump( server.system.properties[ "lucee.inspect.template" ] ?: "not set" );
```

Replace the names with the setting you are debugging. Also check `.CFConfig.json`, and any `.env` / `.cfconfig.json` / `server.json` that CommandBox or your process manager loads, for the same key.
