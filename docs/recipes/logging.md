<!--
{
  "title": "Logging",
  "id": "logging",
  "description": "",
  "keywords": [
    "Logging",
    "Log levels",
    "Lucee"
  ]
}
-->

# Logging in Lucee

Lucee's logging system is a powerful and flexible framework designed to provide insights into your application’s behavior. By configuring logs, you can monitor errors, track events, and troubleshoot efficiently.

## Why Logging?

Logging is an essential practice for maintaining reliable and performant applications. It allows you to:
- Monitor runtime behavior and identify issues.
- Gain insights into application usage and performance.
- Maintain an audit trail of events and actions.

Lucee supports various log types (or levels), enabling you to control the verbosity and focus of your logs. Additionally, you can configure logging destinations and formats to integrate seamlessly with your infrastructure.

## How to Use Log Levels?

Log levels (or types) categorize log entries based on their importance or severity. Lucee supports the following log levels in decreasing order of severity:

- **fatal**: Severe errors causing premature termination.
- **error**: Runtime errors or unexpected conditions that require attention.
- **warn**/**warning**: Undesirable or unexpected situations that don’t necessarily indicate errors.
- **info**/**information** (default): General runtime events, useful for tracking the flow of execution.
- **debug**: Detailed information helpful for debugging issues.
- **trace**: The most detailed information for fine-grained troubleshooting.

### Configuring Log Level Thresholds

You can configure the minimum log level (threshold) for each logger in the **Lucee Administrator** or directly in the configuration file (`.CFConfig.json`). For instance, setting a threshold of `warn` means only warnings, errors, and fatal logs are recorded, ignoring `info`, `debug`, and `trace` logs.

This allows you to start with minimal logging in production and increase verbosity (e.g., to `debug`) for deeper analysis when needed.

### Adding or Modifying Logs

You can add, modify, or remove loggers in the **Lucee Administrator** or directly edit the `.CFConfig.json` file. Below is an example configuration:

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

### Internals: Powered by Log4j2

Lucee's logging system is powered by **Log4j2**, providing robust support for appenders and layouts. You can extend Lucee logging by using any appender or layout supported by Log4j2.

---

## Built-in Support for Appenders and Layouts

### Built-in Appenders

Lucee comes with built-in support for the following appenders:

- **console**: Logs output to the console, ideal for debugging in development or server environments.
- **datasource**: Logs to a database table, allowing structured storage and querying of log data.
- **resource**: Logs to a virtual filesystem endpoint, which can include local filesystems or external systems like **S3**, FTP, etc.

### Built-in Layouts

Lucee also provides the following layouts for customizing log output:

- **classic**: Produces traditional CFML-compatible output.
- **datadog**: Formats logs for direct ingestion into **Datadog**.
- **html**: Outputs logs in an HTML format suitable for browser-based debugging.
- **json**: Generates logs in structured JSON format.
- **pattern**: Allows custom patterns for maximum flexibility.
- **xml**: Outputs logs in structured XML format.

---

## Extending Logging with Custom Appenders and Layouts

In addition to the built-in appenders and layouts, Lucee supports custom configurations using third-party libraries. 
You can use OSGi based libraries or classic java libraries (Maven support will follow soon). 
Here’s how you can define custom appenders and layouts:

### Custom Appender Configuration

```json
"appenderClass": "<custom-appender-class-name>",
"appenderBundleName": "<custom-appender-osgi-bundle-name>", // only needed for OSGi based libraries
"appenderBundleVersion": "<custom-appender-osgi-bundle-version>" // only needed for OSGi based libraries
```

### Custom Layout Configuration

```json
"layoutClass": "<custom-layout-class-name>",
"layoutBundleName": "<custom-layout-osgi-bundle-name>", // only needed for OSGi based libraries
"layoutBundleVersion": "<custom-layout-osgi-bundle-version>" // only needed for OSGi based libraries
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

This configuration sends logs to a Kafka topic with a custom pattern layout.

---

Lucee’s extensible logging framework offers flexibility for integrating with diverse infrastructures, enhancing monitoring, debugging, and auditing capabilities. By leveraging built-in features and custom configurations, you can adapt the logging system to your application's unique needs.
