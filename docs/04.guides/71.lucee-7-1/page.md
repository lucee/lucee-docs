---
title: Lucee 7.1 new features
menuTitle: Lucee 7.1
id: lucee_7_1_overview
related:
- breaking-changes-7-0-to-7-1
---

# Lucee 7.1 - Debugger, Performance & Compatibility

Lucee 7.1 introduces a native step debugger for VS Code, a wave of performance improvements across the compiler, runtime, and components, better Adobe ColdFusion compatibility for Query of Queries, and Java 25 as the new baseline.

## What You Need to Know

- **Native Step Debugger**: Full DAP debugger with breakpoints, variable inspection, and a CFML debug console — directly in VS Code
- **Java 25**: Now the baseline — bundled in Docker images and installers
- **Faster Everything**: Compiler, runtime, JDBC loading, and component instantiation all got faster
- **Lighter Components**: Properties and accessors are now shared per class instead of duplicated per instance — less memory, less GC pressure
- **QoQ Improvements**: Case sensitivity options, engine selection, HSQLDB connection pooling
- **Maven Extensions**: Extension tags and functions can now use Maven coordinates
- **SecretProvider API**: Extended with set, remove, and list operations

## Native Step Debugger

The headline feature. Lucee now has a native [Debug Adapter Protocol (DAP)](https://microsoft.github.io/debug-adapter-protocol/) debugger that integrates directly with VS Code via the [Extension Debugger](https://github.com/lucee/extension-debugger) (formerly LuceeDebug).

**What you get:**

- Line and function breakpoints, including conditional breakpoints
- Break on uncaught exceptions with full cfcatch scope
- A `breakpoint()` BIF for programmatic breakpoints
- Variable inspection, modification, and hover evaluation
- Debug console with autocomplete and live CFML evaluation
- Console output streamed to VS Code

**Zero production overhead.** The debugger uses Lucee's existing ExecutionLog instrumentation with environment variable flags — when it's off, it's completely off. No agent, no polling, no performance hit.

**Setup:**

- Set `LUCEE_DAP_SECRET` (required for authentication)
- Set `LUCEE_DAP_HOST` for Docker deployments
- Install the Extension Debugger

See the [Extension Debugger documentation](https://github.com/lucee/extension-debugger) for full setup instructions.

[LDEV-1402](https://luceeserver.atlassian.net/browse/LDEV-1402)

## Java 25

Java 25 is now the baseline for Lucee 7.1. Docker images and installers bundle Java 25.

Java 21 still works, but 25 gives you the best performance and is what we test against.

[LDEV-6110](https://luceeserver.atlassian.net/browse/LDEV-6110)

## Performance

Lucee 7.1 includes a broad set of performance improvements. Most of these are transparent — your existing code just runs faster.

### CFML Compiler

The compiler is significantly faster, which means quicker first-request times and faster deployments. 

If you've ever waited for a large application to compile on first hit, you'll notice the difference.

[LDEV-5832](https://luceeserver.atlassian.net/browse/LDEV-5832)

### Faster, Lighter Components

Creating CFC instances is now faster and uses less memory. Properties and accessor functions (getters/setters) are generated once per class and shared across all instances, instead of being recreated every time you call `new`.

If your application creates a lot of component instances — and most do — this adds up.

[LDEV-3335](https://luceeserver.atlassian.net/browse/LDEV-3335)

### Runtime

Under the hood, a long list of internal optimisations make queries return faster, concurrent requests scale better, and the engine produces less garbage for the JVM to clean up. None of these require any changes to your code.

## Query of Queries

### Case Sensitivity

QoQ string comparisons (`LIKE`, `=`, `<>`, `IN`) have always been case-insensitive in Lucee. Adobe ColdFusion has been case-sensitive since ColdFusion MX 7.

You can now enable case-sensitive comparisons, configurable at three levels:

- **Per-query** via `dbtype` struct
- **Per-application** via `this.query.qoq` in Application.cfc
- **Server-wide** via environment variable

See [[query-of-queries]] for full configuration details and examples.

[LDEV-6151](https://luceeserver.atlassian.net/browse/LDEV-6151)

### Engine Selection

Explicitly choose which QoQ engine to use instead of relying on auto-fallback:

- `"auto"` — native first, HSQLDB fallback (default, unchanged)
- `"native"` — native only, errors if the SQL isn't supported
- `"hsqldb"` — skip native, go straight to HSQLDB

### HSQLDB Connection Pooling

QoQ queries that fall back to HSQLDB now use a pool of isolated database instances instead of a single synchronised instance. This removes a bottleneck under concurrent load.

- ~2.4x throughput improvement (30k → 79k ops/sec)
- Pool size defaults to the lesser of CPU cores or 8
- Tunable via system property `lucee.qoq.hsqldb.poolsize`

[LDEV-5992](https://luceeserver.atlassian.net/browse/LDEV-5992)

### SQL Functions Reference

See [[query-of-queries-functions]] for the full reference of supported SQL functions and operators.

## Maven Support for Extensions

Extension tags and functions can now use Maven coordinates, making it easier to manage dependencies and integrate with existing Java ecosystems.

[LDEV-6045](https://luceeserver.atlassian.net/browse/LDEV-6045)

## SecretProvider API

The SecretProvider now supports set, remove, and list operations in addition to the existing get. This enables full lifecycle management of secrets from CFML.

See [[secret-management]] for details.

[LDEV-6116](https://luceeserver.atlassian.net/browse/LDEV-6116)

## AI Multipart Content

AI sessions now support sending images, PDFs, and other documents alongside text prompts, and receiving multipart responses (text + generated images). See [[ai]] for details and examples.

## Core Functionality Moved to Extensions

Some functionality that was previously baked into the Lucee core has been moved into separate extensions. These still ship with the full/fat JAR, but are now independently updatable. The light/zero distributions do not include them.

- **SMTP** — mail functionality is now in the mail extension
- **FTP** — FTP functionality is now in the FTP extension
- **Compress** — extract/compress functionality (zip, gzip) is now in the compress extension. The `extract()` and `compress()` BIFs are available when the extension is installed ([LDEV-5959](https://luceeserver.atlassian.net/browse/LDEV-5959))
- **HSQLDB** — removed from core ([LDEV-5897](https://luceeserver.atlassian.net/browse/LDEV-5897))
- **JTDS** — old JTDS MSSQL driver removed from fat JAR ([LDEV-6002](https://luceeserver.atlassian.net/browse/LDEV-6002))

## JavaSettings Merge Fix

Previously, JavaSettings defined in Application.cfc would silently replace your cfconfig JavaSettings entirely — losing `bundleDirectory`, `watchInterval`, and any `loadPaths` defined at the system level. This is now fixed: Application.cfc settings properly merge with cfconfig (arrays concatenate, scalars override only when explicitly set).

If you were duplicating cfconfig settings in Application.cfc as a workaround, you may end up with doubled `loadPaths`. There is also an option to customise the merge behaviour.

[LDEV-6091](https://luceeserver.atlassian.net/browse/LDEV-6091)

## Breaking Changes

For the complete list, see [[breaking-changes-7-0-to-7-1]].

## Resources

- [[query-of-queries]] - QoQ guide with configuration options
- [[query-of-queries-functions]] - QoQ SQL functions and operators reference
- [[selective-cache-invalidation]] - Selective cache invalidation
- [[secret-management]] - Secret provider guide
- [[ai]] - AI integration guide
- [[breaking-changes-7-0-to-7-1]] - Breaking changes between 7.0 and 7.1
- [Extension Debugger](https://github.com/lucee/extension-debugger) - Native step debugger for VS Code
- [Lucee 7.1 Changelog](https://download.lucee.org/changelog/?version=7.1) - Full changelog
