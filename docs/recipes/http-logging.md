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

All `cfhttp` calls are logged by default to a dedicated `http` log file at `info` level (falls back to `application.log` if `http.log` doesn't exist).

### Example Log Entry

```plaintext
"TRACE","pool-3-thread-2","10/29/2024","18:31:04","cftrace","httpRequest [GET] to [https://lucee.org], returned [200 OK] in 294ms, at /index.cfm:10; /index.cfm.callLucee():20"
```

Includes method, URL, response status, time, and source location.

## Pre-6.1.0.135 Behavior

Earlier versions logged to `application.log` at `trace` level instead.