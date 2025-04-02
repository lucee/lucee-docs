<!--
{
  "title": "Environment Variables / System Properties for Lucee",
  "id": "environment-variables-system-properties",
  "description": "This document gives you an overview over all Environment Variables an System Properties you can set for Lucee.",
  "keywords": [
    "Environment",
    "Environment Variables",
    "Properties",
    "System Properties",
    "setting",
    "config"
  ],
  "categories": [
    "server"
  ]
}
-->

# Environment Variables / System Properties for Lucee

Below is a list of environment variables and system properties you can set for the Lucee Server.

## Important Settings

The following settings are very useful and important to know.

**Environment Variable:** `LUCEE_ADMIN_ENABLED`
**System Property:** `-Dlucee.admin.enabled`
Should the Lucee Admin be available or not.

**Environment Variable:** `LUCEE_ADMIN_PASSWORD`
**System Property:** `-Dlucee.admin.password`
Password used for the Lucee admin (when you run Lucee in multi mode, the password for the Server admin).

**Environment Variable:** `LUCEE_DATASOURCE_POOL_VALIDATE`
**System Property:** `-Dlucee.datasource.pool.validate`
If enabled, Lucee will validate existing datasource connections reused from the datasource pool before using them. This protects from exceptions caused by connections dropped by the DB server but creates additional communication between Lucee and the DB server.

**Environment Variable:** `LUCEE_DEBUGGING_OPTIONS`
**System Property:** `-Dlucee.debugging.options`
Debug options, a comma-separated list of the following possible debug options to enable:

- database
- exception
- template
- dump
- tracing
- timer
- implicit-access
- query-usage
- max-records-logged

**Environment Variable:** `LUCEE_ENCRYPTION_ALGORITHM`
**System Property:** `-Dlucee.encryption.algorithm`
Default encryption algorithm used when none is specified. The default "cfmx_compat" is not cryptographically secure - strongly recommended to use "AES" instead.
Valid values: CFMX_COMPAT, AES, BLOWFISH, DES

**Environment Variable:** `LUCEE_EXTENSIONS`
**System Property:** `-Dlucee.extensions`
Define a comma-separated list of Lucee extensions to install when starting up. This can be a simple list of IDs like this, then simply the latest versions get installed:

```plaintext
99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6,
671B01B8-B3B3-42B9-AC055A356BED5281,
2BCD080F-4E1E-48F5-BEFE794232A21AF6
```

Or with more specific information like version and label (for better readability) like this:

```plaintext
99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6;name=MSSQL;label=MS SQL Server;version=12.2.0.jre8,
671B01B8-B3B3-42B9-AC055A356BED5281;name=PostgreSQL;label=PostgreSQL;version=42.7.3,
2BCD080F-4E1E-48F5-BEFE794232A21AF6;name=JDTsSQL;label=jTDS (MSSQL);version=1.3.1
```

**Environment Variable:** `LUCEE_LOGINSTORAGE_ITERATIONS`
**System Property:** `-Dlucee.loginstorage.iterations`
Specifies the number of encryption iterations for `loginstorage`. The default is 0.

**Environment Variable:** `LUCEE_LOGINSTORAGE_PRIVATEKEY`
**System Property:** `-Dlucee.loginstorage.privatekey`
A private key used to encrypt `loginstorage`. If not defined, a simple base64 encoding is used.

**Environment Variable:** `LUCEE_LOGINSTORAGE_SALT`
**System Property:** `-Dlucee.loginstorage.salt`
The salt used for encrypting `loginstorage`. If no salt is defined, a hardcoded salt is used.

**Environment Variable:** `LUCEE_PASSWORD_ENC_KEY`
**System Property:** `-Dlucee.password.enc.key`
The private encryption key used by Lucee to encrypt passwords stored in the configuration, such as for datasources.

**Environment Variable:** `LUCEE_CFID_URL_ALLOW` (previously `LUCEE_READ_CFID_FROM_URL`)
**System Property:** `-Dlucee.cfid.url.allow` (previously `-Dlucee.read.cfid.from.url`)
Controls whether Lucee accepts CFID values from URL query strings. Set to false to enhance security by requiring CFIDs to be passed via cookies only.
The previous property names are still supported for backward compatibility, but the new names are preferred starting with Lucee 6.2.1.59.
Setting this to false is strongly recommended for all production environments.

**Environment Variable:** `LUCEE_CFID_URL_LOG`
**System Property:** `-Dlucee.cfid.url.log`
When set to a log name, Lucee will log all instances where CFID is read from a URL parameter and used.
The log includes URL, IP address, user agent, referrer, and stack trace in JSON format.
This helps identify code that needs to be updated before URL-based CFID is disabled for security reasons.

**Environment Variable:** `LUCEE_REQUESTTIMEOUT`
**System Property:** `-Dlucee.requesttimeout`
A boolean value. If false, Lucee will disable request timeouts.

