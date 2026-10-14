# LuCLI Technical Specification

```
name: "LuCLI"
repository: "https://github.com/cybersonic/LuCLI"
docs: "https://lucli.dev/docs/"
author: "Mark Drew"
```

---

## Distribution

| Format | Details |
|---|---|
| Runnable JAR | `lucli.jar` – fat JAR with all dependencies bundled |
| Self-contained binary | `lucli` (Linux/macOS) / `lucli.bat` (Windows) |
| Build output | `target/lucli.jar`, `target/lucli`, `lucli-<version>.jar` (no deps) |

**Requirements:** Java 17+. Maven 3.x only needed to build from source.

**Install (latest):**

```sh
curl -LsSf https://lucli.dev/install.sh | sh
# Windows:
powershell -ExecutionPolicy Bypass -NoProfile -Command "irm https://lucli.dev/install.ps1 | iex"
```

**Install specific version:**

```sh
LUCLI_VERSION=0.2.1 curl -LsSf https://lucli.dev/install.sh | sh
```

**Build from source:**

```sh
./build.sh
```

---

## Command Shape

```
lucli <group> <command> [options] [arguments]
lucli <file.cfs|cfm|cfc> [args...]
lucli <module-name> [args...]
lucli <script.lucli>
```

### Command Precedence (unrecognized input)

1. Known subcommands (`server`, `modules`, `terminal`, `cfml`, `help`)
2. `.lucli` batch script files
3. CFML files (`.cfs`, `.cfm`, `.cfc`)
4. Module shortcuts (`~/.lucli/modules/`)
5. Error – show help

### Global Options

| Flag | Short | Description |
|---|---|---|
| `--verbose` | `-v` | Verbose output |
| `--debug` | `-d` | Debug output |
| `--timing` | `-t` | Timing/performance output |
| `--help` | `-h` | Show help |
| `--version` | | LuCLI version |
| `--lucee-version` | | Lucee version |

### Exit Codes

| Code | Meaning |
|---|---|
| `0` | Success |
| `1` | General error (file not found, execution error) |
| `2` | Invalid command or arguments |

---

## CFML Execution

### File Extensions

| Extension | Type |
|---|---|
| `.cfs` | CFML script – preferred for CLI tools; `ARGS` array injected |
| `.cfm` | CFML template (mixed CFML/HTML) |
| `.cfc` | CFML component |
| `.lucli` | LuCLI batch script |

### ARGS Array (`.cfs` files only)

```
ARGS[1]  = script filename
ARGS[2]  = first argument
ARGS[3]  = second argument
...
```

### Built-in Script Variables

| Variable | Value |
|---|---|
| `__scriptDir` | Directory of the executing script |
| `__cwd` | Current working directory when lucli was invoked |
| `__argumentCount` | Number of arguments passed |

### `.lucli` Batch Scripts

- Shebang: `#!/usr/bin/env lucli`
- Comments: `#`
- Each line executes as a lucli command
- Sequential, non-interactive
- No error halt on failure

### Engine Initialization

Lucee engine starts fresh per invocation: ~0.8 seconds cold-start overhead.

---

## Module System

### File Layout

```
~/.lucli/modules/<module-name>/
    Module.cfc          # required entry point
    module.json         # optional metadata / permissions
    README.md           # optional
```

### `Module.cfc` Structure

```cfml
component extends="modules.BaseModule" {

    function init(
        boolean verboseEnabled = false,
        boolean timingEnabled  = false,
        string  cwd            = "",
        any     timer
    ) {
        // LuCLI calls this; super.init() handles storage in variables.*
        return this;
    }

    function main(/* named args mapped from CLI */) { }

    function <subcommand>(/* named args */) { }
}
```

### `init()` Parameters

| Parameter | Type | Description |
|---|---|---|
| `verboseEnabled` | boolean | `true` when `--verbose` flag present |
| `timingEnabled` | boolean | `true` when `--timing` flag present |
| `cwd` | string | Working directory at invocation time |
| `timer` | any | Timing helper: `.start(label)` / `.stop(label)` |

### `modules.BaseModule` Helpers

| Helper | Signature | Description |
|---|---|---|
| `out` | `out(message, color?, style?)` | Print to stdout |
| `err` | `err(message)` | Print to stderr |
| `verbose` | `verbose(message)` | Print only when `--verbose` |
| `getEnv` | `getEnv(key, default="")` | Read env alias or system env |
| `getSecret` | `getSecret(name, default="")` | Read injected secret alias |
| `getAbsolutePath` | `getAbsolutePath(cwd, path)` | Resolve relative path against cwd |

