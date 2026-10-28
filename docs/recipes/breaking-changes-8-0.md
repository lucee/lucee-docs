<!--
{
  "title": "Breaking Changes between Lucee 7.1 and 8.0",
  "id": "breaking-changes-7-1-to-8-0",
  "categories": ["breaking changes", "migration","compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 7.1 and 8.0",
  "keywords": ["breaking changes", "Lucee 7.1", "Lucee 8.0", "migration", "upgrade", "CFConfig"],
  "related": [
    "tag-application",
    "single-vs-multi-mode",
    "extension-installation",
    "extension-provider",
    "environment-variables-system-properties",
    "configuration-precedence",
    "virtual-threads",
    "upgrade-7-1-to-8-0-agent"
  ]
}
-->

# Breaking Changes between Lucee 7.1 and 8.0

This document outlines the breaking changes introduced when upgrading from Lucee 7.1 to Lucee 8.0. It covers Lucee 8.0 as of the next 8.0 release candidate.

Be aware of these changes when migrating your applications to ensure smooth compatibility.

Upgrading with an AI coding agent? Point it to [[upgrade-7-1-to-8-0-agent]], a step-by-step checklist with search patterns and fixes.

[8.0 Changelog](https://download.lucee.org/changelog/?version=8.0)

[New Functions and Tags](https://docs.lucee.org/reference/changelog.html)

## Other Breaking Changes in Lucee Releases

- [[breaking-changes-5-4-to-6-0]]
- [[breaking-changes-6-0-to-6-1]]
- [[breaking-changes-6-1-to-6-2]]
- [[breaking-changes-6-2-to-7-0]]
- [[breaking-changes-7-0-to-7-1]]

## Java 21 Required

Lucee 8.0 requires **Java 21 or newer**.

| Version | Minimum Java |
| --- | --- |
| Lucee 7.1 | Java 11 |
| Lucee 8.0 | **Java 21** |

Lucee 8.0 is compiled for Java 21 and its OSGi bundle declares `JavaSE-21`, so it will not start on Java 11 or 17.

**What to do:** Upgrade the JVM to Java 21 (LTS) or newer before installing Lucee 8.0.

## Servlet API (Jakarta)

No change from Lucee 7.0 / 7.1. Lucee 8.0 is still Jakarta EE based (Tomcat 10.1+, Jetty 11+, etc.). Javax based containers (Tomcat 9 and older) are still not supported.

See [[javax-jakarta]] and [[breaking-changes-6-2-to-7-0]].

## Configuration (`.CFConfig.json`)

The configuration format is **unchanged**. Lucee 8.0 reads the same `.CFConfig.json` file (or `config.json`) from the same place as 7.1, single mode works as in 7.x, and almost all keys keep their names. Older alias names for a setting are still accepted.

Internally, configuration loading was rewritten: every setting is now described by metadata (name, type, default, environment variable), which is what powers `ConfigSchema()` and `EnvVars()`. That rewrite brings the following changes.

### Some settings must move into their section

Lucee 7.1 read the settings below at the top level of `.CFConfig.json` (the 7.1 Administrator also wrote the debugging settings there). Lucee 8.0 only reads them inside their section.

**There is no error and no warning.** If one of these keys is left at the top level, Lucee 8.0 ignores it and uses the default. For example, debugging options you enabled in 7.1 are simply off after the upgrade.

Move every key you use from the left column to the location on the right:

| 7.1 key (top level) | 8.0 location |
| --- | --- |
| `debuggingDatabase` (alias `debuggingShowDatabase`) | `monitoring.debuggingDatabase` |
| `debuggingException` (alias `debuggingShowException`) | `monitoring.debuggingException` |
| `debuggingTemplate` (alias `debuggingShowTemplate`) | `monitoring.debuggingTemplate` |
| `debuggingDump` (alias `debuggingShowDump`) | `monitoring.debuggingDump` |
| `debuggingTracing` (aliases `debuggingShowTracing`, `debuggingShowTrace`) | `monitoring.debuggingTracing` |
| `debuggingTimer` (alias `debuggingShowTimer`) | `monitoring.debuggingTimer` |
| `debuggingImplicitAccess` (aliases `debuggingImplicitVariableAccess`, `debuggingShowImplicitAccess`) | `monitoring.debuggingImplicitAccess` |
| `debuggingQueryUsage` (alias `debuggingShowQueryUsage`) | `monitoring.debuggingQueryUsage` |
| `debuggingThread` (alias `debuggingShowThread`) | `monitoring.debuggingThread` |
| `showDebug` | `monitoring.showDebug` |
| `showDoc` (aliases `doc`, `documentation`, `showReference`, `reference`) | `monitoring.showDoc` |
| `showMetric` (aliases `showMetrics`, `metric`, `metrics`) | `monitoring.showMetric` |
| `showTest` (aliases `showTests`, `test`) | `monitoring.showTest` |
| `cacheDefaultObject` | `cache.defaultObject` |
| `cacheDefaultQuery` | `cache.defaultQuery` |
| `cacheDefaultTemplate` | `cache.defaultTemplate` |
| `cacheDefaultResource` | `cache.defaultResource` |
| `cacheDefaultFunction` | `cache.defaultFunction` |
| `cacheDefaultInclude` | `cache.defaultInclude` |
| `cacheDefaultFile` | `cache.defaultFile` |
| `cacheDefaultHTTP` | `cache.defaultHTTP` |
| `cacheDefaultWebservice` | `cache.defaultWebservice` |
| `updateProxyHost` | `proxy.server` |
| `updateProxyPort` | `proxy.port` |
| `updateProxyUsername` | `proxy.username` |
| `updateProxyPassword` | `proxy.password` |

Inside their section the old names still work (for example `cacheDefaultQuery` inside `cache`, or `updateProxyHost` inside `proxy`). Only the location matters.

Before (7.1):

```json
{
  "debuggingTemplate": true,
  "debuggingDatabase": true,
  "showDebug": true,
  "cacheDefaultQuery": "myQueryCache",
  "updateProxyHost": "proxy.example.com",
  "updateProxyPort": 8080
}
```

After (8.0):

```json
{
  "monitoring": {
    "debuggingTemplate": true,
    "debuggingDatabase": true,
    "showDebug": true
  },
  "cache": {
    "defaultQuery": "myQueryCache"
  },
  "proxy": {
    "server": "proxy.example.com",
    "port": 8080
  }
}
```

If a section already exists in your file, add the keys to it instead of creating a second one.

The 8.0 Administrator writes these settings into their section, so a `.CFConfig.json` saved by 8.0 is not read the same way by 7.1.

### Extension providers are Maven group IDs

`extensionProviders` in `.CFConfig.json` now lists Maven group IDs (default `org.lucee`). URL based providers such as `https://extension.lucee.org` or `https://www.forgebox.io` are ignored. The matching `cfadmin` actions for URL providers were removed (see below).

```json
"extensionProviders": [ "org.lucee", "com.example" ]
```

See [[extension-provider]] and [[maven-based-extensions]].

### Renamed system properties and environment variables

Some system properties and environment variables have new names in 8.0. The old names still work as aliases ([LDEV-6549](https://luceeserver.atlassian.net/browse/LDEV-6549)), but the new names are preferred. If both are set, the new name wins.

| 7.1 name (still works) | 8.0 name (preferred) |
| --- | --- |
| `lucee.application.listener` / `LUCEE_APPLICATION_LISTENER` | `lucee.listener.type` / `LUCEE_LISTENER_TYPE` |
| `lucee.application.mode` / `LUCEE_APPLICATION_MODE` | `lucee.listener.mode` / `LUCEE_LISTENER_MODE` |
| `lucee.debugging.options` / `LUCEE_DEBUGGING_OPTIONS` (comma-separated list) | one setting per option, e.g. `lucee.monitoring.debuggingTemplate` / `LUCEE_MONITORING_DEBUGGINGTEMPLATE` |
| `lucee.maven.default.repositories` / `LUCEE_MAVEN_DEFAULT_REPOSITORIES` | `maven.repository` in `.CFConfig.json` |
| `-Dlucee.requesttimeout.memorythreshold`, `.cputhreshold`, `.concurrentrequestthreshold` | `lucee.requestTimeout.memorythreshold` etc. (the `LUCEE_REQUESTTIMEOUT_*` environment variables are unchanged) |

How the aliases behave:

- `lucee.debugging.options` only turns on an option that is not set any other way. If the option is also set with its own name (for example `LUCEE_MONITORING_DEBUGGINGTEMPLATE=false`) or in the `monitoring` section, that value wins.
- `lucee.maven.default.repositories` is only used when no release repository is configured. As in 7.1, the listed repositories are checked first, then the default repositories. A `maven.repository` setting replaces the default list instead of adding to it, so include Maven Central there if you still need it.

### Every setting can come from an environment variable

In 8.0, every setting can also be set with a system property or environment variable named after its key: `lucee.<key>` / `LUCEE_<KEY>` for top-level keys, `lucee.<section>.<key>` / `LUCEE_<SECTION>_<KEY>` for keys inside a section (for example `LUCEE_MONITORING_SHOWDEBUG`). `EnvVars()` and `GetSystemPropOrEnvVarInfo()` list them.

A value from a system property or environment variable **takes precedence over `.CFConfig.json`**. If you try to change such a setting in the Administrator, `cfadmin` or `Administrator.cfc`, Lucee 8.0 now throws an error instead of saving a value that would never be used, and the Administrator shows the field as read-only ([LDEV-6451](https://luceeserver.atlassian.net/browse/LDEV-6451), [LDEV-6452](https://luceeserver.atlassian.net/browse/LDEV-6452)).

**What to do:** Check your environment for leftover `LUCEE_*` variables, because they now override the config file for more settings than before.

### Invalid values are no longer silently ignored

Settings are loaded when they are first used. In 7.1, a value that could not be parsed (for example an invalid timespan) was ignored and the default was used. In 8.0, the error is logged and using the setting fails. Settings with a fixed list of values (for example `listenerMode`) still fall back to the default for unknown values.

To find such problems at startup, set `lucee.config.validate=true` (`LUCEE_CONFIG_VALIDATE=true`). Lucee then loads every setting at startup, so invalid values show up right away instead of on first use ([LDEV-6117](https://luceeserver.atlassian.net/browse/LDEV-6117)).

### Other configuration changes

- **No full reload on change:** Changing a setting through the Administrator or `cfadmin` updates just that setting instead of reloading the whole configuration ([LDEV-6220](https://luceeserver.atlassian.net/browse/LDEV-6220)).
- **Old XML config is no longer converted at startup:** 7.1 converted a `lucee-server.xml` into `.CFConfig.json` on startup when no JSON config existed. 8.0 no longer does. Convert it first with `ConfigTranslate()` (or on Lucee 7.1).
- **Default Maven repositories:** Lucee 8.0 resolves artifacts from Maven Central, the Google Maven Central mirror and the Lucee Maven repository (`https://maven.lucee-services.com/`). Servers behind a firewall need access to these, or a `maven.repository` setting pointing to your own mirror.

New helper functions:

- `ConfigSchema()` returns a JSON Schema for `.CFConfig.json`.
- `EnvVars()` and `GetSystemPropOrEnvVarInfo()` list the supported system properties and environment variables.

### Administrator.cfc and cfadmin changes

`Administrator.cfc` arguments and `cfadmin` attributes now use the same names as the `.CFConfig.json` keys ([LDEV-6295](https://luceeserver.atlassian.net/browse/LDEV-6295)):

| Area | Old name(s) | New name(s) |
| --- | --- | --- |
| Login | `rememberMe`, `captcha`, `delay` | `loginRememberme`, `loginCaptcha`, `loginDelay` |
| Debug options | `database`, `queryUsage`, `exception`, `tracing`, `dump`, `timer`, `implicitAccess`, `thread` | `debuggingDatabase`, `debuggingQueryUsage`, `debuggingException`, `debuggingTracing`, `debuggingDump`, `debuggingTimer`, `debuggingImplicitAccess`, `debuggingThread` |
| Debug log limit | `maxLogs` | `debuggingMaxRecordsLogged` |
| Request queue | `max`, `timeout`, `enable` | `requestQueueMax`, `requestQueueTimeout`, `requestQueueEnable` |
| Custom tags | `deepSearch`, `localSearch`, `customTagPathCache`, `extensions` | `customTagDeepSearch`, `customTagLocalSearch`, `customTagUseCachePath`, `customTagExtensions` |

The matching `<cfadmin>` read actions `getLoginSettings`, `getQueueSetting`, `getCustomTagSetting` and `getDebugSetting` also return the new names as struct keys. The old keys (for example `captcha`, `max`, `deepSearch`, `maxLogs`) are no longer included.

Old names are ignored without an error. With `Administrator.cfc`, the setting keeps its current value. With `<cfadmin>`, the setting is saved with its default value. Only `<cfadmin action="updateDebug">` still accepts the old debug option names.

These `cfadmin` actions were removed:

- `getRHExtensionProviders`, `updateRHExtensionProvider` / `updateExtensionProvider`, `removeRHExtensionProvider` / `removeExtensionProvider`; use `getExtensionGroups`, `updateExtensionGroups` and `removeExtensionGroups` instead
- `getDefaultPassword`, `updateDefaultPassword`, `removeDefaultPassword`
- `getAdminSyncClass`, `updateAdminSyncClass`

## Markdown and SMB are now extensions (bundled)

`MarkdownToHTML()` and the `smb://` resource provider were moved out of core into extensions. Lucee 8.0 **bundles both extensions**, so they work out of the box after an upgrade:

| Feature | Extension | Bundled version |
| --- | --- | --- |
| `MarkdownToHTML()` | [extension-markdown](https://github.com/lucee/extension-markdown) (`org.lucee:markdown-extension`, id `3AEDA748-F62B-42E3-8E8DC5AE0DDABE09`) | 1.0.0.2 |
| `smb://` resources | [extension-smb](https://github.com/lucee/extension-smb) (`org.lucee:smb-extension`, id `A35C8501-FFBB-43EA-975C6883C92A7D5E`) | 1.0.0.10 |

Both are installed on a new install and when an existing install is upgraded from a version older than 8.0, the same way Mail and FTP were handled when they left core in 7.1. Your code does not need to change:

```cfc
html = markdownToHTML( "## Hello" );
files = directoryList( "smb://user:pass@fileserver/share/path/" );
```

What is different now that they are extensions:

- They appear in the Administrator under Extensions and can be updated or removed independently of the Lucee core.
- If you remove one, the feature is gone (`MarkdownToHTML()` becomes an undefined function, `smb://` paths stop resolving).
- Setups that control extensions explicitly need to list them. With `lucee.extensions.config.only=true` or `lucee.extensions.install=false`, bundled extensions are not installed automatically. Add them to `LUCEE_EXTENSIONS` or to `extensions` in `.CFConfig.json` (Lucee light builds also need them added this way).
- The CommonMark and jcifs libraries are no longer part of core. Java code that used those classes directly through Lucee's core classpath needs to load them from the extension or its own dependency.

See [[extension-installation]].

## Application, server and session scope key order

The `application`, `server` and JEE `session` scopes are now backed by a concurrent map instead of a synchronized, insertion-ordered map. This greatly reduces lock contention under load.

As a result, these scopes **no longer keep insertion order**. Adobe ColdFusion does not keep insertion order for these scopes either.

**Who is affected:** Code that loops over `application`, `server` or JEE `session` and relies on the order of the keys, or compares serialized output of these scopes.

**What to do:**

- Do not rely on the key order of these scopes.
- If order matters, copy into an ordered struct first, or sort the keys.

```cfc
// order is not guaranteed on 8.0
for ( var key in application ) {
    // ...
}

// if order matters
var ordered = structNew( "ordered" );
ordered.append( application );
for ( var key in ordered ) {
    // ...
}
```

[LDEV-6479](https://luceeserver.atlassian.net/browse/LDEV-6479)

## `Connection: close` no longer forced

Three code paths always sent a `Connection: close` header, no matter what the `closeConnection` setting (default `false`) said:

- `<cflocation>`
- REST error status responses
- `<cfflush interval="...">`

That hardcoded header was removed ([LDEV-6507](https://luceeserver.atlassian.net/browse/LDEV-6507)). Connections can now be reused, and HTTP/2 clients no longer see the prohibited `Connection` header.

**What to do:** Usually nothing. If a client or proxy depends on the connection being closed, enable the `closeConnection` setting.

## Parallel iteration and virtual threads

The iteration functions (`each`, `map`, `filter`, `some`, `every` and their array, struct, query and list variants) changed their parallel arguments ([LDEV-6369](https://luceeserver.atlassian.net/browse/LDEV-6369)):

- `parallel` accepts `none`, `thread` or `virtual`. `true` and `false` still work but are deprecated.
- `maxThreads` was renamed to `maxConcurrency`. `maxThreads` and `maxThreadCount` still work as aliases.
- The default for `maxConcurrency` is now `0` (was `20`). `0` means a bounded pool in `thread` mode and **no limit** in `virtual` mode. `1` runs sequentially.

On Java 21+, Lucee 8.0 uses virtual threads for `parallel=true` by default. This is controlled by `lucee.allow.virtual.threads` / `LUCEE_ALLOW_VIRTUAL_THREADS`, which now defaults to `true`. In 7.1 it defaulted to `false` and only applied on Java 25+. So in 8.0, `parallel=true` runs on **virtual threads with no concurrency limit**, where 7.1 used at most 20 platform threads.

**What to do:** If your closures use limited resources (for example database connections), pass `parallel="thread"` or set `maxConcurrency` explicitly. To make `parallel=true` use platform threads again, set `lucee.allow.virtual.threads=false`. The explicit modes `parallel="thread"` and `parallel="virtual"` are not affected by this setting.

```cfc
// 7.1 style (still works, deprecated)
arrayEach( data, handler, true, 4 );

// 8.0 (arguments: array, closure, parallel, maxConcurrency)
arrayEach( data, handler, "thread", 4 );
arrayEach( data, handler, "virtual" ); // no limit by default

// or with named arguments (all arguments must be named)
arrayEach( array=data, closure=handler, parallel="thread", maxConcurrency=4 );
```

`<cfthread>` also has a new `virtual` attribute to run on virtual threads ([LDEV-6368](https://luceeserver.atlassian.net/browse/LDEV-6368)). Its global default is set with `lucee.thread.virtual` / `LUCEE_THREAD_VIRTUAL` (default `false`). This setting only affects `<cfthread>`, not `parallel=true`.

See [[virtual-threads]].

## Janino compiler loaded on demand

The Janino Java compiler is no longer bundled in core. When Lucee needs it (typically on a JRE without a JDK compiler), it downloads `org.codehaus.janino:janino` from Maven on first use.

**Who is affected:** Offline or firewalled servers that compile Java code at runtime and have no access to a Maven repository.

**What to do:** Allow access to the configured Maven repositories, provide a mirror via `maven.repository`, or run on a JDK.

## `LuceeExtension()` argument renamed

The `download` argument of `LuceeExtension()` was renamed to `detailed`. There is no alias.

**What to do:** Replace `download=true` with `detailed=true`.

## Bundled extension versions

The bundled extensions (`Require-Extension`) changed as follows:

| Extension | 7.1 | 8.0 |
| --- | --- | --- |
| Markdown | – | 1.0.0.2 (new) |
| SMB | – | 1.0.0.10 (new) |
| PDF | 2.0.1.0 | **3.0.0.2** |
| S3 | 2.0.3.1 | 2.1.0.15 |
| MSSQL JDBC | 13.2.1 | 13.4.0.jre11 |
| Compress | 2.1.0.3 | 2.1.0.7 |

Unchanged: MySQL JDBC (26.7.0), PostgreSQL JDBC (42.7.11), Image (3.1.0.11), ESAPI (3.1.0.7), Mail (1.1.0.17), FTP (1.0.0.9), Scheduler Classic (1.0.0.2), Administrator (1.0.0.9) and Documentation (1.0.0.8).

Lucee 8.0 references the **lite** variant (Maven classifier `lite`) of all bundled extensions except Administrator, Documentation, Compress and Scheduler Classic. A lite extension contains no embedded Maven dependencies; they are resolved from the configured Maven repositories when the extension is installed. Offline or firewalled servers need access to a Maven repository (or a `maven.repository` mirror), see [[maven-based-extensions]].

## PDF extension 3.0: new rendering engine

Lucee 8.0 bundles PDF extension 3.0 (7.1 bundled 2.0.1). Version 3.0 replaces the rendering engine ([changelog](https://github.com/lucee/extension-pdf/blob/master/CHANGELOG.md)):

- `<cfdocument>` now renders with OpenHTMLToPDF, and `<cfpdf>` uses PDFBox 3. Flying Saucer ("modern") and iText were removed.
- The PD4ML engine ("classic") was removed.
- The `type` attribute of `<cfdocument>` and the `this.pdf.type` setting are still accepted but ignored. There is only one engine now.

**Who is affected:** Applications that generate PDFs with `<cfdocument>`, especially ones that used the classic (PD4ML) engine or depend on exact layout.

**What to do:** Generate your important PDFs on 8.0 and compare them with the 7.1 output (page breaks, fonts, CSS, headers and footers). You can remove `type="classic"` / `this.pdf.type`, because they no longer do anything.

## Perl regex engine deprecated

The `perl` regex engine (Apache ORO, also called `classic`) is **deprecated** in Lucee 8.0 ([LDEV-6660](https://luceeserver.atlassian.net/browse/LDEV-6660)). It is still the default in 8.0, so regex functions (`REFind()`, `REReplace()`, `REMatch()`, etc.) behave exactly as in 7.1.

What changed in 8.0:

- Lucee logs a warning to the `application` log when an application uses the `perl` engine, either as the default or set explicitly. The warning is logged once per application, not on every regex call.
- The `regexType` setting in `.CFConfig.json` (`ConfigSchema()`) and the Administrator (regex page, "CFML Default, deprecated") mark `perl` as deprecated.

Lucee 9 uses `java` as the default engine, and `perl` is only available with the Perl Regex extension. See [[breaking-changes-8-0-to-9-0]].

**What to do:** Test your application with the Java engine on 8.0 now:

```cfc
// Application.cfc
this.regex = { type: "java" };   // Java regex engine, the Lucee 9 default
this.regex = { type: "compat" }; // Java regex engine with the Perl-style replacement syntax (\1, \U, \L)
```

Server wide, set `regexType` in `.CFConfig.json` or `lucee.regex.type` / `LUCEE_REGEX_TYPE`. To stay on `perl` with Lucee 9, set the regex type `perl` explicitly and install the Perl Regex extension. See [[java-regex-engine]].

## Maven coordinate strings: classifier in 4th position

Maven coordinates in strings (`javasettings` `maven` entries, `MavenLoad()`, `Require-Extension` in an extension manifest) now support a classifier and an extension ([LDEV-6555](https://luceeserver.atlassian.net/browse/LDEV-6555)):

```text
groupId:artifactId:version[:classifier][@extension]
```

The positional scope form from 7.1 (`groupId:artifactId:version:scope[:optional[:checksum]]`) still works, but only when the 4th part is a known Maven scope: `compile`, `provided`, `runtime`, `test`, `system` or `import`. **Any other value in 4th position is now read as the classifier.** In 7.1, an unknown value there was taken as the scope and ignored.

| String | 7.1 | 8.0 |
| --- | --- | --- |
| `com.example:lib:1.0` | `lib-1.0.jar` | `lib-1.0.jar` (unchanged) |
| `com.example:lib:1.0:compile` | `lib-1.0.jar`, scope `compile` | `lib-1.0.jar`, scope `compile` (unchanged) |
| `com.example:lib:1.0:lite` | `lib-1.0.jar` (scope `lite` ignored) | `lib-1.0-lite.jar` (classifier `lite`) |
| `com.example:lib:1.0:lite:compile` | scope `lite`, optional `compile` | classifier `lite`, scope `compile` |
| `com.example:lib:1.0@pom` | version `1.0@pom` | version `1.0`, extension `pom` |
| `com.example:lib:1.0:lite:foo` | scope `lite`, optional `foo` | invalid (`foo` is not a scope) |

Invalid strings make `MavenLoad()` throw an error. Invalid `maven` entries in `this.javasettings` are skipped, and a warning is logged with the type `javasettings`.

A classifier with the same name as a scope (for example the `test` classifier) cannot be written as a string. Use the struct form:

```cfc
this.javasettings = {
    maven: [
        "org.apache.commons:commons-lang3:3.17.0",
        { groupId: "com.example", artifactId: "lib", version: "1.0", classifier: "test" }
    ]
};
```

**Who is affected:** Code or extensions that put something other than a Maven scope in the 4th position of a coordinate string, or use `@` in a version.

**What to do:** Search for Maven coordinate strings with four or more parts (`javasettings`, `MavenLoad()`, `Require-Extension`). Remove values in 4th position that are not a scope, or switch the entry to the struct form with explicit `scope`, `optional` and `checksum` keys.

## Two-digit years use Java's sliding window

All date parsing and casting now converts two-digit years the same way ([LDEV-6180](https://luceeserver.atlassian.net/browse/LDEV-6180)). The default is Java's sliding window, the one `java.text.SimpleDateFormat` uses: a two-digit year is placed within 80 years before and 20 years after the current date (in 2026, `46` becomes 2046 and `47` becomes 1947).

In 7.1 the rule depended on the code path: some used a fixed pivot of 30, so `30` became 1930 (for example `createDate(30, 1, 1)`), others a pivot of 40, so `30` became 2030.

**Who is affected:** Applications that parse dates with two-digit years, or call `createDate()` / `createDateTime()` with a year below 100, where the year falls between the old pivot and the new window (for example `30` to `46` in 2026).

**What to do:** Use four-digit years where you can. To get a fixed pivot instead, set `lucee.date.twodigityear.pivot` / `LUCEE_DATE_TWODIGITYEAR_PIVOT` to a number from 0 to 100. Two-digit years below the pivot become 20xx, all others 19xx, so `30` gives the 7.1 behaviour of `createDate()`. See [[date-time-formatting]].

## Not changed

- **Jakarta vs javax:** still Jakarta, as in 7.0/7.1.
- **Single mode:** works as in 7.x.
- **`CreateULID()` and HTML parsing:** the ULID and TagSoup libraries were removed as separate bundles but are now part of core, so these keep working without an extension.
- **Mail, FTP, Scheduler Classic:** still bundled extensions, as in 7.1.

## Pending / under discussion

Please raise any discussions on the [dev forum](https://dev.lucee.org/), not in individual tickets.