**Environment Variable:** `LUCEE_REQUESTTIMEOUT_CONCURRENTREQUESTTHRESHOLD`
**System Property:** `-Dlucee.requesttimeout.concurrentrequestthreshold`
Concurrent request threshold to enforce a request timeout. If a request reaches the timeout, Lucee will only enforce it if this threshold is also reached. For example, setting it to `100` means the timeout is enforced only if there are at least 99 other requests running.

**Environment Variable:** `LUCEE_REQUESTTIMEOUT_CPUTHRESHOLD`
**System Property:** `-Dlucee.requesttimeout.cputhreshold`
A floating-point number between 0 and 1. CPU threshold to enforce a request timeout. If a request reaches the timeout, Lucee will only enforce it if the CPU usage of the current core is at least the specified threshold. For example, setting it to `0.5` enforces the timeout if the CPU is at least 50%.

**Environment Variable:** `LUCEE_SERVER_DIR`
**System Property:** `-Dlucee.server.dir`
Specifies the file directory for the Lucee server context.

**Environment Variable:** `LUCEE_VERSION`
**System Property:** `-Dlucee.version`
Defines the version of Lucee to load. For example, setting it to `6.1.0.0` will load that version. If not available locally, Lucee will automatically download it from Maven.

**Environment Variable:** `LUCEE_ADMIN_MODE="single|multi"`
**System Property:** `-Dlucee.admin.mode`
This setting only applies to Lucee 6 (above `6.1.1.54`), Lucee 6 can run in `single` mode or `multi` mode. In single mode, Lucee only has one set of configurations for the whole server. In multi mode, you have a base configuration for the whole server, but then every web context has its own configuration to override the base configuration. With Lucee 5, you only have multi mode and with Lucee 7, you only have single mode.
By default, a new version of Lucee 6 with no `.CFConfig.json` provided that contains a `mode:"single|multi"` setting starts in single mode. When you update from Lucee 5, you start in multi mode.
To change this behavior, you can set the environment variable `LUCEE_ADMIN_MODE="single|multi"` or system property `-Dlucee.admin.mode="single|multi"`.

**Environment Variable:** `LUCEE_ADMIN_MODE_DEFAULT="single|multi"`
**System Property:** `-Dlucee.admin.mode.default`
This setting functions similarly to `LUCEE_ADMIN_MODE`, but it only affects the default behavior and can be overridden by any setting in `.CFConfig.json`.

**Environment Variable:** `LUCEE_CASCADING_WRITE_TO_VARIABLES_LOG`
**System Property:** `-Dlucee.cascading.write.to.variables.log`
This setting only applies to Lucee 6 (above `6.2.1.82`). Enables logging when variables are implicitly written to the variables scope (without an explicit scope definition). When set to a log level name (e.g., "application"), Lucee will log details about variables being assigned without explicit scope at the DEBUG level. This helps identify code that could be optimized by using proper variable scoping. 

**Environment Variable:** `LUCEE_CASCADING_WRITE_TO_VARIABLES_LOG`
**System Property:** `-Dlucee.cascading.write.to.variables.log`
This setting only applies to Lucee 6 (above `6.2.1.82`). Enables logging when variables are implicitly written to the variables scope (without an explicit scope definition). When set to a log name (e.g., "application"), Lucee will log details about variables being assigned without explicit scope. The log level can be customized using the `LUCEE_CASCADING_WRITE_TO_VARIABLES_LOGLEVEL` setting. This helps identify code that could be optimized by using proper variable scoping. This setting excludes certain internal variables (_cfquery, _cflock, _thread) from being logged.

**Environment Variable:** `LUCEE_CASCADING_WRITE_TO_VARIABLES_LOGLEVEL`
**System Property:** `-Dlucee.cascading.write.to.variables.loglevel`
This setting only applies to Lucee 6 (above `6.2.1.82`). Specifies the log level for cascading write detection logs. Valid values are: DEBUG, INFO, WARN, ERROR. If not specified, the default level is DEBUG.

## Breaking Changes

Major updates for Lucee can sometimes cause breaking changes. The settings below allow you to emulate the behavior of older Lucee versions in newer versions.

**Environment Variable:** `LUCEE_QUERY_ALLOWEMPTYASNULL`
**System Property:** `-Dlucee.query.allowemptyasnull`

In Lucee 5, an empty string passed into a query parameter with a numeric type was interpreted as null. In Lucee 6, this is no longer accepted and throws an exception.
You can simulate the old behavior by setting this environment variable or system property to `true`.

By setting the log level of the `datasource` log to `warn`, you will receive information in the log when the old behavior is used.
This allows you to modify your code for the new behavior without encountering runtime issues with the existing code.

**Environment Variable:** `LUCEE_DESERIALIZEJSON_ALLOWEMPTY`
**System Property:** `-Dlucee.deserializejson.allowempty`

