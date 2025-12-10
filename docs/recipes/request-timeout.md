<!--
{
  "title": "Request Timeout",
  "id": "request-timeout",
  "description": "Learn how to use request timeout correctly with Lucee.",
  "keywords": [
    "request timeout",
    "timeout",
    "memory",
    "cpu",
    "Concurrent Requests",
    "Administrator",
    "Application.cfc",
    "cfsetting",
    "Threshold"
  ],
  "categories": [
    "server"
  ],
  "related":[
    "tag-timeout",
    "tag-setting",
    "tag-application",
    "timeout"
  ]
}
-->

# Request Timeout

Lucee allows you to define a request timeout for every request. **Never accept request timeouts as normal behavior** - always investigate and fix them.

## Configuration

### Lucee Administrator

Settings > Request

### Application.cfc

```luceescript
this.requestTimeout = createTimeSpan(0, 0, 0, 49);
```

### cfsetting tag

```lucee
<cfsetting requestTimeout="#createTimeSpan(0, 0, 0, 49)#">
```

Or in script:

```luceescript
setting requesttimeout=60; // seconds as integer
```

## Thresholds

Lucee has additional thresholds that requests must meet before being terminated. These help prevent unnecessary termination, which can cause deadlocks and open monitors. If a timeout is reached but thresholds aren't met, Lucee logs to the "requesttimeout" log instead of terminating.

### Concurrent Requests

How many concurrent requests Lucee handles before enforcing timeouts. A higher threshold lets more requests process without timeout enforcement - useful under heavy load, but risks longer request times. Default: 0 (enforce immediately).

```sh
-Dlucee.requesttimeout.concurrentrequestthreshold=100
```

or the Environment Variable:

```sh
LUCEE_REQUESTTIMEOUT_CONCURRENTREQUESTTHRESHOLD=100
```

### CPU Usage

Set a CPU usage threshold before enforcing timeouts. Value is 0.0 (0%) to 1.0 (100%). When CPU is below this threshold, requests process without timeout enforcement - helps maintain responsiveness during high demand. Default: 0.0 (always enforce regardless of CPU).

```sh
-Dlucee.requesttimeout.cputhreshold=0.9
```

or the Environment Variable:

```sh
LUCEE_REQUESTTIMEOUT_CPUTHRESHOLD=0.9
```

### Memory Usage

Set a memory usage threshold before enforcing timeouts. Value is 0.0 (0%) to 1.0 (100%). When memory is below this threshold, requests process without timeout enforcement - prevents system overloads and maintains stable performance. Default: 0.0 (always enforce regardless of memory).

```sh
-Dlucee.requesttimeout.memorythreshold=0.8
```

or the Environment Variable:

```sh
LUCEE_REQUESTTIMEOUT_MEMORYTHRESHOLD=0.8
```
