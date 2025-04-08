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

Each sub-heading is the name of the Environment Variable (EnvVar), the equivalent Java System Property (SysProp) is identical, simply in lower case, with underscores replaced by dots.

## Important Settings

The following settings are very useful and important to know.

#### LUCEE_ADMIN_ENABLED

*SysProp:* `-Dlucee.admin.enabled`
*EnvVar:* `LUCEE_ADMIN_ENABLED`

Should the Lucee Admin be available or not.

#### LUCEE_ADMIN_PASSWORD

*SysProp:* `-Dlucee.admin.password`
*EnvVar:* `LUCEE_ADMIN_PASSWORD`

Password used for the Lucee admin (when you run Lucee in multi mode, the password for the Server admin).

#### LUCEE_DATASOURCE_POOL_VALIDATE

*SysProp:* `-Dlucee.datasource.pool.validate`
*EnvVar:* `LUCEE_DATASOURCE_POOL_VALIDATE`

If enabled, Lucee will validate existing datasource connections reused from the datasource pool before using them. This protects from exceptions caused by connections dropped by the DB server but creates additional communication between Lucee and the DB server.

** removed in 6.2 **

#### LUCEE_DEBUGGING_OPTIONS

*SysProp:* `-Dlucee.debugging.options`
*EnvVar:* `LUCEE_DEBUGGING_OPTIONS`

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

#### LUCEE_ENCRYPTION_ALGORITHM

*SysProp:* `-Dlucee.encryption.algorithm`
*EnvVar:* `LUCEE_ENCRYPTION_ALGORITHM`

Default encryption algorithm used when none is specified. The default "cfmx_compat" is not cryptographically secure - strongly recommended to use "AES" instead.
Valid values: CFMX_COMPAT, AES, BLOWFISH, DES

#### LUCEE_EXTENSIONS

*SysProp:* `-Dlucee.extensions`
*EnvVar:* `LUCEE_EXTENSIONS`

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

#### LUCEE_LOGINSTORAGE_ITERATIONS

*SysProp:* `-Dlucee.loginstorage.iterations`
*EnvVar:* `LUCEE_LOGINSTORAGE_ITERATIONS`

Specifies the number of encryption iterations for `loginstorage`. The default is 0.

#### LUCEE_LOGINSTORAGE_PRIVATEKEY

*SysProp:* `-Dlucee.loginstorage.privatekey`
*EnvVar:* `LUCEE_LOGINSTORAGE_PRIVATEKEY`

A private key used to encrypt `loginstorage`. If not defined, a simple base64 encoding is used.

#### LUCEE_LOGINSTORAGE_SALT

*SysProp:* `-Dlucee.loginstorage.salt`
*EnvVar:* `LUCEE_LOGINSTORAGE_SALT`

The salt used for encrypting `loginstorage`. If no salt is defined, a hardcoded salt is used.

#### LUCEE_PASSWORD_ENC_KEY

*SysProp:* `-Dlucee.password.enc.key`
*EnvVar:* `LUCEE_PASSWORD_ENC_KEY`

The private encryption key used by Lucee to encrypt passwords stored in the configuration, such as for datasources.

#### LUCEE_CFID_URL_ALLOW

previously `LUCEE_READ_CFID_FROM_URL`

*SysProp:* `-Dlucee.cfid.url.allow` (previously `-Dlucee.read.cfid.from.url`)
*EnvVar:* `LUCEE_CFID_URL_ALLOW` (previously `LUCEE_READ_CFID_FROM_URL`)

Controls whether Lucee accepts CFID values from URL query strings. Set to false to enhance security by requiring CFIDs to be passed via cookies only.
The previous property names are still supported for backward compatibility, but the new names are preferred starting with Lucee 6.2.1.59.
Setting this to false is strongly recommended for all production environments.

#### LUCEE_CFID_URL_LOG

*SysProp:* `-Dlucee.cfid.url.log`
*EnvVar:* `LUCEE_CFID_URL_LOG`

When set to a log name, Lucee will log all instances where CFID is read from a URL parameter and used.
The log includes URL, IP address, user agent, referrer, and stack trace in JSON format.
This helps identify code that needs to be updated before URL-based CFID is disabled for security reasons.

#### LUCEE_REQUESTTIMEOUT

*SysProp:* `-Dlucee.requesttimeout`
*EnvVar:* `LUCEE_REQUESTTIMEOUT`

A boolean value. If false, Lucee will disable request timeouts.

#### LUCEE_REQUESTTIMEOUT_CONCURRENTREQUESTTHRESHOLD

*SysProp:* `-Dlucee.requesttimeout.concurrentrequestthreshold`
*EnvVar:* `LUCEE_REQUESTTIMEOUT_CONCURRENTREQUESTTHRESHOLD`

Concurrent request threshold to enforce a request timeout. If a request reaches the timeout, Lucee will only enforce it if this threshold is also reached. For example, setting it to `100` means the timeout is enforced only if there are at least 99 other requests running.

#### LUCEE_REQUESTTIMEOUT_CPUTHRESHOLD

*SysProp:* `-Dlucee.requesttimeout.cputhreshold`
*EnvVar:* `LUCEE.REQUESTTIMEOUT.CPUTHRESHOLD`

A floating-point number between 0 and 1. CPU threshold to enforce a request timeout. If a request reaches the timeout, Lucee will only enforce it if the CPU usage of the current core is at least the specified threshold. For example, setting it to `0.5` enforces the timeout if the CPU is at least 50%.

#### LUCEE_SERVER_DIR

*SysProp:* `-Dlucee.server.dir`
*EnvVar:* `LUCEE_SERVER.DIR`

Specifies the file directory for the Lucee server context.

