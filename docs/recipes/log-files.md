<!--
{
  "title": "Log Files",
  "id": "log-files",
  "description": "What each default Lucee log file contains, what writes to it, where it lives, and when to look at it, including out.log, err.log and felix.log",
  "keywords": [
    "Log files",
    "application.log",
    "exception.log",
    "datasource.log",
    "requesttimeout.log",
    "deploy.log",
    "scheduler.log",
    "out.log",
    "err.log",
    "felix.log",
    "troubleshooting"
  ],
  "related": [
    "logging",
    "console-logging",
    "tag-log",
    "function-writelog",
    "environment-variables-system-properties",
    "troubleshooting"
  ],
  "categories": [
    "server"
  ]
}
-->

# Log Files

Lucee writes a set of log files out of the box. This page lists them, says what writes to each one, and tells you when it is worth opening. To change levels, appenders or layouts, see the [[logging]] recipe.

## Where the Log Files Are

The default loggers are defined in the server configuration and the web contexts use them. Each one uses the `resource` appender with the `classic` layout and writes to:

```text
{lucee-server}/logs/<name>.log
```

In the server configuration the same path is written as `{lucee-config}/logs/<name>.log`. On disk this is the `context/logs` folder inside the `lucee-server` directory, for example `lucee-server/context/logs/application.log`. This folder is also where `cflog file="..."` writes (see [Your Own Logs](#your-own-logs)).

You can list them from CFML:

```cfml
files = directoryList( path=expandPath( "{lucee-server}/logs" ), listInfo="name", filter="*.log" );
dump( files );
```

The web administrator lists the server-defined loggers as read-only logs. They are edited in the server administrator or in `.CFConfig.json`.

## Log Levels and What You Will Actually See

Most default loggers are set to `error`, so a log file stays empty (or does not exist yet) until something goes wrong. `deploy` is the exception and is set to `info`. If a log is empty and you expected entries, check the level of that logger first. Lowering it to `info` or `debug` is the usual way to get more detail while troubleshooting.

## The Default Logs

| Log file | Default level | What writes to it | Look at it when |
|---|---|---|---|
| `application.log` | error | General runtime messages: errors in the engine and request handling that have no log of their own, and the fallback for `cflog` and `writeLog` calls that name no (or an unknown) log | You get an unexplained error or a misbehaving feature and do not know where to start |
| `exception.log` | error | Uncaught exceptions of a request (the ones that end in an error page), and exceptions thrown while a session or client scope ends. A missing include is logged as a warning | A request failed with an error page and you want the stack trace |
| `datasource.log` | error | Datasource and query handling, for example warnings when a query parameter cannot be cast to the SQL type you gave it (`cfqueryparam`), and failures releasing a datasource connection at the end of a request | Queries fail, parameters are converted unexpectedly, or connections misbehave |
| `requesttimeout.log` | error | Requests (and `cfthread`s) that exceed their timeout, with the stack trace of the stuck thread and the number of active requests at that moment, plus the outcome of Lucee's attempt to interrupt or stop that thread | A request is killed by a timeout and you need to know what it was doing. See also [[request-timeout]] |
| `thread.log` | error | Uncaught errors inside a `cfthread` (child thread) | A `cfthread` dies silently |
| `scheduler.log` | error | Scheduled tasks: starting, stopping and failing task threads | A scheduled task does not run or does not stop |
| `scope.log` | error | Session and client storage: loading, storing and cleaning up scope data, including datasource storage | Sessions or client data disappear, or storage in a datasource fails |
| `deploy.log` | info | Deployment work: installing, updating and removing extensions, loading their bundles, and importing configuration (`configImport`) | An extension does not install or load, or a configuration change did not apply |
| `rest.log` | error | REST services: errors while mapping and executing a REST request, and "not found" style responses | A REST mapping returns 404 or 500 and you need the reason |
| `http.log` | error | Outgoing `cfhttp` requests (method, URL, status code, duration, call stack) and HTTP resource errors | You need to see which outgoing calls an application makes. Raise the level to `info` to log every request, see [[logging-http-calls]] |
| `mapping.log` | error | Mappings, for example a physical path that cannot be resolved, and mappings that start or stop resolving | A mapping or its path does not work as expected |
| `gateway.log` | error | Event gateways (see [[event-gateways]]) | An event gateway does not start or fails to process messages |
| `remoteclient.log` | error | Spooled remote client tasks, logged as success (info) or failure (error) | Remote client tasks you spooled are not being executed |
| `orm.log` | error | ORM session handling, for example failures releasing the ORM session at the end of a request. The ORM extension writes to this log as well, see [[orm-logging]] | ORM sessions or mappings misbehave |
| `mail.log` | error | Mail sending and the mail spooler, for example SMTP authentication or connection failures | A mail is not delivered or stays in the spool |
| `search.log` | error | Collections, indexing and searching | Full text search or indexing fails |
| `memory.log` | error | Defined by default. Lucee core has no code that writes to it | Only if something you installed or wrote logs to it |
| `execute.log` | error | Defined by default. Lucee core has no code that writes to it | Only if something you installed or wrote logs to it |

`mail.log` and `search.log` are fed by the mail and search engines. They are listed because they are defined by default, but their content is decided by those components.

## Your Own Logs

Writing to a log that is not configured does not create a file:

- `cflog` and `writeLog` with a `log` attribute use the configured logger of that name. If there is none, the call falls back to the main logger, which is `application` unless you set the `lucee.logging.main` system property (or the `mainLogger` setting).
- `cflog file="mylog"` writes to `mylog.log` in the same logs folder as the default logs, without any configuration.
- A logger name that is not configured at all is created on demand as a console logger at level `error`, so what it writes goes to the console (with Tomcat that usually ends up in `catalina.out`). These loggers are not shown in the administrator.

```cfml
// goes to application.log if the level allows it
writeLog( text="Import finished", type="information", log="application" );

// goes to logs/import.log
cflog( file="import", text="Import finished", type="information" );
```

To define your own log with its own level, appender and layout, see [[logging]]. An application can also override a logger for itself with `this.logs` in `Application.cfc`, which takes precedence over the server-defined logger of the same name for requests of that application (see [[orm-logging]] for an example).

## Bootstrap Logs: out.log and err.log

`out.log` and `err.log` also live in `lucee-server/context/logs`, but they are not regular loggers and cannot be configured in the administrator. They are the logs of last resort, used when no logger is available yet. For example while Lucee is still starting and logging is not configured, or when loading the configuration fails.

- `err.log` receives messages of level `warn`, `error` and `fatal`.
- `out.log` receives messages of level `info`, `debug` and `trace`.
- Only messages at or above the level of the system property `lucee.system.log.level` (environment variable `LUCEE_SYSTEM_LOG_LEVEL`) are written. The default is `warn`, so by default only `err.log` gets entries. Set the property to `info` or lower to get `out.log` as well.

Look at `err.log` first when Lucee does not start, a context does not come up, or the administrator and the other logs are missing or empty. Because it works without any configuration, it is often the only place where such an error is recorded.

### Redirecting the JVM Output Into These Files

`out.log` and `err.log` are also what the `log` option refers to when you redirect the JVM's standard output and error streams. By default both streams stay on the console (`system`). They can be changed with the `systemOut` and `systemErr` settings in the server configuration, or with the system properties `lucee.system.out` and `lucee.system.err` (environment variables `LUCEE_SYSTEM_OUT` and `LUCEE_SYSTEM_ERR`):

| Value | Effect |
|---|---|
| `system` | Leave the stream on the console (default) |
| `log` | Write the stream to `out.log` or `err.log` in `context/logs` |
| `file:<path>` | Write the stream to the given file |
| `class:<class-name>` | Send the stream to an instance of that class, which must be a `java.io.PrintStream` |
| `null` | Discard the stream |

With `log`, anything printed to standard output or error, such as output from `systemOutput()` or a stack trace printed by a library, ends up in these files and no longer on the console. See [[console-logging]] and [[environment-variables-system-properties]].

## Startup Log: felix.log

`felix.log` is also written to `lucee-server/context/logs`. It is the log of the OSGi framework (Apache Felix) that Lucee uses to load its bundles and extensions, and it is written by the loader, before any Lucee logger is available.

- Only errors are recorded by default. The level can be changed with the system property `felix.log.level` (or the environment variable `FELIX_LOG_LEVEL`).
- The size is checked when Lucee starts: a `felix.log` larger than 100 MB is renamed to `felix.1.log` (replacing an older one), and one larger than 1 GB is simply deleted.

Look at it when an extension or bundle fails to load, or Lucee fails to start with an OSGi or class loading error.

## Troubleshooting Checklist

1. Start with `application.log` and `exception.log`.
2. If the problem matches a feature (query, thread, scheduled task, mail), open the log for that feature from the table above.
3. If a log is empty, check its level, then check the other logs.
4. If Lucee does not start, check `err.log` and `felix.log`, and the console output of the servlet container.
