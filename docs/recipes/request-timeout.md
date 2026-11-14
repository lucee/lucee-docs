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
    "server",
    "flow-control"
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

## Limitations

A request timeout can only stop the request thread at points where that thread can be interrupted. It is not meant to bound a single query, HTTP call, or other blocking operation.

Lucee enforces the timeout by interrupting the request thread. That works when the thread is in an interruptible Java wait, such as `sleep()`, `wait()`, or `join()`. It does not stop the thread when it is:

- blocked in network I/O that ignores interrupts, including most JDBC driver reads
- running native (JNI) code
- waiting to acquire some locks

In those cases the request can keep running until the underlying operation returns on its own, even though the request timeout has already been reached. The same is true of any long-running Java call that never returns to Lucee: the timeout is only observed once the thread can be interrupted or reaches a Lucee checkpoint.

### Modern Java

On earlier Java versions, Lucee could use `Thread.stop()` as a last resort to force a timed-out request to end. Since Java 20, `Thread.stop()` throws `UnsupportedOperationException` and is no longer available. Lucee therefore relies on `Thread.interrupt()`, which has the limitations above. This is a Java platform restriction, not a Lucee setting you can turn back on.

### Set a timeout on the operation

To bound a query or HTTP call, set a timeout on that operation itself.

Per query, in seconds:

```lucee
<cfquery datasource="myds" timeout="10">
    SELECT ...
</cfquery>
```

```luceescript
queryExecute("SELECT ...", {}, { datasource: "myds", timeout: 10 });
```

An application default for every query:

```luceescript
this.tag.cfquery.timeout = createTimeSpan(0, 0, 0, 10);
// this.tag.query.timeout works the same way
```

Alternatively, set `alwaysSetTimeout` on the datasource. When that flag is enabled, Lucee uses the remaining request timeout as the query timeout. It is off by default in Lucee and in `this.datasources`:

```luceescript
this.datasources["myds"] = {
    // ...
    alwaysSetTimeout: true
};
```

For HTTP, set a timeout on `cfhttp` / `http`. Lucee also caps `cfhttp` to the remaining request timeout; an explicit `timeout` is still the way to set a tighter bound. Other HTTP clients or raw socket calls are not cancelled automatically.