#### LUCEE_VERSION

*SysProp:* `-Dlucee.version`
*EnvVar:* `LUCEE_VERSION`

Defines the version of Lucee to load. For example, setting it to `6.1.0.0` will load that version. If not available locally, Lucee will automatically download it from Maven.

#### LUCEE_ADMIN_MODE="single|multi"

*SysProp:* `-Dlucee.admin.mode`
*EnvVar:* `LUCEE_ADMIN_MODE`

This setting only applies to Lucee 6 (above `6.1.1.54`), Lucee 6 can run in `single` mode or `multi` mode. In single mode, Lucee only has one set of configurations for the whole server. In multi mode, you have a base configuration for the whole server, but then every web context has its own configuration to override the base configuration. With Lucee 5, you only have multi mode and with Lucee 7, you only have single mode.
By default, a new version of Lucee 6 with no `.CFConfig.json` provided that contains a `mode:"single|multi"` setting starts in single mode. When you update from Lucee 5, you start in multi mode.
To change this behavior, you can set the environment variable `LUCEE_ADMIN_MODE="single|multi"` or SysProp `-Dlucee.admin.mode="single|multi"`.

#### LUCEE_ADMIN_MODE_DEFAULT="single|multi"

*SysProp:* `-Dlucee.admin.mode.default`
*EnvVar:* `LUCEE_ADMIN_MODE_DEFAULT`

This setting functions similarly to `LUCEE_ADMIN_MODE`, but it only affects the default behavior and can be overridden by any setting in `.CFConfig.json`.

#### LUCEE_CASCADING_WRITE_TO_VARIABLES_LOG

*SysProp:* `-Dlucee.cascading.write.to.variables.log`
*EnvVar:* `LUCEE_CASCADING_WRITE_TO_VARIABLES.LOG`

This setting only applies to Lucee 6 (above `6.2.1.82`). Enables logging when variables are implicitly written to the variables scope (without an explicit scope definition). When set to a log level name (e.g., "application"), Lucee will log details about variables being assigned without explicit scope at the DEBUG level. This helps identify code that could be optimized by using proper variable scoping. 

#### LUCEE_CASCADING_WRITE_TO_VARIABLES_LOG

*SysProp:* `-Dlucee.cascading.write.to.variables.log`
*EnvVar:* `LUCEE_CASCADING_WRITE_TO_VARIABLES.LOG`

This setting only applies to Lucee 6 (above `6.2.1.82`). Enables logging when variables are implicitly written to the variables scope (without an explicit scope definition). When set to a log name (e.g., "application"), Lucee will log details about variables being assigned without explicit scope. The log level can be customized using the `LUCEE_CASCADING_WRITE_TO_VARIABLES_LOGLEVEL` setting. This helps identify code that could be optimized by using proper variable scoping. This setting excludes certain internal variables (_cfquery, _cflock, _thread) from being logged.

#### LUCEE_CASCADING_WRITE_TO_VARIABLES_LOGLEVEL

*SysProp:* `-Dlucee.cascading.write.to.variables.loglevel`
*EnvVar:* `LUCEE_CASCADING_WRITE_TO_VARIABLES.LOGLEVEL`

This setting only applies to Lucee 6 (above `6.2.1.82`). Specifies the log level for cascading write detection logs. Valid values are: DEBUG, INFO, WARN, ERROR. If not specified, the default level is DEBUG.

## Breaking Changes

Major updates for Lucee can sometimes cause breaking changes. The settings below allow you to emulate the behavior of older Lucee versions in newer versions.

#### LUCEE_QUERY_ALLOWEMPTYASNULL

*SysProp:* `-Dlucee.query.allowemptyasnull`
*EnvVar:* `LUCEE_QUERY_ALLOWEMPTYASNULL`

In Lucee 5, an empty string passed into a query parameter with a numeric type was interpreted as null. In Lucee 6, this is no longer accepted and throws an exception.
You can simulate the old behavior by setting this environment variable or SysProp to `true`.

By setting the log level of the `datasource` log to `warn`, you will receive information in the log when the old behavior is used.
This allows you to modify your code for the new behavior without encountering runtime issues with the existing code.

#### LUCEE_DESERIALIZEJSON_ALLOWEMPTY

*SysProp:* `-Dlucee.deserializejson.allowempty`
*EnvVar:* `LUCEE_DESERIALIZEJSON_ALLOWEMPTY`

In Lucee 5, an empty string passed into the function deserializeJson will return an empty string back. In Lucee 6, this is no longer accepted and throws an exception.
You can simulate the old behavior by setting this environment variable or SysProp to `true`.

By setting the log level of the `application` log to `warn`, you will receive information in the log when the old behavior is used.
This allows you to modify your code for the new behavior without encountering runtime issues with the existing code.

## Regular Settings

Settings that are nice to know, but not that important.

#### LUCEE_MAVEN_LOCAL_REPOSITORY

*SysProp:* `-Dlucee.maven.local.repository`
*EnvVar:* `LUCEE_MAVEN_LOCAL_REPOSITORY`

Defines the location in the local filesystem where Lucee stores downloaded Maven artifacts. If not explicitly configured, artifacts will be stored in the default location at `lucee-server/mvn/`.

#### LUCEE_MAVEN_DEFAULT_REPOSITORIES

*SysProp:* `-Dlucee.maven.default.repositories`
*EnvVar:* `LUCEE_MAVEN_DEFAULT_REPOSITORIES`

Specifies a comma-separated list of Maven repository URLs to use before the default repositories (Maven Central, Sonatype, JCenter). This allows customizing the Maven repositories used by Lucee for downloading dependencies.

