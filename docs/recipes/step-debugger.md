<!--
{
  "title": "Step Debugging Lucee with Extension Debugger",
  "id": "lucee-step-debugger",
  "since": "6.2",
  "description": "How to set up and use the Extension Debugger (formerly LuceeDebug) for Lucee CFML, covering both the native extension (7.1+) and the Java agent (6.2+).",
  "keywords": [
    "debugger",
    "DAP",
    "debug adapter protocol",
    "breakpoints",
    "step debugging",
    "VS Code",
    "luceedebug",
    "extension"
  ],
  "categories": ["debugging", "server", "devops"],
  "related": [
    "lucee-editors-IDEs",
    "language-server-protocol",
    "function-breakpoint",
    "function-isdebuggerenabled"
  ]
}
-->

# Step Debugging Lucee with Extension Debugger

Extension Debugger (formerly LuceeDebug) is a [Debug Adapter Protocol (DAP)](https://microsoft.github.io/debug-adapter-protocol/) debugger for Lucee CFML, originally created by [David Rogers](https://github.com/softwareCobbler/luceedebug) and now maintained under the [Lucee organisation](https://github.com/lucee/extension-debugger).

It lets you set breakpoints, step through code, inspect variables, and evaluate expressions — all from VS Code or any DAP-compatible IDE.

There are two ways to run it:

| | Lucee Extension | Java Agent |
| --- | --- | --- |
| **Lucee version** | 7.1+ | 6.2+ |
| **Setup** | Install extension, set env vars | JVM startup flags |
| **JDK required** | No (JRE works) | Yes |
| **Overhead** | Zero when not attached | Bytecode instrumentation at class load |

If you're on Lucee 7.1 or later, use the extension. It's simpler, faster, and supports more features.

## Extension Mode (Lucee 7.1+)

The extension hooks into Lucee's native debug instrumentation. When no debugger is attached, the hooks are JIT-compiled away — close to zero overhead in production.

### Install

Install the extension using one of:

- **Lucee Admin** — search for "debugger" in the extensions page
- **Environment variable** — `LUCEE_EXTENSIONS=org.lucee:debugger-extension`
- **Manual deploy** — download the `.lex` from [Maven Central](https://central.sonatype.com/artifact/org.lucee/debugger-extension) and drop it in your deploy folder

### Configure

Set environment variables and restart Lucee:

```bash
LUCEE_DAP_SECRET=your-secret-here
LUCEE_DAP_PORT=10000
```

| Variable | Required | Description |
| --------- | :-------: | ----------- |
| `LUCEE_DAP_SECRET` | yes | Authentication secret (must match client config) |
| `LUCEE_DAP_PORT` | | Port for DAP server (default: 10000) |
| `LUCEE_DAP_HOST` | | Bind address (default: localhost, use `0.0.0.0` for Docker) |
| `LUCEE_DAP_BREAKPOINT` | | Set to `false` to disable breakpoint instrumentation |
| `LUCEE_DEBUGGER_DEBUG` | | Set to `true` for verbose debug logging |

### Docker

For Docker, bind to `0.0.0.0` and expose the DAP port:

```yaml
services:
  lucee:
    image: lucee/lucee:7.1
    environment:
      LUCEE_DAP_SECRET: my-secret
      LUCEE_DAP_PORT: 10000
      LUCEE_DAP_HOST: 0.0.0.0
      LUCEE_EXTENSIONS: org.lucee:debugger-extension
    ports:
      - "8888:8888"
      - "10000:10000"
```

See the [Docker example](https://github.com/lucee/extension-debugger/tree/main/examples/docker) in the extension repo for a complete working setup.

## Java Agent Mode (Lucee 6.2+)

For older Lucee versions, the debugger runs as a Java agent that instruments bytecode at runtime via JDWP. This requires a full JDK (not JRE).

Download the agent JAR from [Maven Central](https://central.sonatype.com/artifact/org.lucee/debugger-agent) — check there for the latest version, click it, browse, and download `debugger-agent-{version}.jar`.

See the [Java Agent setup guide](https://github.com/lucee/extension-debugger/blob/main/JAVA_AGENT.md) for detailed instructions.

## VS Code Setup

1. Install the [luceedebug extension](https://marketplace.visualstudio.com/items?itemName=DavidRogers.luceedebug) from the VS Code Marketplace

2. Add a debug configuration to `.vscode/launch.json`:

```json
{
    "type": "cfml",
    "request": "attach",
    "name": "Lucee Debugger",
    "hostName": "localhost",
    "port": 10000,
    "secret": "your-secret-here"
}
```

1. Press F5 or click "Start Debugging"

### Launch Options

| Option | Description |
| --------- | ------------- |
| `hostName` | DAP server host (default: localhost) |
| `port` | DAP server port (must match `LUCEE_DAP_PORT`) |
| `secret` | Authentication secret (must match `LUCEE_DAP_SECRET`) |
| `logLevel` | Log verbosity: `error`, `info`, `debug`, `trace` (default: info) |
| `consoleOutput` | Stream console output to debug console (extension mode only, default: true) |
| `logExceptions` | Log exception stacktraces to the debug console (default: true) |
| `pathTransforms` | Map IDE paths to server paths (see below) |

### Path Transforms

When your IDE sees files at different paths than Lucee does (e.g. Docker, remote servers), use `pathTransforms` to map between them:

```json
"pathTransforms": [
  {
    "idePrefix": "/Users/dev/myproject",
    "serverPrefix": "/var/www"
  }
]
```

A breakpoint set on `/Users/dev/myproject/Application.cfc` maps to `/var/www/Application.cfc` on the server. Multiple transforms can be specified — first match wins.

## Features

| Feature | Extension | Agent |
| --------- | :---------: | :-----: |
| Line breakpoints | yes | yes |
| Conditional breakpoints | yes | yes |
| Function breakpoints | yes | no |
| Exception breakpoints | yes | no |
| Step in/out/over | yes | yes |
| Variable inspection | yes | yes |
| Set variable value | yes | no |
| Watch expressions | yes | yes |
| Debug console evaluation | yes | yes |
| Hover evaluation | yes | yes |
| Completions (autocomplete) | yes | no |
| Console output streaming | yes | no |
| `breakpoint()` BIF | yes | no |
| `isDebuggerEnabled()` BIF | yes | no |

## CFML BIFs (Lucee 7.1+)

These BIFs are part of Lucee core — they are always available and safe to call. 

Without the debugger extension installed and active, they simply return `false` and do nothing. You can leave them in production code without any overhead or dependency concerns.

### breakpoint()

[[function-breakpoint]]

Programmatic breakpoint — like JavaScript's `debugger;` statement. Suspends execution when a debugger is attached, allowing inspection of variables.

```cfml
// simple breakpoint
breakpoint();

// labelled breakpoint — shows in the debugger UI
breakpoint( label="before query" );

// conditional — only breaks when the condition is true
breakpoint( condition=( arrayLen( errors ) > 0 ) );
```

Returns `true` if the breakpoint was hit, `false` if skipped (no debugger attached or condition was false).

### isDebuggerEnabled()

[[function-isDebuggerEnabled]]

Returns `true` if DAP debugger support is enabled (via `LUCEE_DAP_SECRET` env var or `lucee.dap.secret` system property). Useful for conditionally including debug logic:

```cfml
if ( isDebuggerEnabled() ) {
    systemOutput( "Debug: processing #arrayLen( items )# items" );
}
```

## Troubleshooting

### Breakpoints Not Binding

Use the command palette and run **"luceedebug: show class and breakpoint info"** to inspect what's happening.

### Conditional Breakpoints

- Conditions that fail (not convertible to boolean, or throw an exception) evaluate to `false`
- Watch out for `x = 42` (assignment) vs `x == 42` (equality check)

### JVM Hangs After Lucee Warmup (Agent Mode)

If you use `LUCEE_ENABLE_WARMUP=true` with the Java agent, the JVM can hang at shutdown because the JDWP native agent blocks waiting to notify a debugger that was never connected.

Two fixes:

1. Add `timeout=10000` to your JDWP args — the agent gives up after 10 seconds if no debugger connected:

```bash
-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:9999,timeout=10000
```

1. The luceedebug agent (3.0.0.5+) automatically detects `LUCEE_ENABLE_WARMUP` and skips initialisation entirely, so no instrumentation or DAP setup happens during warmup.

## Links

- [GitHub: lucee/extension-debugger](https://github.com/lucee/extension-debugger)
- [Changelog](https://github.com/lucee/extension-debugger/blob/main/CHANGELOG.md)
- [Forum: debugger topics](https://dev.lucee.org/tag/debugger)
- [VS Code Extension](https://marketplace.visualstudio.com/items?itemName=DavidRogers.luceedebug)
- [Maven Central: Extension](https://central.sonatype.com/artifact/org.lucee/debugger-extension)
- [Maven Central: Agent](https://central.sonatype.com/artifact/org.lucee/debugger-agent)
- [LDEV-1402](https://luceeserver.atlassian.net/browse/LDEV-1402)