In Lucee 5, an empty string passed into the function deserializeJson will return an empty string back. In Lucee 6, this is no longer accepted and throws an exception.
You can simulate the old behavior by setting this environment variable or system property to `true`.

By setting the log level of the `application` log to `warn`, you will receive information in the log when the old behavior is used.
This allows you to modify your code for the new behavior without encountering runtime issues with the existing code.

## Regular Settings

Settings that are nice to know, but not that important.

**Environment Variable:** `LUCEE_MAVEN_DEFAULT_REPOSITORIES`
**System Property:** `-Dlucee.maven.default.repositories`
Specifies a comma-separated list of Maven repository URLs to use before the default repositories (Maven Central, Sonatype, JCenter). This allows customizing the Maven repositories used by Lucee for downloading dependencies.
- URLs must be valid Maven repository paths ending with a trailing slash (/)
- Repositories specified will be added at the beginning of Lucee's repository list
- Can be used to specify local repositories accessible to the server
- Particularly valuable for servers behind firewalls with limited external access

**Environment Variable:** `FELIX_LOG_LEVEL`
**System Property:** `-Dfelix.log.level`
Log level for the Felix Framework (OSGi).

**Environment Variable:** `LUCEE_ALLOW_COMPRESSION`
**System Property:** `-Dlucee.allow.compression`
Allows compressing (GZIP) the HTTP response if the client explicitly supports it.

**Environment Variable:** `LUCEE_APPLICATION_PATH_CACHE_TIMEOUT`
**System Property:** `-Dlucee.application.path.cache.timeout`
Lucee caches the path information to the template; this defines the idle timeout for these cache elements in milliseconds.

**Environment Variable:** `LUCEE_COMPILER_BLOCK_BYTECODE`
**System Property:** `-Dlucee.compiler.block.bytecode`
Controls whether Lucee allows the direct execution of precompiled bytecode files (.cfm). Set to true to prevent bytecode execution, requiring all CFML files to be provided as source code.

**Environment Variable:** `LUCEE_CASCADE_TO_RESULTSET`
**System Property:** `-Dlucee.cascade.to.resultset`
When a variable has no scope defined (example: `#myVar#` instead of `#variables.myVar#`), Lucee will also search available resultsets (CFML Standard) or not.

**Environment Variable:** `LUCEE_CLI_PRINTEXCEPTIONS`
**System Property:** `-Dlucee.cli.printExceptions`
Print out exceptions within the CLI interface.

**Environment Variable:** `LUCEE_ENABLE_WARMUP`
**System Property:** `-Dlucee.enable.warmup`
Boolean to enable/disable Lucee warmup on start.

**Environment Variable:** `LUCEE_EXTENSIONS_INSTALL`
**System Property:** `-Dlucee.extensions.install`
A boolean value to enable/disable the installation of extensions.

**Environment Variable:** `LUCEE_FULL_NULL_SUPPORT`
**System Property:** `-Dlucee.full.null.support`
A boolean value to enable/disable full null support.

**Environment Variable:** `LUCEE_LIBRARY_ADDITIONAL_FUNCTION`
**System Property:** `-Dlucee.library.additional.function`
Path to a directory for additional CFML-based functions Lucee should load to make these functions available in the application. For example, you create a file called `length.cfm` that looks like this:

```lucee
function length(obj) {
    return len(obj);
}
```

Then you copy that file into that directory, and you can use the function `length(any)` in all your code like a built-in function.

**Environment Variable:** `LUCEE_LIBRARY_ADDITIONAL_TAG`
**System Property:** `-Dlucee.library.additional.tag`
Path to a directory for additional CFML-based tags Lucee should load as globally available tags following the custom tag interface.

**Environment Variable:** `LUCEE_LIBRARY_DEFAULT_FUNCTION`
**System Property:** `-Dlucee.library.default.function`
Path to a directory for CFML-based functions Lucee should load to make these functions available in the application. For example, you create a file called `length.cfm` that looks like this:

```lucee
function length(obj) {
    return len(obj);
}
```

Then you copy that file into that directory, and you can use the function `length(any)` in all your code like a built-in function.

**Environment Variable:** `LUCEE_LIBRARY_DEFAULT_TAG`
**System Property:** `-Dlucee.library.default.tag`
Path to a directory for CFML-based tags Lucee should load as globally available tags following the custom tag interface.

**Environment Variable:** `LUCEE_LIBRARY_DEFAULT_TLD`
**System Property:** `-Dlucee.library.default.tld`
Tag Library Descriptor files (.tld or .tldx) Lucee should load to make these tags available in the application.

**Environment Variable:** `LUCEE_LISTENER_MODE`
**System Property:** `-Dlucee.listener.mode`
Where/how does Lucee look for the Application Listener?