- URLs must be valid Maven repository paths ending with a trailing slash (/)
- Repositories specified will be added at the beginning of Lucee's repository list
- Can be used to specify local repositories accessible to the server
- Particularly valuable for servers behind firewalls with limited external access

#### FELIX_LOG_LEVEL

*SysProp:* `-Dfelix.log.level`
*EnvVar:* `FELIX_LOG_LEVEL`

Log level for the Felix Framework (OSGi).

#### LUCEE_ALLOW_COMPRESSION

*SysProp:* `-Dlucee.allow.compression`
*EnvVar:* `LUCEE_ALLOW_COMPRESSION`

Allows compressing (GZIP) the HTTP response if the client explicitly supports it.

#### LUCEE_APPLICATION_PATH_CACHE_TIMEOUT

*SysProp:* `-Dlucee.application.path.cache.timeout`
*EnvVar:* `LUCEE_APPLICATION_PATH_CACHE_TIMEOUT`

Lucee caches the path information to the template; this defines the idle timeout for these cache elements in milliseconds.

#### LUCEE_COMPILER_BLOCK_BYTECODE

*SysProp:* `-Dlucee.compiler.block.bytecode`
*EnvVar:* `LUCEE_COMPILER_BLOCK_BYTECODE`

Controls whether Lucee allows the direct execution of precompiled bytecode files (.cfm). Set to true to prevent bytecode execution, requiring all CFML files to be provided as source code.

#### LUCEE_CASCADE_TO_RESULTSET

*SysProp:* `-Dlucee.cascade.to.resultset`
*EnvVar:* `LUCEE_CASCADE_TO_RESULTSET`

When a variable has no scope defined (example: `#myVar#` instead of `#variables.myVar#`), Lucee will also search available resultsets (CFML Standard) or not.

#### LUCEE_CLI_PRINTEXCEPTIONS

*SysProp:* `-Dlucee.cli.printExceptions`
*EnvVar:* `LUCEE_CLI_PRINTEXCEPTIONS`

Print out exceptions within the CLI interface.

#### LUCEE_ENABLE_WARMUP

*SysProp:* `-Dlucee.enable.warmup`
*EnvVar:* `LUCEE_ENABLE_WARMUP`

Boolean to enable/disable Lucee warmup on start.

#### LUCEE_EXTENSIONS_INSTALL

*SysProp:* `-Dlucee.extensions.install`
*EnvVar:* `LUCEE_EXTENSIONS_INSTALL`

A boolean value to enable/disable the installation of extensions.

#### LUCEE_FULL_NULL_SUPPORT

*SysProp:* `-Dlucee.full.null.support`
*EnvVar:* `LUCEE_FULL_NULL_SUPPORT`

A boolean value to enable/disable full null support.

#### LUCEE_LIBRARY_ADDITIONAL_FUNCTION

*SysProp:* `-Dlucee.library.additional.function`
*EnvVar:* `LUCEE_LIBRARY_ADDITIONAL_FUNCTION`

Path to a directory for additional CFML-based functions Lucee should load to make these functions available in the application. For example, you create a file called `length.cfm` that looks like this:

```lucee
function length(obj) {
    return len(obj);
}
```

Then you copy that file into that directory, and you can use the function `length(any)` in all your code like a built-in function.

#### LUCEE_LIBRARY_ADDITIONAL_TAG

*SysProp:* `-Dlucee.library.additional.tag`
*EnvVar:* `LUCEE_LIBRARY_ADDITIONAL_TAG`

Path to a directory for additional CFML-based tags Lucee should load as globally available tags following the custom tag interface.

#### LUCEE_LIBRARY_DEFAULT_FUNCTION

*SysProp:* `-Dlucee.library.default.function`
*EnvVar:* `LUCEE_LIBRARY_DEFAULT_FUNCTION`

Path to a directory for CFML-based functions Lucee should load to make these functions available in the application. For example, you create a file called `length.cfm` that looks like this:

```lucee
function length(obj) {
    return len(obj);
}
```

Then you copy that file into that directory, and you can use the function `length(any)` in all your code like a built-in function.

#### LUCEE_LIBRARY_DEFAULT_TAG

*SysProp:* `-Dlucee.library.default.tag`
*EnvVar:* `LUCEE_LIBRARY_DEFAULT_TAG`

Path to a directory for CFML-based tags Lucee should load as globally available tags following the custom tag interface.

#### LUCEE_LIBRARY_DEFAULT_TLD

*SysProp:* `-Dlucee.library.default.tld`
*EnvVar:* `LUCEE_LIBRARY_DEFAULT_TLD`

Tag Library Descriptor files (.tld or .tldx) Lucee should load to make these tags available in the application.

#### LUCEE_LISTENER_MODE

*SysProp:* `-Dlucee.listener.mode`
*EnvVar:* `LUCEE_LISTENER.MODE`

Where/how does Lucee look for the Application Listener?

- `currenttoroot` - looks for the file "Application.cfc/Application.cfm" from the current up to the webroot directory.
- `currentorroot` - looks for the file "Application.cfc/Application.cfm" in the current directory and in the webroot directory.
- `root` - looks for the file "Application.cfc/Application.cfm" only in the webroot.
- `current` - looks for the file "Application.cfc/Application.cfm" only in the current template directory.

#### LUCEE_LISTENER_TYPE

*SysProp:* `-Dlucee.listener.type`
*EnvVar:* `LUCEE_LISTENER_TYPE`

Which kind of Application Listener is supported?

- `None` - no listener at all.
- `Classical (CFML < 7)` - Classic handling. Lucee looks for the file "Application.cfm" and a corresponding file "OnRequestEnd.cfm".
- `Modern` - Modern handling. Lucee only looks for the file "Application.cfc".
- `Mixed (CFML >= 7)` - Mixed handling. Lucee looks for a file "Application.cfm/OnRequestEnd.cfm" as well as for the file "Application.cfc".

