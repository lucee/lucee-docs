<!--
{
  "title": "Thread Dump During Startup",
  "id": "thread-dump-startup",
  "since": "6.2",
  "categories": ["debugging", "monitoring", "performance"],
  "description": "How to capture thread positions during Lucee startup for debugging and performance analysis",
  "keywords": [
    "threads",
    "debugging",
    "startup",
    "performance",
    "monitoring",
    "stack traces"
  ]
}
-->

# Thread Dump During Startup

Lucee provides a built-in mechanism to capture thread stack traces during startup, which is invaluable for debugging startup performance issues, identifying bottlenecks, and understanding what processes are running during Lucee's initialization phase.

This feature automatically dumps thread positions to a JSON Lines file at configurable intervals during startup, allowing developers to analyze the startup sequence and identify potential issues.

## Configuration

The thread dump functionality is controlled through environment variables or system properties. Lucee automatically looks for these settings when it starts up.

### Environment Variables

Set the following environment variables to enable thread dumping:

```bash
export LUCEE_DUMP_THREADS=/path/to/startup.jsonl
export LUCEE_DUMP_THREADS_MAX=8000
export LUCEE_DUMP_THREADS_INTERVAL=100
```

### System Properties

Alternatively, you can use Java system properties:

```bash
-Dlucee.dump.threads=/path/to/startup.jsonl
-Dlucee.dump.threads.max=8000
-Dlucee.dump.threads.interval=100
```

### Configuration Parameters

- **`LUCEE_DUMP_THREADS`** / **`lucee.dump.threads`**: The file path where thread dump data will be written (required to enable the feature)
- **`LUCEE_DUMP_THREADS_MAX`** / **`lucee.dump.threads.max`**: Maximum duration in milliseconds to capture thread dumps (default: 10000ms)
- **`LUCEE_DUMP_THREADS_INTERVAL`** / **`lucee.dump.threads.interval`**: Interval in milliseconds between captures (default: 100ms, set to 0 for continuous capturing)

## Output Format

The thread dump creates a JSON Lines file where each line represents a snapshot of all active threads at a specific moment. Each record contains:

```json
{
  "stack": [
    "com.example.Class.method():123",
    "com.example.Parent.parentMethod():456"
  ],
  "thread": "main",
  "id": 1,
  "time": 1693123456789
}
```

### Field Descriptions

- **`stack`**: Array of stack trace elements in the format `ClassName.methodName():lineNumber`
- **`thread`**: Name of the thread
- **`id`**: Unique thread ID
- **`time`**: Timestamp when the snapshot was captured (Unix timestamp in milliseconds)

## Usage Examples

### Basic Startup Analysis

Capture thread dumps for the first 5 seconds of startup with 50ms intervals:

```bash
export LUCEE_DUMP_THREADS=/var/log/lucee/startup-analysis.jsonl
export LUCEE_DUMP_THREADS_MAX=5000
export LUCEE_DUMP_THREADS_INTERVAL=50
```

### High-Resolution Debugging

For detailed analysis of startup bottlenecks, capture as frequently as possible:

```bash
export LUCEE_DUMP_THREADS=/tmp/lucee-debug.jsonl
export LUCEE_DUMP_THREADS_MAX=3000
export LUCEE_DUMP_THREADS_INTERVAL=0
```

### Long-Term Monitoring

Monitor startup over a longer period with less frequent captures:

```bash
export LUCEE_DUMP_THREADS=/var/log/lucee/startup-monitor.jsonl
export LUCEE_DUMP_THREADS_MAX=15000
export LUCEE_DUMP_THREADS_INTERVAL=250
```

## Analyzing the Output

### Using Command Line Tools

You can analyze the JSON Lines output using various command-line tools:

```bash
# Count total thread snapshots
wc -l startup.jsonl

# Find the most active threads
grep -o '"thread":"[^"]*"' startup.jsonl | sort | uniq -c | sort -nr

# Extract timestamps to analyze timing
grep -o '"time":[0-9]*' startup.jsonl | cut -d: -f2
```

### Programmatic Analysis

#### Using CFML

You can analyze thread dump files directly within Lucee using CFML:

```javascript
function analyzeThreadDump(path, threadName) {
    echo("<pre style=""font-size: 0.7em;"">");
    threadNames = [:];
    var max = 15;  // Maximum stack trace depth to display
    var start = 0;
    
    loop file=path item="local.line" {
        var sct = deserializeJSON(line);
        threadNames[sct.thread] = "";
        
        // Filter by specific thread name if provided
        if(!findNoCase(threadName, sct.thread)) continue;
        
        // Calculate relative time from start
        if(start == 0) start = sct.time;
        echo(sct.time - start);
        
        // Display stack trace
        loop array=sct.stack index="local.i" item="local.v" {
            echo(" > " & sct.thread & ": " & v);
            if(i == max) break;  // Limit stack depth for readability
        }
        echo("
");
    }
    echo("</pre>");
    
    // Show all available thread names
    dump(threadNames.keyArray());
}

// Usage examples:
// analyzeThreadDump("/path/to/startup.jsonl", "main");
// analyzeThreadDump("/path/to/startup.jsonl", "thread-36");
// analyzeThreadDump("/path/to/startup.jsonl", "on-start-");
```

This function provides:

- **Thread filtering**: Focus on specific threads by name (case-insensitive partial matching)
- **Relative timing**: Shows elapsed time from the first captured snapshot
- **Stack trace limiting**: Displays only the top stack frames for better readability
- **Thread discovery**: Lists all available thread names in the dump file

#### Using Other Languages

Load and analyze the data in your preferred programming language:

```javascript
// Example: Reading with JavaScript/Node.js
const fs = require('fs');
const lines = fs.readFileSync('startup.jsonl', 'utf8').split('\n');
const snapshots = lines.filter(line => line.trim()).map(line => JSON.parse(line));

// Analyze thread activity
const threadActivity = {};
snapshots.forEach(snapshot => {
    threadActivity[snapshot.thread] = (threadActivity[snapshot.thread] || 0) + 1;
});

console.log('Thread activity:', threadActivity);
```

## Common Use Cases

### Identifying Startup Bottlenecks

Look for threads that appear frequently in the same stack trace positions, which may indicate slow operations:

```bash
# Find repeated stack traces
grep -o '"stack":\[[^]]*\]' startup.jsonl | sort | uniq -c | sort -nr | head -20
```

### Monitoring Resource Initialization

Track when specific components initialize by filtering for relevant class names:

```bash
# Find database-related initialization
grep -i "database\|datasource\|connection" startup.jsonl
```

### Performance Regression Analysis

Compare thread dumps between different Lucee versions or configurations to identify performance changes.

## Best Practices

### File Management

- Use descriptive file names with timestamps to avoid overwriting previous captures
- Ensure sufficient disk space, as high-frequency captures can generate large files
- Consider log rotation for production environments

### Performance Impact

- Thread dumping has minimal performance impact but avoid extremely high frequencies (interval=0) in production
- The feature automatically stops after the specified maximum duration to prevent indefinite resource usage

### Security Considerations

- Thread dumps may contain sensitive information from stack traces
- Restrict access to dump files appropriately
- Consider the implications of capturing thread data in shared hosting environments

## Troubleshooting

### Feature Not Working

If thread dumps aren't being generated:

1. Verify the environment variables are set correctly
2. Ensure the target directory exists and is writable
3. Check Lucee startup logs for any error messages
4. Confirm that Lucee has sufficient permissions to write to the specified path

### Large File Sizes

If dump files become too large:

- Increase the interval between captures
- Reduce the maximum capture duration
- Use file rotation or cleanup scripts

### Missing Data

If expected threads aren't appearing:

- Verify the timing (some threads may be short-lived)
- Check if the maximum duration is sufficient for your analysis needs
- Consider adjusting the capture interval

## Related Features

This thread dump functionality complements other Lucee monitoring and debugging features:

- **Lucee Administrator**: Real-time thread monitoring
- **Performance Monitor**: Application-level performance tracking
- **Exception Handling**: AI-powered error analysis
- **Logging**: Standard application and error logging

The startup thread dump feature provides low-level insight into Lucee's initialization process, making it an essential tool for advanced debugging and performance optimization scenarios.