Variables available after `super.init()`: `variables.verboseEnabled`, `variables.timingEnabled`, `variables.cwd`, `variables.timer`.

### CLI → CFML Argument Mapping

| CLI form | CFML result |
|---|---|
| `key=value` | named arg `key = "value"` |
| `--key=value` | named arg `key = "value"` |
| `--key` | boolean arg `key = true` |
| `--no-key` | boolean arg `key = false` |
| positional (no `=`, no `-`) after subcommand | `arg1`, `arg2`, `arg3`… |

First non-flag arg that doesn't contain `=` → **subcommand** name (defaults to `main`).

### `module.json` Permissions

```json
{
  "permissions": {
    "env": [
      { "alias": "MY_VAR", "required": true, "description": "..." }
    ],
    "secrets": [
      { "alias": "MY_TOKEN", "required": true, "description": "..." }
    ]
  }
}
```

Shorthand arrays: `"envVars": ["MY_VAR"]`, `"secrets": ["MY_TOKEN"]`

### `.env.lucli` (project-level env for modules)

```
MY_VAR=plainvalue
MY_SECRET=#secret:secretName#
```

### Module Commands

```sh
lucli modules init <name>           # scaffold new module
lucli modules list                  # list installed modules
lucli modules run <name> [args...]  # run (full syntax)
lucli <name> [args...]              # shortcut
lucli modules install <name> --url=<git-url>[#ref]
lucli modules update <name> --url=<git-url>[#ref] [--force]
lucli modules uninstall <name>
```

---

## LuCLI Home Directory

**Default:** `~/.lucli/`

**Override:**

```sh
export LUCLI_HOME="$HOME/.lucli-custom"
java -Dlucli.home=/tmp/lucli-test -jar lucli.jar ...
```

### Directory Structure

```
~/.lucli/
    servers/            # managed Lucee/Tomcat instances (one dir per server)
    express/            # cached Lucee Express distributions
    deps/
        git-cache/      # shared git clones for dependency installs
    modules/            # globally installed modules
    secrets/
        local.json      # encrypted secrets store (AES-GCM)
    prompts/            # prompt templates for interactive terminal
    settings.json       # user-level settings
    history             # interactive terminal command history
```

### System Commands

```sh
lucli system paths [--json]
lucli system clean [--caches] [--backups] [--all] [--older-than 30d] [--force]
lucli system backup create [--name n] [--exclude-caches] [--progress]
lucli system backup list
lucli system backup verify [BACKUP | --all]
lucli system backup prune [--older-than 30d] [--keep 10] [--force]
lucli system backup restore [BACKUP] [--to /path] [--force]
lucli system inspect [--lucee] [--path .CFConfig.json]
```

Backup archives default to `~/.lucli_backups` (outside `~/.lucli`).  
`system clean` never removes: `servers/`, `modules/`, `secrets/`, `settings.json`.

---

## Server Configuration (`lucee.json`)

Config file resolved from project directory. Auto-created with defaults if missing.

### Top-level Keys

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | string | project folder name | Server identity; used as `~/.lucli/servers/<name>/` |
| `lucee.version` | string | `6.2.2.91` | Lucee Express version |
| `port` | integer | `8080` | HTTP port (auto-adjusted to avoid conflicts) |
| `shutdownPort` | integer | `port + 1000` | Tomcat shutdown port |
| `webroot` | string | `"./"` | Webroot/docBase; relative to project dir or absolute |
| `host` | string | `localhost` | Hostname for URL construction and HTTPS cert SAN |
| `openBrowser` | boolean | `true` | Auto-open browser after server start |
| `openBrowserURL` | string | (computed) | Override URL for browser open |
| `enableLucee` | boolean | `true` | `false` = static file server only (no CFML) |
| `enableRest` | boolean | `false` | Enable Lucee REST servlets |
| `configurationFile` | string | not set | Path to external CFConfig JSON (base) |
| `configuration` | object | `null` | Inline CFConfig JSON; merged over `configurationFile` |
| `envFile` | string | `.env` | Env file for `${VAR}` substitution in `lucee.json` |
| `envVars` | object | `{}` | Extra env vars injected into Tomcat process |
| `runtime` | string/object | `"lucee-express"` | Runtime provider |
| `monitoring` | object | see below | JMX monitoring |
| `jvm` | object | see below | JVM memory/args |
| `urlRewrite` | object | see below | URL rewriting |
| `admin` | object | see below | Lucee admin exposure |
| `https` | object | disabled | HTTPS config |
| `agents` | object | `{}` | JVM agent definitions |
| `environments` | object | `{}` | Environment-specific overrides |
| `dependencies` | object | `{}` | Production dependencies |
| `devDependencies` | object | `{}` | Dev dependencies |
| `dependencySettings` | object | `{}` | Dependency install behavior |