#### LUCEE_LISTENER_SINGELTON

*SysProp:* `-Dlucee.listener.singelton`
*EnvVar:* `LUCEE_LISTENER_SINGELTON`

Controls how Lucee manages Application.cfc instances (introduced in Lucee 7). When set to false (Classic behavior), Lucee creates a new Application.cfc instance for each request and executes the component body constructor every time. When set to true (Singleton behavior), the component loads only during startup or when the component template changes.

Note: With singleton mode enabled, settings defined in the component body remain persistent between requests. Configuration changes should be made within listener functions like onApplicationStart, onSessionStart or onRequestStart.

#### LUCEE_LOGGING_MAIN

*SysProp:* `-Dlucee.logging.main`
*EnvVar:* `LUCEE_LOGGING_MAIN`

Name of the main logger used by Lucee, for example, a non-existing logger is defined.

#### LUCEE_MAPPING_FIRST

*SysProp:* `-Dlucee.mapping.first`
*EnvVar:* `LUCEE_MAPPING_FIRST`

Let's say you have the following code:

```lucee
<cfinclude template="/foo/bar/index.cfm">
```

And you have the following mappings defined:

- `/foo/bar`
- `/foo`

Then Lucee will look for `/index.cfm` in `/foo/bar` and for `/bar/index.cfm` in `/foo` and invoke the first `index.cfm` it finds, which could be in both mappings. If this setting is set to `true`, Lucee will only check `/foo/bar` for `index.cfm`.

#### LUCEE_MVN_REPO_RELEASES

*SysProp:* `-Dlucee.mvn.repo.releases`
*EnvVar:* `LUCEE_MVN_REPO_RELEASES`

Endpoint used by Lucee >= 6 to load releases, by default this is `https://oss.sonatype.org/service/local/repositories/releases/content/`.

#### LUCEE_MVN_REPO_SNAPSHOTS

*SysProp:* `-Dlucee.mvn.repo.snapshots`
*EnvVar:* `LUCEE_MVN_REPO_SNAPSHOTS`

Endpoint used by Lucee >= 6 to load snapshots, by default this is `https://oss.sonatype.org/content/repositories/snapshots/`.

#### LUCEE_PAGEPOOL_MAXSIZE

*SysProp:* `-Dlucee.pagePool.maxSize`
*EnvVar:* `LUCEE_PAGEPOOL_MAXSIZE`

Max size of the template pool (page pool), the pool Lucee holds loaded `.cfm`/`.cfc` files. By default, this is `10000`; no number smaller than `1000` is accepted.

#### LUCEE_PRECISE_MATH

*SysProp:* `-Dlucee.precise.math`
*EnvVar:* `LUCEE_PRECISE_MATH`

A boolean value. If enabled, this improves the accuracy of floating-point calculations but makes them slightly slower.

#### LUCEE_PRESERVE_CASE

*SysProp:* `-Dlucee.preserve.case`
*EnvVar:* `LUCEE_PRESERVE_CASE`

A boolean value. If true, Lucee will not convert variable names used in "dot notation" to UPPER CASE.

#### LUCEE_QUEUE_ENABLE

*SysProp:* `-Dlucee.queue.enable`
*EnvVar:* `LUCEE_QUEUE_ENABLE`

A boolean value. If true, Lucee will enable the queue for requests.

#### LUCEE_QUEUE_MAX

*SysProp:* `-Dlucee.queue.max`
*EnvVar:* `LUCEE.QUEUE.MAX`

The maximum concurrent requests that the engine allows to run at the same time before the engine begins to queue the requests.

#### LUCEE_QUEUE_TIMEOUT

*SysProp:* `-Dlucee.queue.timeout`
*EnvVar:* `LUCEE_QUEUE_TIMEOUT`

The time in milliseconds a request is held in the queue. If the time is reached, the request is rejected with an exception. If you set it to 0 seconds, the request timeout is used instead.

#### LUCEE_REQUEST_LIMIT_CONCURRENT_MAXNOSLEEP

*SysProp:* `-Dlucee.request.limit.concurrent.maxnosleep`
*EnvVar:* `LUCEE_REQUEST_LIMIT_CONCURRENT_MAXNOSLEEP`

The maximal number of threads that are allowed to be active on the server. If this is reached, requests get forced into a "nap" (defined by `lucee.request.limit.concurrent.sleeptime`).

#### LUCEE_REQUEST_LIMIT_CONCURRENT_SLEEPTIME

*SysProp:* `-Dlucee.request.limit.concurrent.sleeptime`
*EnvVar:* `LUCEE_REQUEST_LIMIT_CONCURRENT_SLEEPTIME`

How long a request should "nap" in milliseconds if it reaches the `lucee.request.limit.concurrent.maxnosleep`.

#### LUCEE_REQUESTTIMEOUT_MEMORYTHRESHOLD

*SysProp:* `-Dlucee.requesttimeout.memorythreshold`
*EnvVar:* `LUCEE_REQUESTTIMEOUT_MEMORYTHRESHOLD`

A floating-point number between 0 and 1. Memory threshold to enforce a request timeout. If a request reaches the request timeout, Lucee will only enforce that timeout if this threshold is also reached. For example, setting it to `0.5` enforces the timeout if the memory consumption of the server is at least 50%.

#### LUCEE_RESOURCE_CHARSET

*SysProp:* `-Dlucee.resource.charset`
*EnvVar:* `LUCEE_RESOURCE_CHARSET`

Default character set for reading from/writing to various resources (files).