- `currenttoroot` - looks for the file "Application.cfc/Application.cfm" from the current up to the webroot directory.
- `currentorroot` - looks for the file "Application.cfc/Application.cfm" in the current directory and in the webroot directory.
- `root` - looks for the file "Application.cfc/Application.cfm" only in the webroot.
- `current` - looks for the file "Application.cfc/Application.cfm" only in the current template directory.

**Environment Variable:** `LUCEE_LISTENER_TYPE`
**System Property:** `-Dlucee.listener.type`
Which kind of Application Listener is supported?

- `None` - no listener at all.
- `Classical (CFML < 7)` - Classic handling. Lucee looks for the file "Application.cfm" and a corresponding file "OnRequestEnd.cfm".
- `Modern` - Modern handling. Lucee only looks for the file "Application.cfc".
- `Mixed (CFML >= 7)` - Mixed handling. Lucee looks for a file "Application.cfm/OnRequestEnd.cfm" as well as for the file "Application.cfc".

**Environment Variable:** `LUCEE_LISTENER_SINGELTON`
**System Property:** `-Dlucee.listener.singelton`
Controls how Lucee manages Application.cfc instances (introduced in Lucee 7). When set to false (Classic behavior), Lucee creates a new Application.cfc instance for each request and executes the component body constructor every time. When set to true (Singleton behavior), the component loads only during startup or when the component template changes.
Note: With singleton mode enabled, settings defined in the component body remain persistent between requests. Configuration changes should be made within listener functions like onApplicationStart, onSessionStart or onRequestStart.

**Environment Variable:** `LUCEE_LOGGING_MAIN`
**System Property:** `-Dlucee.logging.main`
Name of the main logger used by Lucee, for example, a non-existing logger is defined.

**Environment Variable:** `LUCEE_MAPPING_FIRST`
**System Property:** `-Dlucee.mapping.first`
Let's say you have the following code:

```lucee
<cfinclude template="/foo/bar/index.cfm">
```

And you have the following mappings defined:

- `/foo/bar`
- `/foo`

Then Lucee will look for `/index.cfm` in `/foo/bar` and for `/bar/index.cfm` in `/foo` and invoke the first `index.cfm` it finds, which could be in both mappings. If this setting is set to `true`, Lucee will only check `/foo/bar` for `index.cfm`.

**Environment Variable:** `LUCEE_MVN_REPO_RELEASES`
**System Property:** `-Dlucee.mvn.repo.releases`
Endpoint used by Lucee >= 6 to load releases, by default this is `https://oss.sonatype.org/service/local/repositories/releases/content/`.

**Environment Variable:** `LUCEE_MVN_REPO_SNAPSHOTS`
**System Property:** `-Dlucee.mvn.repo.snapshots`
Endpoint used by Lucee >= 6 to load snapshots, by default this is `https://oss.sonatype.org/content/repositories/snapshots/`.

**Environment Variable:** `LUCEE_PAGEPOOL_MAXSIZE`
**System Property:** `-Dlucee.pagePool.maxSize`
Max size of the template pool (page pool), the pool Lucee holds loaded `.cfm`/`.cfc` files. By default, this is `10000`; no number smaller than `1000` is accepted.

**Environment Variable:** `LUCEE_PRECISE_MATH`
**System Property:** `-Dlucee.precise.math`
A boolean value. If enabled, this improves the accuracy of floating-point calculations but makes them slightly slower.

**Environment Variable:** `LUCEE_PRESERVE_CASE`
**System Property:** `-Dlucee.preserve.case`
A boolean value. If true, Lucee will not convert variable names used in "dot notation" to UPPER CASE.

**Environment Variable:** `LUCEE_QUEUE_ENABLE`
**System Property:** `-Dlucee.queue.enable`
A boolean value. If true, Lucee will enable the queue for requests.

**Environment Variable:** `LUCEE_QUEUE_MAX`
**System Property:** `-Dlucee.queue.max`
The maximum concurrent requests that the engine allows to run at the same time before the engine begins to queue the requests.

**Environment Variable:** `LUCEE_QUEUE_TIMEOUT`
**System Property:** `-Dlucee.queue.timeout`
The time in milliseconds a request is held in the queue. If the time is reached, the request is rejected with an exception. If you set it to 0 seconds, the request timeout is used instead.

**Environment Variable:** `LUCEE_REQUEST_LIMIT_CONCURRENT_MAXNOSLEEP`
**System Property:** `-Dlucee.request.limit.concurrent.maxnosleep`
The maximal number of threads that are allowed to be active on the server. If this is reached, requests get forced into a "nap" (defined by `lucee.request.limit.concurrent.sleeptime`).

**Environment Variable:** `LUCEE_REQUEST_LIMIT_CONCURRENT_SLEEPTIME`
**System Property:** `-Dlucee.request.limit.concurrent.sleeptime`
How long a request should "nap" in milliseconds if it reaches the `lucee.request.limit.concurrent.maxnosleep`.

