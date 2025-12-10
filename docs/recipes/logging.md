<!--
{
  "title": "Logging",
  "id": "logging",
  "description": "How to configure and customize logging",
  "keywords": [
    "Logging",
    "Log levels",
    "Lucee"
  ],
  "related": [
    "tag-log",
    "function-writelog"
  ],
  "categories": [
    "server"
  ]
}
-->

# Logging

Logging helps you monitor errors, track events, and troubleshoot your applications. Lucee's logging system is built on Log4j2, giving you flexible control over what gets logged, where it goes, and how it's formatted.

You can configure log levels to control verbosity, choose appenders to direct output (console, files, databases, or custom destinations like Kafka), and select layouts to format the output.

## Log Levels

In decreasing order of severity:

- **fatal**: Severe errors causing premature termination.
- **error**: Runtime errors or unexpected conditions that require attention.
- **warn**/**warning**: Undesirable or unexpected situations that don’t necessarily indicate errors.
- **info**/**information** (default): General runtime events, useful for tracking the flow of execution.
- **debug**: Detailed information helpful for debugging issues.
- **trace**: The most detailed information for fine-grained troubleshooting.

### Log Level Thresholds

Configure minimum log level per logger in **Lucee Administrator** or `.CFConfig.json`. Setting threshold to `warn` records only warnings, errors, and fatal - ignoring `info`, `debug`, and `trace`.

### Redirecting Logs to Console

Since Lucee 6.2, override log levels and appender via environment variables:

```bash
LUCEE_LOGGING_FORCE_LEVEL=info
LUCEE_LOGGING_FORCE_APPENDER=console
```

### Adding or Modifying Logs

Configure in **Lucee Administrator** or `.CFConfig.json`:

```json
"loggers": {
    "datasource": {
      "appender": "resource",
      "appenderArguments": {
        "path": "{lucee-config}/logs/datasource.log"
      },
      "level": "error",
      "layout": "classic"
    },
    "myapp": {
      "appender": "resource",
      "appenderArguments": {
        "path": "/www/logs/lucee-web/deploy.log"
      },
      "layout": "json",
      "layoutArguments": {
        "compact": true,
        "properties": false,
        "stacktraceAsString": true,
        "envnames": "APP,ENV,PURPOSE,MACHINE_NAME"
      },
      "level": "info"
    }
}
```

### Internals: Log4j2

Powered by **Log4j2** - extend with any Log4j2 Appender or Layout.

## Appenders and Layouts

### Built-in Appenders

- **console**: Output to console
- **datasource**: Store in database table
- **resource**: Write to virtual filesystem (local, S3, FTP, etc.)

### Built-in Layouts

- **classic**: Traditional CFML-compatible output
- **datadog**: Datadog ingestion format
- **html**: HTML format for browser debugging
- **json**: Structured JSON (uses Log4j2's JSONAppender)
- **pattern**: Custom patterns
- **xml**: Structured XML

## Custom Appenders and Layouts

Extend with third-party libraries:

### Custom Appender Configuration

```json
"appenderClass": "<custom-appender-class-name>",
"appenderBundleName": "<custom-appender-osgi-bundle-name>",
"appenderBundleVersion": "<custom-appender-osgi-bundle-version>"
```

### Custom Layout Configuration

```json
"layoutClass": "<custom-layout-class-name>",
"layoutBundleName": "<custom-layout-osgi-bundle-name>",
"layoutBundleVersion": "<custom-layout-osgi-bundle-version>"
```

### Example: Custom Logging to Kafka

```json
"loggers": {
    "kafkaLogger": {
        "appenderClass": "org.apache.kafka.log4j.KafkaAppender",
        "appenderBundleName": "org.apache.kafka",
        "appenderBundleVersion": "2.8.0",
        "appenderArguments": {
            "topic": "application-logs",
            "bootstrap.servers": "kafka-broker:9092"
        },
        "layoutClass": "org.apache.logging.log4j.core.layout.PatternLayout",
        "layoutBundleName": "org.apache.logging.log4j",
        "layoutBundleVersion": "2.13.3",
        "layoutArguments": {
            "pattern": "%d{yyyy-MM-dd HH:mm:ss} [%t] %-5level %logger{36} - %msg%n"
        },
        "level": "info"
    }
}
```

Sends logs to a Kafka topic with custom pattern layout.

## Using `<cflog>`

### Tag Syntax

```html
<cflog log="application" type="warn" text="Warning: Something went wrong!">
```

### Script Syntax

```javascript
log log="application" type="warn" text="Warning: Something went wrong!";
```

### Function Syntax

```javascript
try {
  throw "Warning: Something went wrong!"
}
catch(e) {
  cflog(log="application", type="error", exception=e);
}
```

Note: Due to the existing math `log` function, the `cf` prefix is required here unlike other tags in script.