#### LUCEE_SCRIPT_PROTECT

*SysProp:* `-Dlucee.script.protect`
*EnvVar:* `LUCEE_SCRIPT_PROTECT`

Script protect setting used by default. Consult the Lucee admin page `/Settings/Request` for details on possible settings.

#### LUCEE_SECURITY_LIMITEVALUATION

*SysProp:* `-Dlucee.security.limitEvaluation`
*EnvVar:* `LUCEE_SECURITY_LIMITEVALUATION`

A boolean value. If enabled, limits variable evaluation in functions/tags. If enabled, you cannot use expressions within `[ ]` like this: `susi[getVariableName()]`. This affects the following functions: `IsDefined`, `structGet`, `empty` and the following tags: `savecontent attribute "variable"`.

#### LUCEE_SSL_CHECKSERVERIDENTITY

*SysProp:* `-Dlucee.ssl.checkserveridentity`
*EnvVar:* `LUCEE_SSL_CHECKSERVERIDENTITY`

A boolean value. If enabled, checks the identity of the SSL certificate with SMTP.

#### LUCEE_STATUS_CODE

*SysProp:* `-Dlucee.status.code`
*EnvVar:* `LUCEE_STATUS_CODE`

A boolean value. If disabled, returns a 200 status code to the client even if an uncaught exception occurs.

#### LUCEE_STORE_EMPTY

*SysProp:* `-Dlucee.store.empty`
*EnvVar:* `LUCEE_STORE_EMPTY`

A boolean value. If enabled, does not store empty sessions to the client or session storage.

#### LUCEE_SUPPRESS_WS_BEFORE_ARG

*SysProp:* `-Dlucee.suppress.ws.before.arg`
*EnvVar:* `LUCEE_SUPPRESS_WS_BEFORE_ARG`

A boolean value. If enabled, Lucee suppresses whitespace defined between the `cffunction` starting tag and the last `cfargument` tag. This setting is ignored when there is different output between these tags as whitespace.

#### LUCEE_SYSTEM_ERR

*SysProp:* `-Dlucee.system.err`
*EnvVar:* `LUCEE_SYSTEM_ERR`

Where is the error stream of the JVM sent? Possible values are:

- `null` (the stream is ignored)
- `class:<class-name>` - the data is sent to an instance of that class that must implement the `java.io.PrintStream` interface
- `file:<file-path>` - an absolute path to a file name the stream is written to
- `log` - stream is written to `err.log` in `context/logs/`

#### LUCEE_SYSTEM_OUT

*SysProp:* `-Dlucee.system.out`
*EnvVar:* `LUCEE_SYSTEM_OUT`

Where is the out stream of the JVM sent? Possible values are:

- `null` (the stream is ignored)
- `class:<class-name>` - the data is sent to an instance of that class that must implement the `java.io.PrintStream` interface
- `file:<file-path>` - an absolute path to a file name the stream is written to
- `log` - stream is written to `out.log` in `context/logs/`

#### LUCEE_TASKS_LIMIT

*SysProp:* `-Dlucee.tasks.limit`
*EnvVar:* `LUCEE_TASKS_LIMIT`

Defines the maximum number of elements that can be stored in the cfthread scope. Once this limit is reached, the oldest entries are automatically removed to make room for new ones. The default value is 10000.

#### LUCEE_TEMPLATE_CHARSET

*SysProp:* `-Dlucee.template.charset`
*EnvVar:* `LUCEE_TEMPLATE_CHARSET`

Default character set used to read templates (`.cfm` and `.cfc` files).

#### LUCEE_TYPE_CHECKING

*SysProp:* `-Dlucee.type.checking`
*EnvVar:* `LUCEE_TYPE_CHECKING`

A boolean value. If enabled, Lucee enforces types defined in the code. If false, type definitions are ignored.

#### LUCEE_UPLOAD_BLOCKLIST

*SysProp:* `-Dlucee.upload.blocklist`
*EnvVar:* `LUCEE_UPLOAD_BLOCKLIST`

Default block list for the tag `cffile action="upload"`. A comma-separated list of extensions that are allowed when uploading files via forms.

#### LUCEE_USE_LUCEE_SSL_TRUSTSTORE

*SysProp:* `-Dlucee.use.lucee.SSL.TrustStore`
*EnvVar:* `LUCEE_USE_LUCEE_SSL_TRUSTSTORE`

Specifies the file location of the trust store that contains trusted Certificate Authorities (CAs) for SSL/TLS connections in Java applications. Lucee 6 uses the JVM trust store by default.

#### LUCEE_WEB_CHARSET

*SysProp:* `-Dlucee.web.charset`
*EnvVar:* `LUCEE_WEB_CHARSET`

Default character set for output streams, form-, URL-, and CGI scope variables, and reading/writing the header.

#### LUCEE_CONTROLLER_GC

*SysProp:* `-Dlucee.controller.gc`
*EnvVar:* `LUCEE_CONTROLLER_GC`

Default false, previously Lucee always ran a System.GC() every 5 minutes, available since 6.2.

#### LUCEE_URL_ENCODEALLOWPLUS

*SysProp:* `-Dlucee.url.encodeAllowPlus`
*EnvVar:* `LUCEE_URL_ENCODEALLOWPLUS`

Lucee before 6.2 would attempt to re-encode a url param which contained a space. If the url param was already encoded, it would trigger re-encoding the param again, breaking it. This was avoidable previously by using cfhttp encodeurl=false, set to false to enable previous behaviour.

#### LUCEE_DUMP_THREADS

*SysProp:* `-Dlucee.dump.threads`
*EnvVar:* `LUCEE_DUMP_THREADS`