### `monitoring`

```json
{ "enabled": true, "jmx": { "port": 8999 } }
```

### `jvm`

```json
{ "maxMemory": "512m", "minMemory": "128m", "additionalArgs": [] }
```

`maxMemory` → `-Xmx`, `minMemory` → `-Xms`, `additionalArgs` → appended to `CATALINA_OPTS`.

### `urlRewrite`

```json
{ "enabled": false, "routerFile": "index.cfm" }
```

Uses Tomcat RewriteValve (`rewrite.config`).

### `admin`

```json
{ "enabled": true }
```

`true` → Lucee admin mapped under `/lucee/` in `web.xml`.

### `agents`

```json
{
  "luceedebug": {
    "enabled": false,
    "jvmArgs": ["-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:9999"],
    "description": "Lucee step debugger agent"
  }
}
```

### `https` (minimal)

```json
{ "enabled": true }
```

Optional `host` field sets hostname for cert SAN.

### Environment Overrides

Defined under `environments.<name>`. Activated with `--env=<name>`.

**Configuration load order:**

1. LuCLI built-in defaults
2. `configurationFile` (if set)
3. Base `lucee.json`
4. `environments.<name>` override

**Deep merge rules:**

- Nested objects: merged recursively
- Arrays: replaced entirely
- `null` values: remove corresponding base key
- Scalars: replace base value

Environment name saved to `~/.lucli/servers/<name>/.environment`.

### Inline Overrides at Start

```sh
lucli server start port=8081 monitoring.enabled=false jvm.maxMemory=1g
```

Dot-notation for nested keys. Persisted back to `lucee.json`.

---

## Server Lifecycle Commands

```sh
lucli server start [OPTIONS] [PROJECT_DIR] [key=value...]
lucli server run   [OPTIONS]          # foreground (Ctrl+C to stop)
lucli server stop  [-n name | --all]
lucli server restart [-n name]
lucli server status [-n name]
lucli server list  [-r]               # -r = running only
lucli server prune [-a | -n name] [-f]
lucli server log   [-n name] [-f] [-t server|access|error]
lucli server monitor [-n name] [-h host] [-p port] [-r seconds]
lucli server get   [-d dir]
lucli server set   [-d dir] [--dry-run]
```

### `server start` Options

| Option | Description |
|---|---|
| `-v, --version` | Lucee version (e.g. `6.2.2.91`) |
| `-n, --name` | Server instance name |
| `-p, --port` | HTTP port |
| `-f, --force` | Replace existing same-name server |
| `-c, --config` | Config file path (default: `lucee.json`) |
| `--env` | Environment name |
| `--dry-run` | Preview config without starting |
| `--include-lucee` | Include Lucee CFConfig in dry-run |
| `--include-tomcat-web` | Include `web.xml` in dry-run |
| `--include-tomcat-server` | Include `server.xml` in dry-run |
| `--include-all` | All dry-run previews |
| `--no-agents` | Disable all agents |
| `--agents` | Comma-separated agent IDs to enable |
| `--enable-agent` | Enable agent by ID (repeatable) |
| `--disable-agent` | Disable agent by ID (repeatable) |
| `--open-browser` | Open browser after start |
| `--disable-open-browser` | Suppress browser open |
| `--sandbox` | Ephemeral server; does not modify `lucee.json` |

### Server Instance Storage

```
~/.lucli/servers/<name>/
    # Tomcat/Lucee config, logs, HTTPS keystores, rewrite configs
```

CFConfig written to: `lucee-server/context/.CFConfig.json`

---

## Secrets Management

**Store:** `~/.lucli/secrets/local.json` (PBKDF2-HMAC-SHA256 + AES-GCM encrypted)  
**Provider:** `local` (only implemented provider)  
**Non-interactive passphrase:** `LUCLI_SECRETS_PASSPHRASE` env var

### Commands

```sh
lucli secrets init [--reset]
lucli secrets set <name> [--description "..."]
lucli secrets list
lucli secrets get <name> [--show]
lucli secrets rm <name> [-f]
lucli secrets provider list
```

### Placeholder Syntax in `lucee.json`

```
#secret:NAME#
```