**Environment Variable:** `LUCEE_REQUESTTIMEOUT_MEMORYTHRESHOLD`
**System Property:** `-Dlucee.requesttimeout.memorythreshold`
A floating-point number between 0 and 1. Memory threshold to enforce a request timeout. If a request reaches the request timeout, Lucee will only enforce that timeout if this threshold is also reached. For example, setting it to `0.5` enforces the timeout if the memory consumption of the server is at least 50%.

**Environment Variable:** `LUCEE_RESOURCE_CHARSET`
**System Property:** `-Dlucee.resource.charset`
Default character set for reading from/writing to various resources (files).

**Environment Variable:** `LUCEE_SCRIPT_PROTECT`
**System Property:** `-Dlucee.script.protect`
Script protect setting used by default. Consult the Lucee admin page `/Settings/Request` for details on possible settings.

**Environment Variable:** `LUCEE_SECURITY_LIMITEVALUATION`
**System Property:** `-Dlucee.security.limitEvaluation`
A boolean value. If enabled, limits variable evaluation in functions/tags. If enabled, you cannot use expressions within `[ ]` like this: `susi[getVariableName()]`. This affects the following functions: `IsDefined`, `structGet`, `empty` and the following tags: `savecontent attribute "variable"`.

**Environment Variable:** `LUCEE_SSL_CHECKSERVERIDENTITY`
**System Property:** `-Dlucee.ssl.checkserveridentity`
A boolean value. If enabled, checks the identity of the SSL certificate with SMTP.

**Environment Variable:** `LUCEE_STATUS_CODE`
**System Property:** `-Dlucee.status.code`
A boolean value. If disabled, returns a 200 status code to the client even if an uncaught exception occurs.

**Environment Variable:** `LUCEE_STORE_EMPTY`
**System Property:** `-Dlucee.store.empty`
A boolean value. If enabled, does not store empty sessions to the client or session storage.

**Environment Variable:** `LUCEE_SUPPRESS_WS_BEFORE_ARG`
**System Property:** `-Dlucee.suppress.ws.before.arg`
A boolean value. If enabled, Lucee suppresses whitespace defined between the `cffunction` starting tag and the last `cfargument` tag. This setting is ignored when there is different output between these tags as whitespace.

**Environment Variable:** `LUCEE_SYSTEM_ERR`
**System Property:** `-Dlucee.system.err`
Where is the error stream of the JVM sent? Possible values are:

- `null` (the stream is ignored)
- `class:<class-name>` - the data is sent to an instance of that class that must implement the `java.io.PrintStream` interface
- `file:<file-path>` - an absolute path to a file name the stream is written to
- `log` - stream is written to `err.log` in `context/logs/`

**Environment Variable:** `LUCEE_SYSTEM_OUT`
**System Property:** `-Dlucee.system.out`
Where is the out stream of the JVM sent? Possible values are:

- `null` (the stream is ignored)
- `class:<class-name>` - the data is sent to an instance of that class that must implement the `java.io.PrintStream` interface
- `file:<file-path>` - an absolute path to a file name the stream is written to
- `log` - stream is written to `out.log` in `context/logs/`

**Environment Variable:** `LUCEE_TASKS_LIMIT`
**System Property:** `-Dlucee.tasks.limit`
Defines the maximum number of elements that can be stored in the cfthread scope. Once this limit is reached, the oldest entries are automatically removed to make room for new ones. The default value is 10000.

**Environment Variable:** `LUCEE_TEMPLATE_CHARSET`
**System Property:** `-Dlucee.template.charset`
Default character set used to read templates (`.cfm` and `.cfc` files).

**Environment Variable:** `LUCEE_TYPE_CHECKING`
**System Property:** `-Dlucee.type.checking`
A boolean value. If enabled, Lucee enforces types defined in the code. If false, type definitions are ignored.

**Environment Variable:** `LUCEE_UPLOAD_BLOCKLIST`
**System Property:** `-Dlucee.upload.blocklist`
Default block list for the tag `cffile action="upload"`. A comma-separated list of extensions that are allowed when uploading files via forms.

**Environment Variable:** `LUCEE_USE_LUCEE_SSL_TRUSTSTORE`
**System Property:** `-Dlucee.use.lucee.SSL.TrustStore`
Specifies the file location of the trust store that contains trusted Certificate Authorities (CAs) for SSL/TLS connections in Java applications.

**Environment Variable:** `LUCEE_WEB_CHARSET`
**System Property:** `-Dlucee.web.charset`
Default character set for output streams, form-, URL-, and CGI scope variables, and reading/writing the header.

**Environment Variable:** `LUCEE_CONTROLLER_GC`
**System Property:** `-Dlucee.controller.gc`
Default false, previously Lucee always ran a System.GC() every 5 minutes, available since 6.2.

