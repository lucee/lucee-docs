A structure that contains log definitions.

- **appender (string):** Type of log appender (e.g., `resource`, `console`, `file`).
- **appenderArguments (struct):** Arguments for the appender, such as the log file path.
- **appender-arguments (struct or string):** Alternative key for appender arguments (used in some configurations).
- **level (string):** Log level (e.g., `info`, `debug`, `warn`, `error`).
- **layout (string):** Log layout format (e.g., `pattern`, `classic`).
- **layoutArguments (struct):** Arguments for the layout, such as a custom pattern.
- **name (string):** Optional name for the log (used for identification).

```cfc
 // Example configuration in Application.cfc
this.logs = {
    "exc_log": {
        appender: "resource",
        appenderArguments: {
        path: "{lucee-config}/logs/exc_log"
        },
        level: "info",
        layout: "pattern",
        layoutArguments: {
        pattern: "%d{yyyy-MM-dd HH:mm:ss,SSS} [%t] %-5p %c - %m%n"
        }
    }
};
```