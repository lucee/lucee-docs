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

### Available Properties

When configuring an ExecutionLog, you can specify the following arguments:

| Property | Description | Default |
|----------|-------------|---------|
| `min-time` | Minimum execution time to log (in ns, µs, ms, or s) | 0 |
| `unit` | Output time unit (`nano`, `micro`, or `milli`) | `nano` |

### ConsoleExecutionLog Arguments

| Property | Description | Default |
|----------|-------------|---------|
| `stream-type` | Output stream to use (`error` or `out`) | `out` |
| `snippet` | Include code snippet in output | `false` |

### ResourceExecutionLog Arguments

| Property | Description | Default |
|----------|-------------|---------|
| `directory` | Directory to store log files | Temp directory |

### LogExecutionLog Arguments

| Property | Description | Default |
|----------|-------------|---------|
| `log-level` | Log level (`trace`, `debug`, `info`, etc.) | `trace` |
| `log-name` | Logger name | `lucee.runtime.engine.Controler` |
| `snippet` | Include code snippet in output | `false` |

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

```
1234567890:C:/websites/myapp/index.cfm:45:72 > 123 ns
1234567890:C:/websites/myapp/index.cfm:75:120 > 789 ns
```

With `snippet` enabled:
```
1234567890:C:/websites/myapp/index.cfm:45:72 > 123 ns [<cfset result = myFunction(arg1, arg2)>]
```

### ResourceExecutionLog

Creates a structured log file with:
- HTTP request information
- Execution time summary
- Detailed path mappings
- Statement execution metrics

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

- Identifying performance bottlenecks within complex templates
- Profiling specific code blocks for optimization
- Debugging execution flow in complex applications
- Performance regression testing