**Environment Variable:** `LUCEE_URL_ENCODEALLOWPLUS`
**System Property:** `-Dlucee.url.encodeAllowPlus`
Lucee before 6.2 would attempt to re-encode a url param which contained a space. If the url param was already encoded, it would trigger re-encoding the param again, breaking it. This was avoidable previously by using cfhttp encodeurl=false, set to false to enable previous behaviour.

**Environment Variable:** `LUCEE_DUMP_THREADS`
**System Property:** `-Dlucee.dump.threads`
Used for debugging, when enabled, it will dump out running threads to the console via the background controller thread.

**Environment Variable:** `LUCEE_SCOPE_LOCAL_CAPACITY`
**System Property:** `-Dlucee.scope.local.capacity`
Sets the initial capacity (size) for the local scope hashmap.

**Environment Variable:** `LUCEE_SCOPE_ARGUMENTS_CAPACITY`
**System Property:** `-Dlucee.scope.arguments.capacity`
Sets the initial capacity (size) for the arguments scope hashmap.

**Environment Variable:** `LUCEE_CACHE_VARIABLEKEYS`
**System Property:** `-Dlucee.cache.variableKeys`
Sets the max number of variable names (keys) to cache.

**Environment Variable:** `LUCEE_THREADS_MAXDEFAULT`
**System Property:** `-Dlucee.threads.maxDefault`
Sets the default max number of parallel threads, default 20.

**Environment Variable:** `LUCEE_DEBUGGING_MAXPAGEPARTS`
**System Property:** `-Dlucee.debugging.maxPageParts`
Maximum number of debugging page parts (executionLogs to output), 0 to disable max limit.

**Environment Variable:** `LUCEE_LOGGING_FORCE_APPENDER`
**System Property:** `-Dlucee.logging.force.appender`
If set, override the default log4j appender, which is usually resource (log files), use console to log all logs to console

**Environment Variable:** `LUCEE_LOGGING_FORCE_LEVEL`
**System Property:** `-Dlucee.logging.force.level`
If set, override the default log4j log level for all logs, which is usually ERROR

**Environment Variable:** `LUCEE_SESSIONCOOKIE_ROTATE_UNKNOWN`
**System Property:** `-Dlucee.sessionCookie.rotate.unknown`
Default true, when false, unknown cfml session cookies won't be automatically rotated

## Edge Case Settings

These settings are normally not needed in a regular environment.

**Environment Variable:** `FELIX_LOG_LEVEL`
**System Property:** `-Dfelix.log.level`
Log level for the Felix Framework (OSGi).

**Environment Variable:** `LUCEE_ALLOW_COMPRESSION`
**System Property:** `-Dlucee.allow.compression`
Allows compressing (GZIP) the HTTP response if the client explicitly supports it.

**Environment Variable:** `LUCEE_APPLICATION_PATH_CACHE_TIMEOUT`
**System Property:** `-Dlucee.application.path.cache.timeout`
Lucee caches the path information to the template; this defines the idle timeout for these cache elements in milliseconds.

**Environment Variable:** `LUCEE_CASCADE_TO_RESULTSET`
**System Property:** `-Dlucee.cascade.to.resultset`
When a variable has no scope defined (example: `#myVar#` instead of `#variables.myVar#`), Lucee will also search available resultsets (CFML Standard) or not.

**Environment Variable:** `LUCEE_CLI_PRINTEXCEPTIONS`
**System Property:** `-Dlucee.cli.printExceptions`
Print out exceptions within the CLI interface.

**Environment Variable:** `LUCEE_ENABLE_WARMUP`
**System Property:** `-Dlucee.enable.warmup`
Boolean to enable/disable Lucee warmup on start.

**Environment Variable:** `LUCEE_EXTENSIONS_INSTALL`
**System Property:** `-Dlucee.extensions.install`
A boolean value to enable/disable the installation of extensions.

**Environment Variable:** `LUCEE_FULL_NULL_SUPPORT`
**System Property:** `-Dlucee.full.null.support`
A boolean value to enable/disable full null support.

**Environment Variable:** `LUCEE_LIBRARY_ADDITIONAL_FUNCTION`
**System Property:** `-Dlucee.library.additional.function`
Path to a directory for additional CFML-based functions Lucee should load to make these functions available in the application. For example, you create a file called `length.cfm` that looks like this:

```lucee
<cfscript>
function length(obj) {
    return len(obj);
}
</cfscript>
```

Then you copy that file into that directory, and you can use the function `length(any)` in all your code like a built-in function.

**Environment Variable:** `LUCEE_LIBRARY_ADDITIONAL_TAG`
**System Property:** `-Dlucee.library.additional.tag`
Path to a directory for additional CFML-based tags Lucee should load as globally available tags following the custom tag interface.

