<!--
{
  "title": "Java Flight Recorder (JFR) Support",
  "id": "jfr_support",
  "since": "7.0",
  "categories": ["debugging", "performance"],
  "description": "Emit custom JFR events from Lucee for low-overhead production profiling",
  "keywords": [
    "jfr",
    "flight recorder",
    "profiling",
    "performance",
    "monitoring",
    "production",
    "observability"
  ],
  "related": [
    "execution_log",
    "tag-trace",
    "tag-timer",
    "function-gettickcount",
    "function-jfravailable",
    "function-jfrenabled",
    "function-jfremit",
    "function-jfrbegin",
    "function-jfrcommit",
    "function-jfrstartrecording",
    "function-jfrstoprecording",
    "function-jfranalyze"
  ]
}
-->

# Java Flight Recorder (JFR) Support

## Introduction

Java Flight Recorder (JFR) is a low-overhead profiling and diagnostics framework built into the JDK (11+). Unlike traditional profiling tools, JFR has minimal performance impact (typically <1%) making it suitable for continuous use in production environments.

**Useful JFR Resources:**

- [JDK Flight Recorder Guide](https://docs.oracle.com/en/java/java-components/jdk-mission-control/8/user-guide/using-jdk-flight-recorder.html) - Official Oracle documentation
- [Flight Recorder API Programmer's Guide](https://docs.oracle.com/en/java/javase/11/jfapi/creating-and-recording-your-first-event.html) - Creating custom JFR events in Java
- [JFR Event Streaming](https://inside.java/2020/10/08/jfr-event-streaming/) - Real-time event processing (JDK 14+)
- [JDK Mission Control](https://www.oracle.com/java/technologies/javase/products-jmc8-downloads.html) - Visual JFR analysis tool
- [OpenJDK JEP 328](https://openjdk.org/jeps/328) - Flight Recorder specification and implementation details
- [Using JFR to Monitor Applications](https://bell-sw.com/announcements/2021/04/09/using-java-flight-recorder-to-monitor-applications/) - Practical monitoring guide
- [JFR Command Reference](https://docs.oracle.com/en/java/javase/21/docs/specs/man/jfr.html) - Command-line tool documentation

Lucee 7.0+ adds native support for emitting custom JFR events from your CFML code, allowing you to:

- Track business-critical operations alongside JVM metrics
- Correlate application behavior with system performance
- Create custom duration and instant events
- Analyze recordings with standard JFR tools (JDK Mission Control, etc.)

## Quick Start

### Emitting Events

```cfml
// Instant event - marks a point in time
jfrEmit("business", "Order Processed", {
    orderId: 12345,
    amount: 99.99,
    customerId: 456
});

// Duration event - measures time
var eventId = jfrBegin("database", "Complex Query", {
    table: "orders",
    filters: "status=pending"
});

// ... perform operation ...

jfrCommit(eventId, {
    rowCount: 250,
    cached: false
});
```

### Using Tags

```cfml
// Add JFR events to cftrace
<cftrace
    type="Information"
    category="business"
    text="Processing payment"
    jfr="true">

// Measure execution time with cftimer
<cftimer label="Heavy Operation" jfr="true">
    <!--- Your code here --->
</cftimer>
```

## Starting a Recording

JFR recordings can be started in several ways:

### 1. Programmatically (BIF)

```cfml
// Start recording
recordingId = jfrStartRecording({
    name: "Production Monitoring",
    maxAge: 3600,      // Keep last hour of data
    dumpOnExit: true
});

// Emit your events
jfrEmit("app", "User Login", { userId: 123 });

// Stop and save
jfrStopRecording(recordingId, "/var/logs/myapp.jfr");
```

### 2. JVM Startup Arguments

```bash
java -XX:StartFlightRecording=filename=recording.jfr,duration=60s,settings=profile \
     -jar lucee.jar
```

### 3. External Tools (jcmd)

```bash
# Start recording
jcmd <pid> JFR.start name=myrecording

# Stop and save
jcmd <pid> JFR.stop name=myrecording filename=recording.jfr
```

## Available BIFs

### jfrAvailable()

Returns `true` if JFR is available in the current JVM (JDK 11+) and the internal JDK modules are exported/open and available to Lucee.

```cfml
if (jfrAvailable()) {
    // JFR functionality available
}
```

### jfrEnabled()

Returns `true` if JFR is available AND at least one recording is active.

```cfml
if (jfrEnabled()) {
    jfrEmit("app", "Feature Used");
}
```

### jfrEmit(category, label [, data])

Emits an instant event (point in time).

**Arguments:**
- `category` (string, required): Event category for grouping
- `label` (string, required): Event name/description
- `data` (struct, optional): Additional event data (JSON serialized)

```cfml
// Simple event
jfrEmit("business", "Order Submitted");

// Event with data
jfrEmit("cache", "Cache Miss", {
    key: "user:123",
    reason: "expired"
});
```

### jfrBegin(category, label [, data])

Starts a duration event. Returns an event ID.

**Arguments:**
- `category` (string, required): Event category
- `label` (string, required): Event name
- `data` (struct, optional): Initial event data

**Returns:** String (event ID)

```cfml
var eventId = jfrBegin("api", "External API Call", {
    endpoint: "https://api.example.com/users",
    method: "GET"
});
```

### jfrCommit(eventId [, data])

Completes a duration event started with `jfrBegin()`.

**Arguments:**
- `eventId` (string, required): Event ID from `jfrBegin()`
- `data` (struct, optional): Additional/final event data

```cfml
try {
    var eventId = jfrBegin("payment", "Process Payment");
    // ... payment processing ...
    jfrCommit(eventId, { success: true, amount: 99.99 });
}
catch (any e) {
    jfrCommit(eventId, { success: false, error: e.message });
}
```

### jfrStartRecording([options])

Starts a new JFR recording programmatically.

**Arguments:**
- `options` (struct, optional): Recording configuration
  - `name` (string): Recording name
  - `maxAge` (numeric): Max age in seconds
  - `maxSize` (numeric): Max size in bytes
  - `dumpOnExit` (boolean): Dump on JVM exit

**Returns:** Numeric (recording ID)

```cfml
recordingId = jfrStartRecording({
    name: "Request Analysis",
    maxAge: 600,
    dumpOnExit: false
});
```

### jfrStopRecording(recordingId [, destination])

Stops an active recording and optionally saves it.

**Arguments:**
- `recordingId` (numeric, required): Recording ID from `jfrStartRecording()`
- `destination` (string, optional): File path to save recording

**Returns:** String (confirmation message or file path)

```cfml
jfrStopRecording(recordingId, "/var/logs/recording.jfr");
```

### jfrAnalyze(jfrFile [, returnType, options])

Analyzes a JFR recording file and extracts events.

**Arguments:**
- `jfrFile` (string, required): Path to .jfr file
- `returnType` (string, optional): "array" (default) or "query"
- `options` (struct, optional): Filtering and output options
  - `eventTypes` (string/array): Filter by event type names
  - `category` (string/array): Filter by categories
  - `startTime` (datetime): Only events after this time
  - `endTime` (datetime): Only events before this time
  - `minDuration` (numeric): Minimum duration in milliseconds
  - `maxDuration` (numeric): Maximum duration in milliseconds
  - `includeStackTraces` (boolean): Include stack traces (default: false)
  - `maxEvents` (numeric): Limit results
  - `sortBy` (string): Sort by "duration", "startTime", or "eventType"
  - `sortOrder` (string): "asc" or "desc"
  - `fields` (string/array): Specific fields to include

**Returns:** Array of structs or Query

```cfml
// Simple analysis
events = jfrAnalyze("/var/logs/recording.jfr");

// Filter and sort
events = jfrAnalyze("/var/logs/recording.jfr", "array", {
    eventTypes: "lucee.runtime.jfr.CustomEvent",
    minDuration: 100,
    sortBy: "duration",
    sortOrder: "desc",
    maxEvents: 50
});

// As query for easy output
qry = jfrAnalyze("/var/logs/recording.jfr", "query", {
    category: ["business", "payment"]
});
```

## Tag Enhancements

### cftrace with JFR

Add `jfr="true"` to emit trace information as JFR events:

```cfml
<cftrace
    type="Information"
    category="business"
    text="Processing order #order.id#"
    var="order"
    jfr="true">
```

This creates a JFR event with:
- Event type, category, and text
- Template path and line number
- Variable name and value (if specified)

### cftimer with JFR

Add `jfr="true"` to emit timer duration as a JFR event:

```cfml
<cftimer label="Database Query" jfr="true">
    <cfquery name="qOrders">
        SELECT * FROM orders WHERE status = 'pending'
    </cfquery>
</cftimer>
```

This creates a JFR duration event with:
- Timer label
- Execution duration
- Success/failure status
- Template path and line number

**Note:** The timer will emit JFR events even if exceptions occur (using try/catch/finally internally).

## Use Cases

### Production Monitoring

Track key business metrics with minimal overhead:

```cfml
function processPayment(amount, customerId) {
    var eventId = jfrBegin("payment", "Process Payment", {
        amount: amount,
        customerId: customerId
    });

    try {
        // Payment processing logic
        var result = paymentGateway.charge(amount);

        jfrCommit(eventId, {
            success: true,
            transactionId: result.id,
            processingTime: result.time
        });

        return result;
    }
    catch (any e) {
        jfrCommit(eventId, {
            success: false,
            error: e.message,
            errorType: e.type
        });
        rethrow;
    }
}
```

### Performance Analysis

Identify slow operations:

```cfml
// During request
var eventId = jfrBegin("cache", "Redis Get");
var data = redisClient.get(key);
jfrCommit(eventId, { hit: !isNull(data) });

// Later, analyze recording
events = jfrAnalyze("production.jfr", "array", {
    category: "cache",
    minDuration: 50,  // Slower than 50ms
    sortBy: "duration",
    sortOrder: "desc"
});

// Find cache operations > 50ms
for (event in events) {
    writeOutput("Slow cache operation: #event.duration#ms<br>");
}
```

### Request Correlation

Link application events with JVM metrics:

```cfml
// At request start
var requestId = createUUID();
request.jfrEventId = jfrBegin("http", "Request", {
    requestId: requestId,
    method: cgi.request_method,
    path: cgi.script_name,
    remoteAddr: cgi.remote_addr
});

// At request end
jfrCommit(request.jfrEventId, {
    statusCode: request.statusCode ?: 200,
    responseTime: getTickCount() - request.startTime
});
```

### A/B Testing Metrics

Track feature usage in production:

```cfml
function showFeature() {
    var variant = request.abTest.variant; // "A" or "B"

    jfrEmit("feature", "Feature Shown", {
        featureName: "new_checkout",
        variant: variant,
        userId: session.userId
    });
}

// Analyze later
events = jfrAnalyze("production.jfr", "query", {
    eventTypes: "lucee.runtime.jfr.CustomEvent",
    category: "feature"
});

// Group by variant
cfquery(name="variantCounts" dbtype="query") {
    writeOutput("
        SELECT JSON_VALUE(fields, '$.variant') as variant,
               COUNT(*) as count
        FROM events
        GROUP BY JSON_VALUE(fields, '$.variant')
    ");
}
```

## Analyzing Recordings

### Using jfrAnalyze() BIF

```cfml
// Get all Lucee custom events
events = jfrAnalyze("recording.jfr", "array", {
    eventTypes: "lucee.runtime.jfr.CustomEvent"
});

// Find slow operations
slowOps = jfrAnalyze("recording.jfr", "array", {
    minDuration: 1000,  // > 1 second
    sortBy: "duration",
    sortOrder: "desc",
    maxEvents: 10
});

// Time range analysis
eventsInRange = jfrAnalyze("recording.jfr", "array", {
    startTime: dateAdd("h", -1, now()),
    endTime: now()
});
```

### Using JDK Mission Control

1. Open JDK Mission Control
2. Load your .jfr file
3. Navigate to "Event Browser"
4. Look for "Lucee" category to find custom events
5. View event details, stack traces, and correlate with JVM metrics

### Using jfr Command Line

```bash
# Print all Lucee events
jfr print --events lucee.runtime.jfr.CustomEvent recording.jfr

# Summary of event types
jfr summary recording.jfr

# Convert to JSON for processing
jfr print --json recording.jfr > events.json
```

## Performance Impact

JFR is designed for production use with minimal overhead:

- **Disabled (no recording)**: No performance impact
- **Recording enabled**: Typically <1% overhead
- **With stack traces**: ~2% overhead
- **Events only emitted if recording active**: Your `jfrEmit()` calls have near-zero cost when no recording is running

**Best Practices:**
- Check `jfrEnabled()` before emitting high-frequency events
- Use categories to filter events during analysis
- Limit stack trace collection to when needed
- Use `maxAge` to prevent unbounded recording growth

## Comparison with ExecutionLog

| Feature | JFR | ExecutionLog |
|---------|-----|--------------|
| **Overhead** | <1% | 10-50% |
| **Production Safe** | ✅ Yes | ❌ No |
| **Custom Events** | ✅ Yes | ❌ No |
| **JVM Metrics** | ✅ Yes | ❌ No |
| **Granularity** | Custom | Every statement |
| **Standard Tools** | ✅ Yes | ❌ No |
| **Use Case** | Production monitoring | Deep development debugging |

## Examples

### Complete Monitoring Example

```cfml
component {
    function onRequestStart() {
        // Start recording if needed
        if (jfrAvailable() && !jfrEnabled()) {
            application.recordingId = jfrStartRecording({
                name: "Production",
                maxAge: 3600,
                dumpOnExit: true
            });
        }

        // Track request
        request.jfrRequestId = jfrBegin("http", "Request", {
            method: cgi.request_method,
            path: cgi.script_name,
            userAgent: cgi.http_user_agent
        });
    }

    function onRequestEnd() {
        if (structKeyExists(request, "jfrRequestId")) {
            jfrCommit(request.jfrRequestId, {
                statusCode: request.statusCode ?: 200,
                userAuthenticated: structKeyExists(session, "userId")
            });
        }
    }

    function onError(exception) {
        jfrEmit("error", "Unhandled Exception", {
            type: exception.type,
            message: exception.message,
            template: exception.tagContext[1].template,
            line: exception.tagContext[1].line
        });
    }
}
```

### Database Query Tracking

```cfml
function queryWithTracking(sql, params={}) {
    var eventId = jfrBegin("database", "Query", {
        sql: left(sql, 100)  // First 100 chars
    });

    var startTime = getTickCount();

    try {
        var qry = queryExecute(sql, params);

        jfrCommit(eventId, {
            rowCount: qry.recordCount,
            cached: qry.cached,
            executionTime: getTickCount() - startTime
        });

        return qry;
    }
    catch (any e) {
        jfrCommit(eventId, {
            error: e.message,
            executionTime: getTickCount() - startTime
        });
        rethrow;
    }
}
```

## Troubleshooting

### JFR Not Available

```cfml
if (!jfrAvailable()) {
    // Running on JDK 8 or JFR classes not accessible
    // JFR requires JDK 11+
}
```

### No Events in Recording

1. Ensure a recording is active: `jfrEnabled()` returns `true`
2. Check event categories match your analysis filters
3. Verify events were emitted during the recording period
4. Check recording `maxAge` hasn't expired events

### High Memory Usage

- Reduce `maxAge` to limit recording buffer
- Filter events by category during recording
- Use `maxSize` to cap recording size
- Disable stack traces if not needed

## Additional Resources

- [JDK Flight Recorder Official Docs](https://docs.oracle.com/javacomponents/jmc-5-4/jfr-runtime-guide/)
- [JDK Mission Control](https://www.oracle.com/java/technologies/jdk-mission-control.html)
- [JFR Event Streaming](https://inside.java/2020/10/08/jfr-event-streaming/)
