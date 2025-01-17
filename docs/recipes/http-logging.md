<!--
{
  "title": "Logging CFHTTP Calls",
  "id": "logging-cfhttp-calls",
  "since": "6.1.0.135",
  "description": "Learn how Lucee logs all CFHTTP calls and how to manage these logs. This guide explains the default behavior, log file locations, and changes in logging from earlier Lucee versions.",
  "keywords": [
    "cfhttp",
    "logging",
    "Lucee",
    "log level",
    "http log"
  ],
  "related": [
    "tag-http"
  ]
}
-->

# Logging CFHTTP Calls

As of Lucee 6.1.0.135, all `cfhttp` calls are logged by default to a dedicated `http` log file at the log level `info`. This logging behavior provides more visibility into HTTP requests made through Lucee applications, helping to track external requests easily.

## Default Logging Behavior

In the default setup, Lucee logs HTTP requests with the following settings:

- **Log File**: `http.log` (If the `http.log` log does not exist, entries are directed to `application.log`).
- **Log Level**: `info`.

### Example Log Entry

An example entry for a `cfhttp` call might look like this:

```plaintext
"TRACE","pool-3-thread-2","10/29/2024","18:31:04","cftrace","httpRequest [GET] to [https://lucee.org], returned [200 OK] in 294ms, at /index.cfm:10; /index.cfm.callLucee():20"
```

This log entry includes:

- **Request Details**: Method (`GET`), URL (`https://lucee.org`)
- **Response Status**: `[200 OK]`
- **Response Time**: `294ms`
- **Source Location**: Code locations responsible for the request.

## Changes in Logging Behavior (Pre-Lucee 6.1.0.135)

In earlier versions of Lucee, before version 6.1.0.135:

- **Log File**: Only `application.log` was used for logging HTTP requests.
- **Log Level**: `trace` instead of `info`.

The change to a dedicated `http` log and `info` level helps separate HTTP logs from other system logs, improving clarity.