**Environment Variable:** `LUCEE_LIBRARY_DEFAULT_FUNCTION`
**System Property:** `-Dlucee.library.default.function`
Path to a directory for CFML-based functions Lucee should load to make these functions available in the application. For example, you create a file called `length.cfm` that looks like this:

```lucee
<cfscript>
function length(obj) {
    return len(obj);
}
</cfscript>
```

Then you copy that file into that directory, and you can use the function `length(any)` in all your code like a built-in function.

**Environment Variable:** `LUCEE_LIBRARY_DEFAULT_TAG`
**System Property:** `-Dlucee.library.default.tag`
Path to a directory for CFML-based tags Lucee should load as globally available tags following the custom tag interface.

**Environment Variable:** `LUCEE_LIBRARY_DEFAULT_TLD`
**System Property:** `-Dlucee.library.default.tld`
Tag Library Descriptor files (`.tld` or `.tldx`) Lucee should load to make these tags available in the application.

**Environment Variable:** `LUCEE_LISTENER_MODE`
**System Property:** `-Dlucee.listener.mode`
Where/how does Lucee look for the Application Listener?

- `currenttoroot` - looks for the file "Application.cfc/Application.cfm" from the current up to the webroot directory.
- `currentorroot` - looks for the file "Application.cfc/Application.cfm" in the current directory and in the webroot directory.
- `root` - looks for the file "Application.cfc/Application.cfm" only in the webroot.
- `current` - looks for the file "Application.cfc/Application.cfm" only in the current template directory.

**Environment Variable:** `LUCEE_LISTENER_TYPE`
**System Property:** `-Dlucee.listener.type`
Which kind of Application Listener is supported?

- `None` - no listener at all.
- `Classical (CFML < 7)` - Classic handling. Lucee looks for the file "Application.cfm" and a corresponding file "OnRequestEnd.cfm".
- `Modern` - Modern handling. Lucee only looks for the file "Application.cfc".
- `Mixed (CFML >= 7)` - Mixed handling. Lucee looks for a file "Application.cfm/OnRequestEnd.cfm" as well as for the file "Application.cfc".

**Environment Variable:** `LUCEE_LOGGING_MAIN`
**System Property:** `-Dlucee.logging.main`
Name of the main logger used by Lucee, for example, a non-existing logger is defined.

**Environment Variable:** `LUCEE_MAPPING_FIRST`
**System Property:** `-Dlucee.mapping.first`
Let's say you have the following code:

```lucee
<cfinclude template="/foo/bar/index.cfm">
```

And you have the following mappings defined:

- `/foo/bar`
- `/foo`

Then Lucee will look for `/index.cfm` in `/foo/bar` and for `/bar/index.cfm` in `/foo` and invoke the first `index.cfm` it finds, which could be in both mappings. If this setting is set to `true`, Lucee will only check `/foo/bar` for `index.cfm`.

**Environment Variable:** `LUCEE_MVN_REPO_RELEASES`
**System Property:** `-Dlucee.mvn.repo.releases`
Endpoint used by Lucee >= 6 to load releases. By default, this is `https://oss.sonatype.org/service/local/repositories/releases/content/`.

**Environment Variable:** `LUCEE_MVN_REPO_SNAPSHOTS`
**System Property:** `-Dlucee.mvn.repo.snapshots`
Endpoint used by Lucee >= 6 to load snapshots. By default, this is `https://oss.sonatype.org/content/repositories/snapshots/`.

**Environment Variable:** `LUCEE_PAGEPOOL_MAXSIZE`
**System Property:** `-Dlucee.pagePool.maxSize`
Max size of the template pool (page pool), the pool Lucee holds loaded `.cfm`/`.cfc` files. By default, this is `10000`; no number smaller than `1000` is accepted.

**Environment Variable:** `LUCEE_PRECISE_MATH`
**System Property:** `-Dlucee.precise.math`
A boolean value. If enabled, this improves the accuracy of floating-point calculations but makes them slightly slower.

**Environment Variable:** `LUCEE_PRESERVE_CASE`
**System Property:** `-Dlucee.preserve.case`
A boolean value. If true, Lucee will not convert variable names used in "dot notation" to UPPER CASE.

**Environment Variable:** `LUCEE_QUEUE_ENABLE`
**System Property:** `-Dlucee.queue.enable`
A boolean value. If true, Lucee will enable the queue for requests.

**Environment Variable:** `LUCEE_QUEUE_MAX`
**System Property:** `-Dlucee.queue.max`
The maximum concurrent requests that the engine allows to run at the same time before the engine begins to queue the requests.

**Environment Variable:** `LUCEE_QUEUE_TIMEOUT`
**System Property:** `-Dlucee.queue.timeout`
The time in milliseconds a request is held in the queue. If the time is reached, the request is rejected with an exception. If you set it to 0 seconds, the request timeout is used instead.

