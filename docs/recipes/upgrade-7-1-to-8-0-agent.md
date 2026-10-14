<!--
{
  "title": "Upgrade Lucee 7.1 to 8.0: Checklist for AI Coding Agents",
  "id": "upgrade-7-1-to-8-0-agent",
  "categories": ["breaking changes", "migration", "compat", "ai"],
  "description": "Step-by-step, machine-friendly checklist for AI coding agents upgrading an application or server from Lucee 7.1 to 8.0: what to search for, what to change, how to verify, and what to leave alone.",
  "keywords": ["upgrade", "migration", "Lucee 8.0", "Lucee 7.1", "AI agent", "LLM", "checklist", "CFConfig"],
  "related": [
    "breaking-changes-7-1-to-8-0",
    "environment-variables-system-properties",
    "extension-installation",
    "virtual-threads"
  ]
}
-->

# Upgrade Lucee 7.1 to 8.0: Checklist for AI Coding Agents

**Purpose:** a checklist an AI coding agent can follow to upgrade an application or server from Lucee 7.1 to 8.0. It says what to search for, what to change, how to verify the result and what to leave alone. Humans should read [[breaking-changes-7-1-to-8-0]], which explains the background.

Rules for the agent:

- Work through the steps in order. They are sorted by impact.
- Only change what a step tells you to change. If a search finds nothing, move on.
- Show the user every change to `.CFConfig.json`, environment files and Dockerfiles before you apply it.
- Search commands use [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`). With `grep`, use `grep -rnE` with the same pattern. JSON checks use `jq`.

## 0. Find the files

```sh
# Lucee server / web config (the file is named .CFConfig.json or config.json)
rg --files --hidden -g '.CFConfig.json' -g 'config.json' -g '!node_modules'

# environment and startup files
rg --files --hidden -g 'Dockerfile*' -g '*compose*.y*ml' -g '.env*' -g '*.env' -g 'setenv.sh' -g 'setenv.bat' -g '*.properties' -g '!node_modules'

# CFML code
rg --files -g '*.cfc' -g '*.cfm' -g '*.cfml'
```

Only treat `config.json` as Lucee config if it sits in a Lucee context folder (`lucee-server/context/` or `WEB-INF/lucee/`) or contains Lucee keys such as `"inspectTemplate"` or `"extensions"`.

## 1. Prerequisites and environment checks

### 1.1 Java 21 or newer (blocker)

Lucee 8.0 does not start on Java 11 or 17.

```sh
java -version
rg -n -i '^\s*FROM\s' -g 'Dockerfile*'
rg -n -i '(JAVA_HOME|jdk|jre|temurin|openjdk|corretto|zulu)[^0-9\n]*(8|11|17)\b' -g 'Dockerfile*' -g '*compose*.y*ml' -g 'setenv.*' -g '*.env' -g '.env*'
```

Fix: switch the JVM or base image to Java 21 (LTS) or newer.

```dockerfile
# before
FROM eclipse-temurin:17-jre
# after
FROM eclipse-temurin:21-jre
```

The servlet container must still be Jakarta based (Tomcat 10.1+, Jetty 11+), the same as for 7.x. Do not change it.

### 1.2 Extension setup (only if extensions are controlled explicitly)

In 8.0, `MarkdownToHTML()` and `smb://` resources come from extensions. They are bundled and installed automatically, **unless** the setup controls extensions explicitly.

```sh
rg -n -i 'LUCEE_EXTENSIONS(_INSTALL|_CONFIG_ONLY)?\b|lucee\.extensions(\.install|\.config\.only)?\b'
rg -n -i 'markdownToHTML\s*\(|smb://' -g '*.cfc' -g '*.cfm' -g '*.cfml'
```

You only need to act if **both** searches find something, and the first one shows `lucee.extensions.install=false`, `lucee.extensions.config.only=true`, or a fixed `LUCEE_EXTENSIONS` / `extensions` list. In that case, add the extension that the code uses to that list, in the same format as the existing entries:

| Used in code | Extension | ID | Bundled version |
| --- | --- | --- | --- |
| `MarkdownToHTML()` | `org.lucee:markdown-extension` | `3AEDA748-F62B-42E3-8E8DC5AE0DDABE09` | 1.0.0.2-RC |
| `smb://` | `org.lucee:smb-extension` | `A35C8501-FFBB-43EA-975C6883C92A7D5E` | 1.0.0.3-RC |

Lucee light builds also need these added this way.

### 1.3 Maven repositories must be reachable

Lucee 8.0 downloads artifacts (extensions, libraries, and Janino if Java code is compiled at runtime on a JRE) from Maven repositories. Check that the server can reach the defaults:

```sh
for u in https://repo1.maven.org/maven2/ https://maven-central.storage-download.googleapis.com/maven2/ https://maven.lucee-services.com/; do
  curl -s -o /dev/null -w "%{http_code} $u\n" --max-time 10 "$u"
done
```

If they are blocked (firewall, offline), either allow them or point Lucee to an internal mirror with `maven` → `repository` in `.CFConfig.json`. That setting **replaces** the default list, so the mirror has to proxy Maven Central too:

```json
"maven": {
  "repository": [ "https://nexus.example.com/repository/maven-public/" ]
}
```

## 2. Move top-level keys into their section in `.CFConfig.json` (high impact, silent)

Lucee 8.0 only reads these keys inside their section. If they are left at the top level, **there is no error and no warning**. Lucee ignores them and uses the default.

Detect them (run once per config file):

```sh
jq -r 'keys[] | select(test("^(debugging(Show)?(Database|Exception|Template|Dump|Tracing|Trace|Timer|ImplicitAccess|ImplicitVariableAccess|QueryUsage|Thread)|show(Debug|Doc|Reference|Metrics?|Tests?)|doc|documentation|reference|metrics?|test|cacheDefault(Object|Query|Template|Resource|Function|Include|File|HTTP|Webservice)|updateProxy(Host|Port|Username|Password))$"; "i"))' .CFConfig.json
```

Fix: move each key found to its new location. Keep the value as it is.

| Top-level key | Move to |
| --- | --- |
| `debuggingDatabase`, `debuggingShowDatabase` | `monitoring.debuggingDatabase` |
| `debuggingException`, `debuggingShowException` | `monitoring.debuggingException` |
| `debuggingTemplate`, `debuggingShowTemplate` | `monitoring.debuggingTemplate` |
| `debuggingDump`, `debuggingShowDump` | `monitoring.debuggingDump` |
| `debuggingTracing`, `debuggingShowTracing`, `debuggingShowTrace` | `monitoring.debuggingTracing` |
| `debuggingTimer`, `debuggingShowTimer` | `monitoring.debuggingTimer` |
| `debuggingImplicitAccess`, `debuggingImplicitVariableAccess`, `debuggingShowImplicitAccess` | `monitoring.debuggingImplicitAccess` |
| `debuggingQueryUsage`, `debuggingShowQueryUsage` | `monitoring.debuggingQueryUsage` |
| `debuggingThread`, `debuggingShowThread` | `monitoring.debuggingThread` |
| `showDebug` | `monitoring.showDebug` |
| `showDoc`, `doc`, `documentation`, `showReference`, `reference` | `monitoring.showDoc` |
| `showMetric`, `showMetrics`, `metric`, `metrics` | `monitoring.showMetric` |
| `showTest`, `showTests`, `test` | `monitoring.showTest` |
| `cacheDefaultObject` … `cacheDefaultWebservice` | `cache.defaultObject` … `cache.defaultWebservice` (drop the `cacheDefault` prefix, keep the rest, e.g. `cacheDefaultHTTP` → `cache.defaultHTTP`) |
| `updateProxyHost` | `proxy.server` |
| `updateProxyPort` | `proxy.port` |
| `updateProxyUsername` | `proxy.username` |
| `updateProxyPassword` | `proxy.password` |

Before:

```json
{
  "debuggingTemplate": true,
  "showDebug": true,
  "cacheDefaultQuery": "myQueryCache",
  "updateProxyHost": "proxy.example.com",
  "updateProxyPort": 8080
}
```

After:

```json
{
  "monitoring": { "debuggingTemplate": true, "showDebug": true },
  "cache": { "defaultQuery": "myQueryCache" },
  "proxy": { "server": "proxy.example.com", "port": 8080 }
}
```

If `monitoring`, `cache` or `proxy` already exists, merge the keys into it. Do not create a second key with the same name. If a key exists both at the top level and in the section, keep the value from the section and remove the top-level one. Ask the user if the two values differ.

Leave these at the top level (they are not moved): `debuggingLogOutput`, `debuggingMaxRecordsLogged`, `debugTemplates`, `showVersion`.

## 3. Extension providers (high impact for custom providers)

```sh
rg -n -A5 '"extensionProviders"' -g '.CFConfig.json' -g 'config.json'
```

`extensionProviders` now takes Maven group IDs. URL entries (`http://…`, `https://…`, for example `https://extension.lucee.org` or `https://www.forgebox.io`) are ignored.

```json
// before
"extensionProviders": [ "https://extension.lucee.org", "https://www.forgebox.io" ]
// after
"extensionProviders": [ "org.lucee" ]
```

For a custom provider, ask the user for the Maven group ID of their extensions. Do not invent one.

## 4. `parallel=true` in iteration functions (medium impact, behaviour change)

In 8.0 on Java 21+, `parallel=true` runs on **virtual threads with no concurrency limit**. 7.1 used at most 20 platform threads.

```sh
rg -n -i '\b(array|struct|query|list|collection)?(each|map|filter|some|every)\s*\(' -g '*.cfc' -g '*.cfm' -g '*.cfml' | rg -i '\btrue\b|parallel'
rg -n -i '\.(each|map|filter|some|every)\s*\(' -g '*.cfc' -g '*.cfm' -g '*.cfml' | rg -i '\btrue\b|parallel'
```

Review each hit. You only need to act when the closure uses a limited resource (database queries, HTTP calls to a rate-limited service, file handles). In that case, make the limit explicit:

```cfc
// before (7.1: at most 20 platform threads)
arrayEach( ids, function( id ) { queryExecute( "..." ); }, true );

// after (same behaviour as 7.1)
arrayEach( ids, function( id ) { queryExecute( "..." ); }, "thread", 20 );
```

The argument order is: collection, closure, `parallel`, `maxConcurrency`. Do not mix positional and named arguments in one call. Lucee rejects that. Leave pure CPU or in-memory closures as they are. To switch `parallel=true` back to platform threads server-wide, the user can set `LUCEE_ALLOW_VIRTUAL_THREADS=false`. Suggest it, but do not set it yourself.

## 5. Administrator.cfc / `<cfadmin>` scripts (medium impact, silent)

Only relevant if the code automates the Lucee Administrator.

```sh
rg -n -i 'action\s*=\s*["'"'"'](get|update)(LoginSettings|QueueSetting|CustomTagSetting|DebugSetting)["'"'"']|\.(get|update)(LoginSettings|QueueSetting|CustomTagSetting|DebugSetting)\s*\(' -g '*.cfc' -g '*.cfm' -g '*.cfml'
rg -n -i 'action\s*=\s*["'"'"'](getRHExtensionProviders|updateRHExtensionProvider|updateExtensionProvider|removeRHExtensionProvider|removeExtensionProvider|getDefaultPassword|updateDefaultPassword|removeDefaultPassword|getAdminSyncClass|updateAdminSyncClass)["'"'"']' -g '*.cfc' -g '*.cfm' -g '*.cfml'
```

Rename the arguments/attributes. Old names are ignored **without an error**. `Administrator.cfc` keeps the current value, and `<cfadmin>` saves the default.

| Old | New |
| --- | --- |
| `rememberMe`, `captcha`, `delay` | `loginRememberme`, `loginCaptcha`, `loginDelay` |
| `database`, `queryUsage`, `exception`, `tracing`, `dump`, `timer`, `implicitAccess`, `thread` | `debuggingDatabase`, `debuggingQueryUsage`, `debuggingException`, `debuggingTracing`, `debuggingDump`, `debuggingTimer`, `debuggingImplicitAccess`, `debuggingThread` |
| `maxLogs` | `debuggingMaxRecordsLogged` |
| `max`, `timeout`, `enable` (request queue) | `requestQueueMax`, `requestQueueTimeout`, `requestQueueEnable` |
| `deepSearch`, `localSearch`, `customTagPathCache`, `extensions` (custom tags) | `customTagDeepSearch`, `customTagLocalSearch`, `customTagUseCachePath`, `customTagExtensions` |

```cfc
// before
admin action="updateQueueSetting" type="server" password=pw max=100 timeout=0 enable=true;
// after
admin action="updateQueueSetting" type="server" password=pw requestQueueMax=100 requestQueueTimeout=0 requestQueueEnable=true;
```

The read actions `getLoginSettings`, `getQueueSetting`, `getCustomTagSetting` and `getDebugSetting` also return the new names. Update code that reads the result (e.g. `result.max` → `result.requestQueueMax`, `result.maxLogs` → `result.debuggingMaxRecordsLogged`).

`<cfadmin action="updateDebug">` still accepts the old debug option names. You can rename them there, but you don't have to.

Removed actions (second search): replace `getRHExtensionProviders` / `updateRHExtensionProvider` / `updateExtensionProvider` / `removeRHExtensionProvider` / `removeExtensionProvider` with `getExtensionGroups` / `updateExtensionGroups` / `removeExtensionGroups` (Maven group IDs, see step 3). `getDefaultPassword`, `updateDefaultPassword`, `removeDefaultPassword`, `getAdminSyncClass` and `updateAdminSyncClass` have no replacement. Report these to the user instead of deleting the code.

## 6. Renamed environment variables / system properties (low impact)

```sh
rg -n -i 'LUCEE_APPLICATION_(LISTENER|MODE)|LUCEE_DEBUGGING_OPTIONS|LUCEE_MAVEN_DEFAULT_REPOSITORIES|lucee\.application\.(listener|mode)|lucee\.debugging\.options|lucee\.maven\.default\.repositories|lucee\.requesttimeout\.(memory|cpu|concurrentrequest)threshold'
```

The old names still work as aliases, so this is optional cleanup. If you rename, use:

| Old | New |
| --- | --- |
| `LUCEE_APPLICATION_LISTENER` / `lucee.application.listener` | `LUCEE_LISTENER_TYPE` / `lucee.listener.type` |
| `LUCEE_APPLICATION_MODE` / `lucee.application.mode` | `LUCEE_LISTENER_MODE` / `lucee.listener.mode` |
| `LUCEE_DEBUGGING_OPTIONS=template,database` | `LUCEE_MONITORING_DEBUGGINGTEMPLATE=true`, `LUCEE_MONITORING_DEBUGGINGDATABASE=true` (one per option) |
| `LUCEE_MAVEN_DEFAULT_REPOSITORIES` | `maven.repository` in `.CFConfig.json` (replaces the defaults, so include Maven Central, see 1.3) |
| `-Dlucee.requesttimeout.memorythreshold` etc. | `-Dlucee.requestTimeout.memorythreshold` etc. (env vars `LUCEE_REQUESTTIMEOUT_*` unchanged) |

Also check for **other** `LUCEE_*` variables. In 8.0, every config setting can be set through an environment variable or system property, and that value wins over `.CFConfig.json`:

```sh
rg -n -o 'LUCEE_[A-Z0-9_]+' -g 'Dockerfile*' -g '*compose*.y*ml' -g '*.env' -g '.env*' -g 'setenv.*' | sort -u
```

List them for the user, especially ones that seem to conflict with `.CFConfig.json`. Do not delete them on your own.

## 7. Smaller code changes (low impact)

### 7.1 `LuceeExtension( download=... )`

```sh
rg -n -i 'LuceeExtension\s*\(' -g '*.cfc' -g '*.cfm' -g '*.cfml'
```

If the call passes `download`, rename that argument to `detailed`. There is no alias.

### 7.2 Key order of `application`, `server`, `session`

```sh
rg -n -i 'for\s*\(\s*(var\s+)?\w+\s+in\s+(application|server|session)\b|structKey(List|Array)\s*\(\s*(application|server|session)\b|serializeJSON\s*\(\s*(application|server|session)\b' -g '*.cfc' -g '*.cfm' -g '*.cfml'
```

These scopes no longer keep insertion order. Change code only if it depends on the order, by sorting the keys or copying into `structNew( "ordered" )` first.

### 7.3 PDF generation

```sh
rg -n -i '<cfdocument|\bdocument\s*\(|this\.pdf\.type|\btype\s*=\s*["'"'"'](classic|modern|pd4ml|fs)["'"'"']' -g '*.cfc' -g '*.cfm' -g '*.cfml'
```

The bundled PDF extension 3.0 uses a new rendering engine (OpenHTMLToPDF), and PD4ML ("classic") was removed. `type` and `this.pdf.type` are ignored now, so you may remove them. Tell the user to compare the generated PDFs with the 7.1 output. Do not rewrite layouts on your own.

### 7.4 Other

- If a client or proxy relies on `Connection: close` after `<cflocation>`, REST error responses or `<cfflush interval>`, enable the `closeConnection` setting. Otherwise do nothing.
- If the server only has XML config (`lucee-server.xml` / `lucee-web.xml.cfm`) and no `.CFConfig.json`, note that 8.0 no longer converts XML config at startup. Convert it on 7.1 first (or with `ConfigTranslate()`).

## 8. Verify

1. Start Lucee 8.0 once with config validation:

   ```sh
   LUCEE_CONFIG_VALIDATE=true   # or -Dlucee.config.validate=true
   ```

   This loads every setting at startup instead of on first use, so invalid values show up right away. In 8.0, a value that cannot be parsed (for example an invalid timespan) makes the setting fail when it is used. 7.1 quietly used the default instead.
2. Check the server logs (`lucee-server/context/logs/`) and the console output (stdout/stderr, e.g. `catalina.out`) for configuration errors, and for failed extension installs or Maven downloads.
3. Check that the moved settings are active: open the Administrator or call `<cfadmin action="getDebug" returnVariable="d">` (returns `debuggingTemplate`, `debuggingDatabase`, …) and compare with the 7.1 values. Remember that keys left at the top level (checklist step 2) produce **no** log entry. You can only see them by comparing values.
4. Check that settings defined through environment variables appear as read-only in the Administrator. That shows which values come from the environment.
5. Run the application's test suite. Exercise `parallel` code paths, PDF generation, and any `<cfadmin>` automation.

Remove `LUCEE_CONFIG_VALIDATE` again after the check if the user does not want it permanently.

## Do not change

Stop agents from over-editing. These do **not** need changes for 8.0:

- The `.CFConfig.json` format, file name and location. Do not rename keys other than those in step 2, and do not reformat or reorder the file.
- Keys that are already inside `monitoring`, `cache` or `proxy`. Old names there still work (e.g. `cacheDefaultQuery` inside `cache`).
- `parallel="thread"` / `parallel="virtual"` calls, and `maxThreads` / `maxThreadCount` arguments (still accepted as aliases of `maxConcurrency`).
- `parallel=false`: still means sequential.
- `<cfthread>` code: the new `virtual` attribute is opt-in.
- `MarkdownToHTML()` and `smb://` code: they keep working, the extensions are bundled (see 1.2 for the one exception).
- `CreateULID()` and HTML parsing (`htmlParse`): still in core.
- Mail, FTP and Scheduler Classic: still bundled extensions, as in 7.1.
- Javax vs Jakarta imports or servlet container: unchanged since 7.0.
- Single mode / multi mode settings: unchanged.
- `lucee.maven.download.policy.*` settings: still work.
- Old environment variable names in step 6: they still work. Rename only if the user wants to clean up.

## See also

- [[breaking-changes-7-1-to-8-0]]
- [[environment-variables-system-properties]]
- [[extension-installation]]
- [[virtual-threads]]
