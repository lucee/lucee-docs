<!--
{
  "title": "Logging HTTP Calls",
  "id": "logging-http-calls",
  "description": "This document explains how to log HTTP calls made by the cfhttp tag in Lucee.",
  "keywords": [
    "cfhttp",
    "logging",
    "http",
    "debugging",
    "application log",
    "http log"
  ],
  "related": [
    "tag-http",
    "logging"
  ],
  "categories": [
    "http",
    "logging"
  ]
}
-->

# Logging HTTP Calls

This document explains how Lucee automatically logs HTTP calls made with the `cfhttp` tag.

Lucee provides built-in logging for HTTP requests executed via the `cfhttp` tag or the `cfhttp` script equivalent. This can be extremely useful for debugging, monitoring, and performance analysis of external API calls in your application.

## How It Works

Whenever your application executes a `cfhttp` call, Lucee automatically creates a log entry with detailed information about the request, including:

- HTTP method used (GET, POST, etc.)
- URL that was requested
- Status code returned
- Execution time in milliseconds
- Whether the response was cached
- Call stack showing where the HTTP request originated from
- Any errors that occurred during the request

## Log Configuration

By default, HTTP call logging follows these rules:

1. If a log with the name "http" exists in your Lucee configuration, HTTP calls will be logged there
2. If no "http" log exists, calls will be logged to the standard "application" log instead

Using a separate "http" log is recommended for busy applications as it will be much less noisy than the general application log.

## Example Log Output

A typical log entry for an HTTP request looks like this:

```
httpRequest [GET] to [https://lucee.org?susi=sorglos], returned [200 OK] in 159ms, at /org/lucee/whatever/MyComponent.cfc.getUserByName():383; /org/lucee/whatever/MyComponent.cfc.getUser():683; /www/myapp/webroot/Application.cfc.onRequest():303
```

The entry includes:
- HTTP method: `GET`
- Requested URL: `https://lucee.org?susi=sorglos`
- Status code: `200 OK`
- Execution time: `159ms`
- Call stack: Shows exactly where in your code the HTTP request was triggered

## Setting Up an HTTP Log

To create a dedicated HTTP log for better visibility:


### Using the Lucee Administrator

1. Log in to the Lucee Administrator
2. Go to "Logging" section
3. Click "Create New Log"
4. Set the name to "http"
5. Choose your desired appender (resource/console)
6. Set the log level to "Info" for standard logging, or "Debug" for more verbose output
7. Save your configuration

## Performance Considerations

HTTP logging is designed to have minimal impact on application performance. However, in high-traffic applications with many external API calls, the volume of log entries can become significant.

Consider the following practices:
- Use a dedicated "http" log rather than the general application log
- In production, you may want to set the log level to "WARN" to only capture errors
- For detailed debugging, temporarily set the log level to "INFO" or "DEBUG"

## Conclusion

HTTP call logging is a powerful built-in feature in Lucee that helps developers monitor, debug, and optimize external API interactions. By setting up a dedicated HTTP log, you can easily track all outgoing HTTP requests made by your application, which is invaluable for troubleshooting integration issues or performance bottlenecks.