**Environment Variable:** `LUCEE_REQUEST_LIMIT_CONCURRENT_MAXNOSLEEP`
**System Property:** `-Dlucee.request.limit.concurrent.maxnosleep`
The maximal number of threads that are allowed to be active on the server. If this is reached, requests get forced into a "nap" (defined by `lucee.request.limit.concurrent.sleeptime`).

**Environment Variable:** `LUCEE_REQUEST_LIMIT_CONCURRENT_SLEEPTIME`
**System Property:** `-Dlucee.request.limit.concurrent.sleeptime`
How long a request should "nap" in milliseconds if it reaches the `lucee.request.limit.concurrent.maxnosleep`.

**Environment Variable:** `LUCEE_REQUESTTIMEOUT_MEMORYTHRESHOLD`
**System Property:** `-Dlucee.requesttimeout.memorythreshold`
A floating-point number between 0 and 1. Memory threshold to enforce a request timeout. If a request reaches the request timeout, Lucee will only enforce that timeout if this threshold is also reached. For example, setting it to `0.5` enforces the timeout if the memory consumption of the server is at least 50%.

**Environment Variable:** `LUCEE_RESOURCE_CHARSET`
**System Property:** `-Dlucee.resource.charset`
Default character set for reading from/writing to various resources (files).

**Environment Variable:** `LUCEE_SCRIPT_PROTECT`
**System Property:** `-Dlucee.script.protect`
Script protect setting used by default. Consult the Lucee admin page `/Settings/Request` for details on possible settings.

**Environment Variable:** `LUCEE_SECURITY_LIMITEVALUATION`
**System Property:** `-Dlucee.security.limitEvaluation`
A boolean value. If enabled, limits variable evaluation in functions/tags. If enabled, you cannot use expressions within `[ ]` like this: `susi[getVariableName()]`. This affects the following functions: `IsDefined`, `structGet`, `empty` and the following tags: `savecontent attribute "variable"`.

**Environment Variable:** `LUCEE_SSL_CHECKSERVERIDENTITY`
**System Property:** `-Dlucee.ssl.checkserveridentity`
A boolean value. If enabled, checks the identity of the SSL certificate with SMTP.

**Environment Variable:** `LUCEE_STATUS_CODE`
**System Property:** `-Dlucee.status.code`
A boolean value. If disabled, returns a 200 status code to the client even if an uncaught exception occurs.

**Environment Variable:** `LUCEE_STORE_EMPTY`
**System Property:** `-Dlucee.store.empty`
A boolean value. If enabled, does not store empty sessions to the client or session storage.

**Environment Variable:** `LUCEE_SUPPRESS_WS_BEFORE_ARG`
**System Property:** `-Dlucee.suppress.ws.before.arg`
A boolean value. If enabled, Lucee suppresses whitespace defined between the `cffunction` starting tag and the last `cfargument` tag. This setting is ignored when there is different output between these tags as whitespace.

**Environment Variable:** `LUCEE_SYSTEM_ERR`
**System Property:** `-Dlucee.system.err`
Where is the error stream of the JVM sent? Possible values are:

- `null` (the stream is ignored)
- `class:` - the data is sent to an instance of that class that must implement the `java.io.PrintStream` interface
- `file:` - an absolute path to a file name the stream is written to
- `log` - stream is written to `err.log` in `context/logs/`

**Environment Variable:** `LUCEE_SYSTEM_OUT`
**System Property:** `-Dlucee.system.out`
Where is the out stream of the JVM sent? Possible values are:

- `null` (the stream is ignored)
- `class:` - the data is sent to an instance of that class that must implement the `java.io.PrintStream` interface
- `file:` - an absolute path to a file name the stream is written to
- `log` - stream is written to `out.log` in `context/logs/`

**Environment Variable:** `LUCEE_TEMPLATE_CHARSET`
**System Property:** `-Dlucee.template.charset`
Default character set used to read templates (`.cfm` and `.cfc` files).

**Environment Variable:** `LUCEE_TYPE_CHECKING`
**System Property:** `-Dlucee.type.checking`
A boolean value. If enabled, Lucee enforces types defined in the code. If false, type definitions are ignored.

**Environment Variable:** `LUCEE_UPLOAD_BLOCKLIST`
**System Property:** `-Dlucee.upload.blocklist`
Default block list for the tag `cffile action="upload"`. A comma-separated list of extensions that are allowed when uploading files via forms.

**Environment Variable:** `LUCEE_USE_LUCEE_SSL_TRUSTSTORE`
**System Property:** `-Dlucee.use.lucee.SSL.TrustStore`
Specifies the file location of the trust store that contains trusted Certificate Authorities (CAs) for SSL/TLS connections in Java applications.

**Environment Variable:** `LUCEE_WEB_CHARSET`
**System Property:** `-Dlucee.web.charset`
Default character set for output streams, form-, URL-, and CGI scope variables, and reading/writing the header.
