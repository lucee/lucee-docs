<!--
{
  "title": "ExecutionLog",
  "id": "execution_log",
  "since": "4.2",
  "categories": ["debugging"],
  "description": "Log details about code execution at the statement level",
  "keywords": [
    "executionlog",
    "debug",
    "performance",
    "profiling"
  ]
}
-->

# ExecutionLog

## Introduction

ExecutionLog in Lucee provides detailed information about the execution time of individual code expressions and statements. Unlike standard debugging which only captures template execution times, ExecutionLog tracks execution at a much more granular level, allowing you to identify performance bottlenecks within your code.

When enabled, Lucee injects bytecode into the runtime-compiled CFML to track and log performance metrics. Lucee will recompile all CFML code when this feature is first enabled.

## Configuration

ExecutionLog can be enabled and configured in `.CFConfig.json` or through the Lucee Administrator.

### Basic Configuration

```json
{
  "executionLog": {
    "enabled": true,
    "class": "lucee.runtime.engine.ConsoleExecutionLog"
  }
}
```

### Configuration with Arguments

```json
{
  "executionLog": {
    "enabled": true,
    "class": "lucee.runtime.engine.ResourceExecutionLog",
    "arguments": {
      "min-time": "500ns",
      "unit": "micro",
      "directory": "/var/log/lucee/executionlogs"
    }
  }
}
```

### Console Example with Snippet Enabled

```json
{
  "executionLog": {
    "enabled": true,
    "class": "lucee.runtime.engine.ConsoleExecutionLog",
    "arguments": {
      "min-time": "2ms",
      "unit": "milli",
      "stream-type": "out",
      "snippet": true
    }
  }
}
```

### Available Implementations

Lucee includes several built-in implementations:

- **lucee.runtime.engine.ConsoleExecutionLog**: Outputs directly to the console
- **lucee.runtime.engine.DebugExecutionLog**: Adds data to the Lucee debug output
- **lucee.runtime.engine.ResourceExecutionLog**: Writes logs to a file resource
- **lucee.runtime.engine.LogExecutionLog**: Writes to Lucee's logging system

You can use the following shortcuts for common implementations:

- `"console"` for `lucee.runtime.engine.ConsoleExecutionLog`
- `"debug"` for `lucee.runtime.engine.DebugExecutionLog`

### Custom Implementations

You can create your own ExecutionLog implementation by creating a class that implements the `lucee.runtime.engine.ExecutionLog` interface:

```java
package lucee.runtime.engine;

import java.util.Map;
import lucee.runtime.PageContext;

public interface ExecutionLog {
    public void init(PageContext pc, Map<String, String> arguments);
    public void release();
    public void start(int pos, String id);
    public void end(int pos, String id);
}
```

### Including External Classes

Similar to other Lucee class definitions, you can specify:

1. **OSGi Bundles**: Use `bundleName` and `bundleVersion`

```json
{
  "executionLog": {
    "enabled": true,
    "class": "com.mycompany.MyExecutionLog",
    "bundleName": "com.mycompany.logger",
    "bundleVersion": "1.0.0"
  }
}
```   

2. **Maven Dependencies** (since Lucee 6.2):

```json
{
  "executionLog": {
    "enabled": true,
    "class": "com.mycompany.MyExecutionLog",
    "maven": "org.myorg:mylogger:1.0.0,org.myorg:utils:1.2.0"
  }
}
```   

3. **CFML Components** (Lucee 7+):

```json
{
  "executionLog": {
    "enabled": true,
    "component": "path.to.MyExecutionLogComponent"
  }
}
```  

   The component must implement `lucee.runtime.engine.ExecutionLog` via `implementsJava="lucee.runtime.engine.ExecutionLog"`.

## Implementation Details

When creating custom implementations, you can focus on the specific logging functionality while leveraging Lucee's timing and threshold capabilities through the provided interface.

### Common Arguments

When configuring any ExecutionLog implementation, you can specify these arguments:

| Property | Description | Default | Example Values |
|----------|-------------|---------|---------------|
| `min-time` | Minimum execution time threshold for logging. Only statements taking longer than this threshold will be logged. Can be specified with time unit suffixes. | 0 | `"500ns"`, `"10µs"`, `"5ms"`, `"0.1s"` |
| `unit` | The time unit to use in log output. Affects readability based on your performance targets. | `nano` | `"nano"` (nanoseconds), `"micro"` (microseconds), `"milli"` (milliseconds) |

### ConsoleExecutionLog Arguments

| Property | Description | Default | Notes |
|----------|-------------|---------|-------|
| `stream-type` | Determines whether to output to standard out or standard error. Use `error` to separate log output from regular application output. | `out` | `"out"` or `"error"` |
| `snippet` | When enabled, captures and displays the actual CFML code being executed. Extremely useful for identifying exactly which code is causing performance issues, especially in complex templates with many expressions. | `false` | Set to `true` to see the actual code being executed |