Used for debugging, when enabled, it will dump out running threads to the console via the background controller thread.

#### LUCEE_SCOPE_LOCAL_CAPACITY

*SysProp:* `-Dlucee.scope.local.capacity`
*EnvVar:* `LUCEE_SCOPE_LOCAL_CAPACITY`

Sets the initial capacity (size) for the local scope hashmap.

#### LUCEE_SCOPE_ARGUMENTS_CAPACITY

*SysProp:* `-Dlucee.scope.arguments.capacity`
*EnvVar:* `LUCEE_SCOPE_ARGUMENTS_CAPACITY`

Sets the initial capacity (size) for the arguments scope hashmap.

#### LUCEE_CACHE_VARIABLEKEYS

*SysProp:* `-Dlucee.cache.variableKeys`
*EnvVar:* `LUCEE.CACHE.VARIABLEKEYS`

Sets the max number of variable names (keys) to cache.

#### LUCEE_THREADS_MAXDEFAULT

*SysProp:* `-Dlucee.threads.maxDefault`
*EnvVar:* `LUCEE_THREADS_MAXDEFAULT`

Sets the default max number of parallel threads, default 20.

#### LUCEE_DEBUGGING_MAXPAGEPARTS

*SysProp:* `-Dlucee.debugging.maxPageParts`
*EnvVar:* `LUCEE_DEBUGGING_MAXPAGEPARTS`

Maximum number of debugging page parts (executionLogs to output), 0 to disable max limit.

#### LUCEE_LOGGING_FORCE_APPENDER

*SysProp:* `-Dlucee.logging.force.appender`
*EnvVar:* `LUCEE_LOGGING_FORCE_APPENDER`

If set, override the default log4j appender, which is usually resource (log files), use console to log all logs to console

#### LUCEE_LOGGING_FORCE_LEVEL

*SysProp:* `-Dlucee.logging.force.level`
*EnvVar:* `LUCEE_LOGGING_FORCE_LEVEL`

If set, override the default log4j log level for all logs, which is usually ERROR

#### LUCEE_SESSIONCOOKIE_ROTATE_UNKNOWN

*SysProp:* `-Dlucee.sessionCookie.rotate.unknown`
*EnvVar:* `LUCEE_SESSIONCOOKIE_ROTATE_UNKNOWN`

Default true, when false, unknown cfml session cookies won't be automatically rotated

## Edge Case Settings

These settings are normally not needed in a regular environment.

#### FELIX_LOG_LEVEL

*SysProp:* `-Dfelix.log.level`
*EnvVar:* `FELIX_LOG_LEVEL`

Log level for the Felix Framework (OSGi).

#### LUCEE_ALLOW_COMPRESSION

*SysProp:* `-Dlucee.allow.compression`
*EnvVar:* `LUCEE_ALLOW_COMPRESSION`

Allows compressing (GZIP) the HTTP response if the client explicitly supports it.

#### LUCEE_APPLICATION_PATH_CACHE_TIMEOUT

*SysProp:* `-Dlucee.application.path.cache.timeout`
*EnvVar:* `LUCEE_APPLICATION_PATH_CACHE_TIMEOUT`

Lucee caches the path information to the template; this defines the idle timeout for these cache elements in milliseconds.

#### LUCEE_CASCADE_TO_RESULTSET

*SysProp:* `-Dlucee.cascade.to.resultset`
*EnvVar:* `LUCEE_CASCADE_TO_RESULTSET`

When a variable has no scope defined (example: `#myVar#` instead of `#variables.myVar#`), Lucee will also search available resultsets (CFML Standard) or not.

#### LUCEE_CLI_PRINTEXCEPTIONS

*SysProp:* `-Dlucee.cli.printExceptions`
*EnvVar:* `LUCEE_CLI_PRINTEXCEPTIONS`

Print out exceptions within the CLI interface.

#### LUCEE_ENABLE_WARMUP

*SysProp:* `-Dlucee.enable.warmup`
*EnvVar:* `LUCEE_ENABLE_WARMUP`

Boolean to enable/disable Lucee warmup on start.

#### LUCEE_EXTENSIONS_INSTALL

*SysProp:* `-Dlucee.extensions.install`
*EnvVar:* `LUCEE_EXTENSIONS_INSTALL`

A boolean value to enable/disable the installation of extensions.

#### LUCEE_FULL_NULL_SUPPORT

*SysProp:* `-Dlucee.full.null.support`
*EnvVar:* `LUCEE_FULL_NULL_SUPPORT`

A boolean value to enable/disable full null support.

#### LUCEE_LIBRARY_ADDITIONAL_FUNCTION

*SysProp:* `-Dlucee.library.additional.function`
*EnvVar:* `LUCEE_LIBRARY_ADDITIONAL_FUNCTION`

Path to a directory for additional CFML-based functions Lucee should load to make these functions available in the application. For example, you create a file called `length.cfm` that looks like this:

```lucee
<cfscript>
function length(obj) {
    return len(obj);
}
</cfscript>
```

Then you copy that file into that directory, and you can use the function `length(any)` in all your code like a built-in function.

#### LUCEE_LIBRARY_ADDITIONAL_TAG

*SysProp:* `-Dlucee.library.additional.tag`
*EnvVar:* `LUCEE_LIBRARY_ADDITIONAL_TAG`

Path to a directory for additional CFML-based tags Lucee should load as globally available tags following the custom tag interface.

#### LUCEE_LIBRARY_DEFAULT_FUNCTION

*SysProp:* `-Dlucee.library.default.function`
*EnvVar:* `LUCEE_LIBRARY_DEFAULT_FUNCTION`

Path to a directory for CFML-based functions Lucee should load to make these functions available in the application. For example, you create a file called `length.cfm` that looks like this:

```lucee
<cfscript>
function length(obj) {
    return len(obj);
}
</cfscript>
```

Then you copy that file into that directory, and you can use the function `length(any)` in all your code like a built-in function.

#### LUCEE_LIBRARY_DEFAULT_TAG

*SysProp:* `-Dlucee.library.default.tag`
*EnvVar:* `LUCEE_LIBRARY_DEFAULT_TAG`

Path to a directory for CFML-based tags Lucee should load as globally available tags following the custom tag interface.

#### LUCEE_LIBRARY_DEFAULT_TLD

*SysProp:* `-Dlucee.library.default.tld`
*EnvVar:* `LUCEE_LIBRARY_DEFAULT_TLD`

Tag Library Descriptor files (`.tld` or `.tldx`) Lucee should load to make these tags available in the application.

#### LUCEE_LISTENER_MODE

*SysProp:* `-Dlucee.listener.mode`
*EnvVar:* `LUCEE_LISTENER_MODE`

Where/how does Lucee look for the Application Listener?

- `currenttoroot` - looks for the file "Application.cfc/Application.cfm" from the current up to the webroot directory.
- `currentorroot` - looks for the file "Application.cfc/Application.cfm" in the current directory and in the webroot directory.
- `root` - looks for the file "Application.cfc/Application.cfm" only in the webroot.
- `current` - looks for the file "Application.cfc/Application.cfm" only in the current template directory.

#### LUCEE_LISTENER_TYPE

*SysProp:* `-Dlucee.listener.type`
*EnvVar:* `LUCEE_LISTENER_TYPE`

Which kind of Application Listener is supported?

- `None` - no listener at all.
- `Classical (CFML < 7)` - Classic handling. Lucee looks for the file "Application.cfm" and a corresponding file "OnRequestEnd.cfm".
- `Modern` - Modern handling. Lucee only looks for the file "Application.cfc".
- `Mixed (CFML >= 7)` - Mixed handling. Lucee looks for a file "Application.cfm/OnRequestEnd.cfm" as well as for the file "Application.cfc".

#### LUCEE_LOGGING_MAIN

*SysProp:* `-Dlucee.logging.main`
*EnvVar:* `LUCEE_LOGGING_MAIN`

Name of the main logger used by Lucee, for example, a non-existing logger is defined.

#### LUCEE_MAPPING_FIRST

*SysProp:* `-Dlucee.mapping.first`
*EnvVar:* `LUCEE_MAPPING_FIRST`

Let's say you have the following code:

```lucee
<cfinclude template="/foo/bar/index.cfm">
```

And you have the following mappings defined:

- `/foo/bar`
- `/foo`

Then Lucee will look for `/index.cfm` in `/foo/bar` and for `/bar/index.cfm` in `/foo` and invoke the first `index.cfm` it finds, which could be in both mappings. If this setting is set to `true`, Lucee will only check `/foo/bar` for `index.cfm`.

#### LUCEE_MVN_REPO_RELEASES

*SysProp:* `-Dlucee.mvn.repo.releases`
*EnvVar:* `LUCEE_MVN_REPO_RELEASES`

Endpoint used by Lucee >= 6 to load releases. By default, this is `https://oss.sonatype.org/service/local/repositories/releases/content/`.

#### LUCEE_MVN_REPO_SNAPSHOTS

*SysProp:* `-Dlucee.mvn.repo.snapshots`
*EnvVar:* `LUCEE_MVN_REPO_SNAPSHOTS`

Endpoint used by Lucee >= 6 to load snapshots. By default, this is `https://oss.sonatype.org/content/repositories/snapshots/`.

#### LUCEE_PAGEPOOL_MAXSIZE

*SysProp:* `-Dlucee.pagePool.maxSize`
*EnvVar:* `LUCEE_PAGEPOOL_MAXSIZE`

Max size of the template pool (page pool), the pool Lucee holds loaded `.cfm`/`.cfc` files. By default, this is `10000`; no number smaller than `1000` is accepted.

#### LUCEE_PRECISE_MATH

*SysProp:* `-Dlucee.precise.math`
*EnvVar:* `LUCEE_PRECISE_MATH`

A boolean value. If enabled, this improves the accuracy of floating-point calculations but makes them slightly slower.

#### LUCEE_PRESERVE_CASE

*SysProp:* `-Dlucee.preserve.case`
*EnvVar:* `LUCEE_PRESERVE_CASE`

A boolean value. If true, Lucee will not convert variable names used in "dot notation" to UPPER CASE.

#### LUCEE_QUEUE_ENABLE

*SysProp:* `-Dlucee.queue.enable`
*EnvVar:* `LUCEE_QUEUE_ENABLE`

A boolean value. If true, Lucee will enable the queue for requests.

#### LUCEE_QUEUE_MAX

*SysProp:* `-Dlucee.queue.max`
*EnvVar:* `LUCEE_QUEUE_MAX`

The maximum concurrent requests that the engine allows to run at the same time before the engine begins to queue the requests.

#### LUCEE_QUEUE_TIMEOUT

*SysProp:* `-Dlucee.queue.timeout`
*EnvVar:* `LUCEE_QUEUE_TIMEOUT`

The time in milliseconds a request is held in the queue. If the time is reached, the request is rejected with an exception. If you set it to 0 seconds, the request timeout is used instead.

#### LUCEE_REQUEST_LIMIT_CONCURRENT_MAXNOSLEEP

*SysProp:* `-Dlucee.request.limit.concurrent.maxnosleep`
*EnvVar:* `LUCEE_REQUEST_LIMIT_CONCURRENT_MAXNOSLEEP`