Resolved at: `lucli server start`, `lucli server lock` (writes commands).  
NOT resolved at: `server status`, `server stop`, `server list`, `server config get`.

Resolution order in `lucee.json`:

1. Env vars (`#env:VAR#` / `#env:VAR:-default#`)
2. Secrets (`#secret:NAME#`)

**In `configuration` block:** only `#secret:NAME#` resolved; `${...}` left intact for Lucee runtime.

---

## Dependency Management

### `lucee.json` Dependency Sections

```json
{
  "dependencies": {
    "<name>": { "type": "...", ... }
  },
  "devDependencies": { ... },
  "dependencySettings": {
    "useLockFile": false,
    "installPath": "vendor/"
  }
}
```

### Dependency Types

| `type` | Source fields |
|---|---|
| `"cfml"` (git) | `source: "git"`, `url`, `ref`, `subPath`, `installPath`, `mapping` |
| `"extension"` by ID | `id` (Lucee extension UUID) |
| `"extension"` by slug | `slug` |
| `"extension"` by path | `path` (`.lex` file) |
| `"extension"` by URL | `url` (`.lex` download URL) |

### Lock File

`lucee-lock.json` — written when `dependencySettings.useLockFile: true`.  
Contains: resolved version, source, install path, Lucee extension ID.  
Drives `LUCEE_EXTENSIONS` env var injected at server start.

### Git Cache

Location: `~/.lucli/deps/git-cache/` (keyed by name + URL hash)  
Setting: `usePersistentGitCache` in `~/.lucli/settings.json` (default: `true`)  
Clear: `lucli deps prune`

### Commands

```sh
lucli deps install [--env name] [--production] [--force] [--dry-run] [--include-nested-deps]
lucli deps prune
```

### Dependency Mapping → Lucee Mapping

When `mapping` is set on a dependency, it is materialized in the effective `.CFConfig.json` at server start.  
Virtual key normalized with trailing slash (`/framework` → `/framework/`).  
Install path resolved to absolute path relative to project dir.

---

## AI Features

### `lucli ai` Commands

```sh
lucli ai config add [--guided] [--name n] [--type openai] [--model gpt-4o] [--secret-key '#env:KEY#']
lucli ai config list [--show]
lucli ai config defaults [--default-endpoint n] [--default-model n] [--show]
lucli ai prompt --text "..." [--system @file] [--rules-file file] [--rules-folder dir]
                [--skill name|path] [--image file] [--endpoint n] [--json]
                [--output-file path] [--force] [--dry-run]
lucli ai list [--name n]
lucli ai test [--endpoint n]
lucli ai skill path add <dir>
lucli ai skill path list
lucli ai skill list
```

### Prompt Context Assembly

1. **System** = `--system` content + skill `system`
2. **Rules** = `--rules-file` / `--rules-folder` content (appended to system/instruction context)
3. **Task** = `--text` content + skill `text`

### Skill File Format (JSON)

```json
{
  "name": "my-skill",
  "system": "System prompt string.",
  "text": "Default task text.",
  "model": "gpt-4o",
  "temperature": 0.2,
  "timeoutMillis": 10000
}
```

**Precedence:** CLI flags > skill values > configured defaults.

### Skill Lookup Order

1. `--skills-path` directories (left-to-right)
2. `.lucli/skills` (project default)
3. Global skill paths (`lucli ai skill path ...`)
4. Named entries in `~/.lucli/ai/skills.json`

### MCP Module Servers

Modules can expose MCP tool endpoints via `lucli mcp`. See `/docs/ai-features/mcp-module-servers/`.

---

## Shell & Automation

### Completion

```sh
lucli completion bash >> ~/.bashrc
lucli completion zsh >> ~/.zshrc
```

### Daemon Mode

```sh
lucli daemon [--port 10000] [--lsp] [--module ModuleName]
```

**JSON mode protocol** (default, `127.0.0.1:<port>`):

Request (one JSON line per TCP connection):

```json
{"id":"1","argv":["modules","list"]}
```

Response:

```json
{"id":"1","exitCode":0,"output":"..."}
```

**LSP mode:** `--lsp` — speaks Language Server Protocol (Content-Length + JSON-RPC 2.0) over TCP via the specified CFML module.

---

## Settings Reference (`~/.lucli/settings.json`)

| Key | Type | Default | Description |
|---|---|---|---|
| `usePersistentGitCache` | boolean | `true` | Use shared git clone cache for dependencies |

---

## Source Docs

- <https://lucli.dev/docs/>
- <https://github.com/cybersonic/LuCLI>