### ResourceExecutionLog Arguments

| Property | Description | Default | Notes |
|----------|-------------|---------|-------|
| `directory` | Specifies where log files should be stored. If not provided, Lucee will use a temp directory. For persistent logs, specify an absolute path. Lucee's virtual filesystem support means you can write to various destinations (S3, HTTP, etc.). | Lucee temp directory | `"/var/logs/lucee"`, `"s3://my-bucket/logs"` |

### LogExecutionLog Arguments

| Property | Description | Default | Notes |
|----------|-------------|---------|-------|
| `log-level` | Sets the severity level for log entries. Controls visibility in consolidated logs and allows filtering when reviewing. | `trace` | `"trace"`, `"debug"`, `"info"`, `"warn"`, `"error"` |
| `log-name` | Customizes the logger name for better organization and filtering in consolidated logs. | `lucee.runtime.engine.Controler` | `"execution"`, `"performance"`, `"myapp.performance"` |
| `snippet` | When enabled, captures and displays the actual CFML code being executed alongside timing information. Particularly valuable when analyzing logs after execution. | `false` | Set to `true` to include source code in logs |

### Example Log Implementation Configuration

```json
{
  "executionLog": {
    "enabled": true,
    "class": "lucee.runtime.engine.LogExecutionLog",
    "arguments": {
      "min-time": "100ms",
      "unit": "milli",
      "log-level": "info",
      "log-name": "execution",
      "snippet": true
    }
  }
}
```

## Example Output

### ConsoleExecutionLog

Without snippets:

```
1234567890:C:/websites/myapp/index.cfm:45:72 > 123 ns
1234567890:C:/websites/myapp/index.cfm:75:120 > 789 ns
```

With `snippet` enabled (shows the actual code being executed):

```
1234567890:C:/websites/myapp/index.cfm:45:72 > 123 ns [<cfset result = myFunction(arg1, arg2)>]
```

In this example:

- `1234567890` is the request ID
- `C:/websites/myapp/index.cfm` is the template path
- `45:72` represents the start and end position of the code in the template
- `123 ns` is the execution time
- `[<cfset result = myFunction(arg1, arg2)>]` is the actual code snippet (when enabled)

### ResourceExecutionLog

Creates a structured log file with multiple sections:

1. **Header Information**:

```
context-path:/myapp
remote-user:
remote-addr:127.0.0.1
remote-host:localhost
script-name:/myapp/index.cfm
server-name:localhost
protocol:HTTP/1.1
server-port:8888
path-info:
query-string:
unit:ms
min-time-nano:1000000
execution-time:5462
```

2. **Path Mappings**:

```
0:/myapp/index.cfm
1:/myapp/components/service.cfc
```

3. **Execution Metrics**:

```
0   45   72   12
0   75   120   2
1   128   170   56
```

Each line in the execution metrics contains:

- Template index (from path mappings)
- Start position
- End position
- Execution time (in the configured unit)

## Performance Considerations

ExecutionLog has a significant performance impact and should only be enabled in development or debugging scenarios:

1. All CFML code must be recompiled when ExecutionLog is first enabled
2. Every statement execution incurs overhead for timing and logging
3. Log data collection and storage requires additional resources

## Best Practices

1. Use the `min-time` parameter to filter out fast-executing statements
2. Enable ExecutionLog only when actively debugging performance issues
3. Consider using `ResourceExecutionLog` for post-execution analysis
4. When using custom implementations, thoroughly test for performance impact

## Use Cases

### Performance Optimization

- **Identifying Hotspots**: Find the most time-consuming statements in your application
- **Function Analysis**: Determine which function calls or methods consume disproportionate resources
- **Query Performance**: Track the execution time of database queries embedded in your code
- **Component Analysis**: Compare different components or services in your application architecture

### Debugging

- **Execution Flow Analysis**: Understand the order and timing of code execution
- **Slow Request Investigation**: Troubleshoot specific slow requests in production environments
- **Cache Effectiveness**: Verify if caching strategies are working as expected
- **Performance Regression Testing**: Monitor for degradation when making code changes

### Development Guidance

- **Code Refactoring**: Identify candidates for optimization or refactoring
- **Best Practice Enforcement**: Detect patterns that violate performance best practices
- **Developer Education**: Help team members understand performance implications of their code

### Real-World Example

Consider a Lucee application that begins experiencing intermittent slowdowns. By enabling ExecutionLog with snippets, you might discover:

```
1234567890:C:/websites/myapp/services/userService.cfc:245:270 > 1250 ms [<cfset user = entityLoad("User", {email=arguments.email})>]
```

This immediately shows that a particular ORM entityLoad operation is taking over a second to execute, pinpointing the exact line of code causing the performance issue.