The maximal number of threads that are allowed to be active on the server. If this is reached, requests get forced into a "nap" (defined by `lucee.request.limit.concurrent.sleeptime`).

#### LUCEE_REQUEST_LIMIT_CONCURRENT_SLEEPTIME

*SysProp:* `-Dlucee.request.limit.concurrent.sleeptime`
*EnvVar:* `LUCEE_REQUEST_LIMIT_CONCURRENT_SLEEPTIME`

How long a request should "nap" in milliseconds if it reaches the `lucee.request.limit.concurrent.maxnosleep`.

#### LUCEE_REQUESTTIMEOUT_MEMORYTHRESHOLD

*SysProp:* `-Dlucee.requesttimeout.memorythreshold`
*EnvVar:* `LUCEE_REQUESTTIMEOUT_MEMORYTHRESHOLD`

A floating-point number between 0 and 1. Memory threshold to enforce a request timeout. If a request reaches the request timeout, Lucee will only enforce that timeout if this threshold is also reached. For example, setting it to `0.5` enforces the timeout if the memory consumption of the server is at least 50%.

#### LUCEE_RESOURCE_CHARSET

*SysProp:* `-Dlucee.resource.charset`
*EnvVar:* `LUCEE_RESOURCE_CHARSET`

Default character set for reading from/writing to various resources (files).

#### LUCEE_SCRIPT_PROTECT

*SysProp:* `-Dlucee.script.protect`
*EnvVar:* `LUCEE_SCRIPT_PROTECT`

Script protect setting used by default. Consult the Lucee admin page `/Settings/Request` for details on possible settings.

#### LUCEE_SECURITY_LIMITEVALUATION

*SysProp:* `-Dlucee.security.limitEvaluation`
*EnvVar:* `LUCEE_SECURITY_LIMITEVALUATION`

A boolean value. If enabled, limits variable evaluation in functions/tags. If enabled, you cannot use expressions within `[ ]` like this: `susi[getVariableName()]`. This affects the following functions: `IsDefined`, `structGet`, `empty` and the following tags: `savecontent attribute "variable"`.

This is enabled by default in Lucee 7.

#### LUCEE_SSL_CHECKSERVERIDENTITY

*SysProp:* `-Dlucee.ssl.checkserveridentity`
*EnvVar:* `LUCEE_SSL_CHECKSERVERIDENTITY`

A boolean value. If enabled, checks the identity of the SSL certificate with SMTP.

#### LUCEE_STATUS_CODE

*SysProp:* `-Dlucee.status.code`
*EnvVar:* `LUCEE_STATUS_CODE`

A boolean value. If disabled, returns a 200 status code to the client even if an uncaught exception occurs.

#### LUCEE_STORE_EMPTY

*SysProp:* `-Dlucee.store.empty`
*EnvVar:* `LUCEE.STORE.EMPTY`

A boolean value. If enabled, does not store empty sessions to the client or session storage.

#### LUCEE_SUPPRESS_WS_BEFORE_ARG

*SysProp:* `-Dlucee.suppress.ws.before.arg`
*EnvVar:* `LUCEE_SUPPRESS_WS_BEFORE_ARG`

A boolean value. If enabled, Lucee suppresses whitespace defined between the `cffunction` starting tag and the last `cfargument` tag. This setting is ignored when there is different output between these tags as whitespace.

#### LUCEE_SYSTEM_ERR

*SysProp:* `-Dlucee.system.err`
*EnvVar:* `LUCEE_SYSTEM_ERR`

Where is the error stream of the JVM sent? Possible values are:

- `null` (the stream is ignored)
- `class:` - the data is sent to an instance of that class that must implement the `java.io.PrintStream` interface
- `file:` - an absolute path to a file name the stream is written to
- `log` - stream is written to `err.log` in `context/logs/`

#### LUCEE_SYSTEM_OUT

*SysProp:* `-Dlucee.system.out`
*EnvVar:* `LUCEE_SYSTEM_OUT`

Where is the out stream of the JVM sent? Possible values are:

- `null` (the stream is ignored)
- `class:` - the data is sent to an instance of that class that must implement the `java.io.PrintStream` interface
- `file:` - an absolute path to a file name the stream is written to
- `log` - stream is written to `out.log` in `context/logs/`

#### LUCEE_TEMPLATE_CHARSET

*SysProp:* `-Dlucee.template.charset`
*EnvVar:* `LUCEE_TEMPLATE_CHARSET`

Default character set used to read templates (`.cfm` and `.cfc` files).

#### LUCEE_TYPE_CHECKING

*SysProp:* `-Dlucee.type.checking`
*EnvVar:* `LUCEE_TYPE_CHECKING`

A boolean value. If enabled, Lucee enforces types defined in the code. If false, type definitions are ignored.

#### LUCEE_UPLOAD_BLOCKLIST

*SysProp:* `-Dlucee.upload.blocklist`
*EnvVar:* `LUCEE_UPLOAD_BLOCKLIST`

Default block list for the tag `cffile action="upload"`. A comma-separated list of extensions that are allowed when uploading files via forms.

#### LUCEE_USE_LUCEE_SSL_TRUSTSTORE

*SysProp:* `-Dlucee.use.lucee.SSL.TrustStore`
*EnvVar:* `LUCEE_USE_LUCEE_SSL_TRUSTSTORE`

Specifies the file location of the trust store that contains trusted Certificate Authorities (CAs) for SSL/TLS connections in Java applications.

#### LUCEE_WEB_CHARSET

*SysProp:* `-Dlucee.web.charset`
*EnvVar:* `LUCEE_WEB_CHARSET`

Default character set for output streams, form, URL, and CGI scope variables, and reading/writing the header.
