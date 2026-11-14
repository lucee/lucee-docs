<!--
{
  "title": "Hooks and Monitors",
  "id": "hooks-monitors",
  "since": "5.3",
  "categories": ["extensions", "configuration"],
  "description": "Configure and use hooks and monitors to extend Lucee functionality at various lifecycle points",
  "keywords": [
    "hooks",
    "monitors",
    "startup",
    "extension",
    "lifecycle",
    "injection"
  ]
}
-->

# Hooks and Monitors

Two extension mechanisms for custom functionality: **Hooks** run at lifecycle points (startup), **Monitors** collect runtime metrics (requests, actions, intervals).

## AI-Optimized Technical Reference

For developers using AI assistance or requiring structured technical data, see the companion specification:
**[Hooks](https://github.com/lucee/lucee-docs/blob/master/docs/technical-specs/hooks.yaml)**
**[Monitors](https://github.com/lucee/lucee-docs/blob/master/docs/technical-specs/monitors.yaml)**

# Hooks

Hooks allow you to inject custom classes that execute at specific points during Lucee's lifecycle. The primary hook type is the startup hook, which runs during Lucee initialization.

## Startup Hooks

Startup hooks are executed when Lucee starts up, allowing you to perform initialization tasks, configure services, or set up integrations before your applications begin processing requests. They are ideal for:

- Database connection pool initialization
- External service integration setup
- Custom service registration
- WebSocket endpoint registration
- Configuration validation and setup
- Resource pre-loading

### Configuration

Startup hooks can be configured in multiple ways depending on your use case and deployment strategy.

**Configuration via .CFConfig.json:**

You can define startup hooks directly in your `.CFConfig.json` configuration file. This method is ideal for application-specific hooks.

```json
{
  "startupHooks": [
    {
      "class": "com.mycompany.hooks.DatabaseInitializer"
    }
  ]
}
```

**OSGi-based Hook Example:**

```json
{
  "startupHooks": [
    {
      "class": "com.mycompany.hooks.DatabaseInitializer",
      "bundleName": "my-database-initializer",
      "bundleVersion": "1.0.0"
    }
  ]
}
```

**Maven-based Hook Example:**

```json
{
  "startupHooks": [
    {
      "class": "com.example.monitoring.PerformanceHook",
      "maven": "com.example:performance-monitor:2.1.0"
    }
  ]
}
```

**Component-based Hook Example (Lucee 7 only):**

```json
{
  "startupHooks": [
    {
      "component": "hooks.ApplicationInitializer"
    }
  ]
}
```

### Implementation

**Java Class Implementation:**

When implementing a startup hook as a Java class, you have two constructor options:

```java
package com.mycompany.hooks;

import lucee.runtime.config.Config;
import lucee.runtime.config.ConfigServer;
import lucee.runtime.config.ConfigWeb;
import lucee.loader.engine.CFMLEngine;
import lucee.loader.engine.CFMLEngineFactory;

public class MyStartupHook {
    private final ConfigServer configServer;
    private final CFMLEngine engine;
    private static MyStartupHook instance = null;
    private boolean alive = true;
    
    public MyStartupHook(Config config) {
        try {
            this.configServer = (ConfigServer) config;
            this.engine = CFMLEngineFactory.getInstance();
            
            // Initialize services
            initializeServices();
            
            // Set singleton instance for access from other parts of the application
            instance = this;
            
        } catch (RuntimeException re) {
            System.err.println("Failed to initialize MyStartupHook: " + re.getMessage());
            throw re;
        }
    }
    
    private void initializeServices() {
        // Initialize for all web contexts
        for (ConfigWeb cw : configServer.getConfigWebs()) {
            try {
                if (cw != null && cw.getServletContext() != null) {
                    initializeWebContext(cw);
                }
            } catch (Exception e) {
                System.err.println("Error initializing web context " + 
                                 cw.getIdentification().getId() + ": " + e.getMessage());
            }
        }
    }
    
    private void initializeWebContext(ConfigWeb config) {
        System.out.println("Initializing services for web context: " + 
                          config.getIdentification().getId());
        // Your web-context specific initialization
    }
    
    public static MyStartupHook getInstance() throws Exception {
        if (instance == null) {
            throw new Exception("MyStartupHook failed to initialize within the Lucee engine");
        }
        return instance;
    }
    
    public boolean isAlive() {
        return alive;
    }
    
    public void finalize() {
        alive = false;
        System.out.println("MyStartupHook finalizing...");
    }
}
```

**CFML Component Implementation:**

You can also implement hooks as CFML components:

```javascript
// hooks/ApplicationInitializer.cfc
component {
    public function init() {
        // Initialization logic
        writeOutput("Application hook initialized at " & now());
        
        // Example: Set up application-wide variables
        application.startupTime = now();
        application.hookVersion = "1.0.0";
        
        return this;
    }

    public boolean function isAlive() {
       return true;
    }
    
    public void function finalize() {
    }
}
```

### Use Cases

**WebSocket Endpoint Registration:**

```java
public class WebSocketHook {
    private boolean isEndpointRegistered = false;
    private final Object registrationLock = new Object();
    
    public WebSocketHook(Config config) {
        this.configServer = (ConfigServer) config;
        registerWebSocketEndpoints();
    }
    
    private void registerWebSocketEndpoints() {
        for (ConfigWeb cw : configServer.getConfigWebs()) {
            try {
                if (cw != null && cw.getServletContext() != null) {
                    registerEndpointForContext(cw);
                }
            } catch (Exception e) {
                System.err.println("Failed to register WebSocket endpoint: " + e.getMessage());
            }
        }
    }
    
    private void registerEndpointForContext(ConfigWeb cw) throws Exception {
        if (!isEndpointRegistered) {
            synchronized (registrationLock) {
                if (!isEndpointRegistered) {
                    Object serverContainer = cw.getServletContext()
                        .getAttribute("jakarta.websocket.server.ServerContainer");
                    
                    if (serverContainer != null) {
                        ((jakarta.websocket.server.ServerContainer) serverContainer)
                            .addEndpoint(MyWebSocketEndpoint.class);
                        isEndpointRegistered = true;
                        System.out.println("WebSocket endpoint registered successfully");
                    }
                }
            }
        }
    }
}
```

### Deployment via Extension

Extensions can declare startup hooks in their `META-INF/MANIFEST.MF` file:

```manifest
Manifest-Version: 1.0
Built-Date: 2025-08-18 22:53:56
version: "3.0.0.17"
id: "3F9DFF32-B555-449D-B0EB5DB723044045"
name: WebSockets Extension
description: Websocket integration into Lucee.
start-bundles: true
release-type: server
startup-hook: "{'class':'org.lucee.extension.websocket.WebSocketEndpointFactory','name':'org.lucee.websocket.extension','version':'3.0.0.17'}"
lucee-core-version: "5.3.0.20"
```

# Monitors

Monitors provide continuous observation and data collection about Lucee's runtime behavior. Unlike startup hooks that run once during initialization, monitors are invoked throughout the application lifecycle to track performance metrics, system health, and operational data.

Monitoring is only active when enabled in configuration:

```json
{
  "monitoring": {
    "enabled": true
  }
}
```

Monitors can be configured in two ways:

1. **Via Extension Manifest** - Packaged with extensions for reusable monitoring functionality
2. **Via .CFConfig.json** - Direct configuration for application-specific monitoring

### Configuration via .CFConfig.json

You can define monitors directly in your `.CFConfig.json` configuration file under the `monitoring` section:

```json
{
  "monitoring": {
    "enabled": true,
    "monitor": [
      {
        "name": "MyActionMonitor",
        "type": "action",
        "class": "com.mycompany.monitors.ActionMonitorImpl",
        "bundleName": "my.monitor.bundle",
        "bundleVersion": "1.0.0",
        "log": true,
        "async": false
      },
      {
        "name": "MyRequestMonitor", 
        "type": "request",
        "class": "com.mycompany.monitors.RequestMonitorImpl",
        "maven": "com.mycompany:monitor-lib:2.1.0",
        "log": true,
        "async": true
      },
      {
        "name": "MyIntervalMonitor",
        "type": "interval",
        "class": "com.mycompany.monitors.IntervalMonitorImpl",
        "maven": "com.mycompany:monitor-lib:2.1.0",
        "log": true
      }
    ]
  }
}
```

**Configuration Properties:**

- `name`: Unique identifier for the monitor (required)
- `type`: Monitor type - `action`, `request`, or `interval` (required)
- `class`: Full Java class name (required)
- `bundleName`: OSGi bundle name (optional, for OSGi resolution)
- `bundleVersion`: OSGi bundle version (optional, for OSGi resolution)
- `maven`: Maven coordinates in format `groupId:artifactId:version` (alternative to OSGi)
- `log`: Enable/disable logging for this monitor (optional, default: true)
- `async`: Run request monitors asynchronously (optional, request monitors only, default: false)

**Class Definition Resolution Order:**

1. **Maven Dependency** - If `maven` is provided
2. **OSGi Bundle** - If `bundleName` is provided
3. **Standard Classpath** - Fallback for simple class loading

This page documents monitors implemented as Java classes. The `component` option that exists for other class definitions is not documented or tested for monitors.

There are three types of monitors, each serving different monitoring needs:

## Action Monitors

Action monitors track specific operations within Lucee as they occur, such as database queries, lock operations, mail sending, and cache operations. They are called synchronously during the execution of these operations.

### Interface Implementation

```java
package com.mycompany.monitors;

import java.io.IOException;
import java.util.Map;
import lucee.runtime.PageContext;
import lucee.runtime.config.ConfigServer;
import lucee.runtime.config.ConfigWeb;
import lucee.runtime.exp.PageException;
import lucee.runtime.monitor.ActionMonitor;
import lucee.runtime.type.Query;

public class MyActionMonitor implements ActionMonitor {

    private String name;
    private boolean logEnabled;
    
    @Override
    public void log(PageContext pc, String type, String label, long executionTime, Object data) throws IOException {
        // Log action within a request context
        System.out.println("Action: " + type + " | Label: " + label + 
                          " | Time: " + executionTime + "ms | Data: " + data);
        
        // Examples of what Lucee logs:
        // type="query", label="Query", data=queryResult
        // type="lock", label="Lock", data="lockName:timeoutInMillis"  
        // type="cache", label="Cache", data=cacheOperation
        // type="mail", label="Mail", data=mailProperties
    }
    
    @Override
    public void log(ConfigWeb config, String type, String label, long executionTime, Object data) throws IOException {
        // Log action outside of request context (e.g., scheduled tasks, mail sending)
        System.out.println("Background Action: " + type + " | Label: " + label + 
                          " | Time: " + executionTime + "ms");
    }
    
    @Override
    public Query getData(Map<String, Object> arguments) throws PageException {
        // Return collected action data as a query for reporting
        // Filter by arguments like date range, type, etc.
        return createActionDataQuery(arguments);
    }
    
    private Query createActionDataQuery(Map<String, Object> arguments) throws PageException {
        // Implementation to return your collected data
        // Columns typically include: timestamp, type, label, executionTime, details
        return null; // Implement based on your storage mechanism
    }
    
    // Base Monitor interface methods
    @Override
    public void init(ConfigServer configServer, String name, boolean logEnabled) {
        this.name = name;
        this.logEnabled = logEnabled;
    }

    @Override
    public short getType() {
        return TYPE_ACTION;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public Class getClazz() {
        return getClass();
    }

    @Override
    public boolean isLogEnabled() {
        return logEnabled;
    }
}
```

### Use Cases

Action monitors are ideal for:

- Database query performance tracking
- Lock contention analysis
- Mail delivery monitoring
- Cache hit/miss ratio tracking
- Custom operation timing

## Request Monitors

Request monitors are called for each HTTP request processed by Lucee. A request monitor can be called at two points of a request:

- **Start of the request**: if the class declares a public `init(PageContext pc)` method, it is called before the Application listener (`Application.cfc`) runs. The monitor can inspect the request and can [abort it](#aborting-a-request-from-a-request-monitor).
- **End of the request**: `log(PageContext pc, boolean error)` is called when the request has finished, for successful and for failed requests.

`init(PageContext)` is optional and is not part of the `RequestMonitor` interface. Lucee looks the method up by name on the monitor class, so it must be declared on the class itself (not inherited) and be `public`. The class must also implement `RequestMonitor` directly, a plain object that is wrapped by Lucee does not get the request start call.

### Interface Implementation

```java
package com.mycompany.monitors;

import java.io.IOException;
import java.util.Map;
import lucee.runtime.PageContext;
import lucee.runtime.config.ConfigServer;
import lucee.runtime.config.ConfigWeb;
import lucee.runtime.exp.PageException;
import lucee.runtime.monitor.RequestMonitor;
import lucee.runtime.type.Query;

public class MyRequestMonitor implements RequestMonitor {

    private String name;
    private boolean logEnabled;

    // optional, called at the start of the request
    public void init(PageContext pc) throws IOException, PageException {
        System.out.println("Request started: " + pc.getHttpServletRequest().getRequestURI());
    }

    @Override
    public void log(PageContext pc, boolean error) throws IOException {
        // Called at the end of each request
        long requestTime = System.currentTimeMillis() - pc.getStartTime();
        String requestURI = pc.getHttpServletRequest().getRequestURI();

        System.out.println("Request: " + requestURI +
                          " | Time: " + requestTime + "ms" +
                          " | Error: " + error);

        // Collect additional request metrics:
        // - Memory usage during request
        // - User agent, IP address
        // - Response size
        // - Custom application metrics
    }

    @Override
    public Query getData(ConfigWeb config, Map<String, Object> arguments) throws PageException {
        // Return request data for the specific web context
        // Filter by arguments like date range, error status, etc.
        return createRequestDataQuery(config, arguments);
    }

    private Query createRequestDataQuery(ConfigWeb config, Map<String, Object> arguments) throws PageException {
        // Implementation to return collected request data
        // Columns typically include: timestamp, uri, executionTime, error, userAgent, etc.
        return null; // Implement based on your storage mechanism
    }

    // Base Monitor interface methods
    @Override
    public void init(ConfigServer configServer, String name, boolean logEnabled) {
        this.name = name;
        this.logEnabled = logEnabled;
    }

    @Override
    public short getType() {
        return TYPE_REQUEST;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public Class getClazz() {
        return getClass();
    }

    @Override
    public boolean isLogEnabled() {
        return logEnabled;
    }
}
```

The monitor is only called when `isLogEnabled()` returns true, which is the `log` setting of the monitor (default `true`).

### Aborting a Request from a Request Monitor

A request monitor can stop a request before any of your code runs. If `init(PageContext)` throws a `lucee.runtime.exp.Abort` with the scope `Abort.SCOPE_REQUEST`, Lucee aborts the request the same way an `abort` in `onRequestStart` does: `Application.cfc` and the requested template are not executed and `onError` is not called. The monitor decides what the client receives, it sets the status code and writes the response before it throws.

```java
package com.mycompany.monitors;

import java.io.IOException;
import java.util.Map;
import java.util.Set;
import lucee.runtime.PageContext;
import lucee.runtime.config.ConfigServer;
import lucee.runtime.config.ConfigWeb;
import lucee.runtime.exp.Abort;
import lucee.runtime.exp.PageException;
import lucee.runtime.monitor.RequestMonitor;
import lucee.runtime.type.Query;

public class BlockingRequestMonitor implements RequestMonitor {

    private static final Set<String> BLOCKED = Set.of("203.0.113.7", "203.0.113.8");

    private String name;
    private boolean logEnabled;

    public void init(PageContext pc) throws IOException, PageException {
        if (!BLOCKED.contains(pc.getHttpServletRequest().getRemoteAddr())) return;

        pc.getHttpServletResponse().setStatus(403);
        pc.write("Forbidden");
        throw new Abort(Abort.SCOPE_REQUEST);
    }

    @Override
    public void log(PageContext pc, boolean error) throws IOException {
    }

    @Override
    public Query getData(ConfigWeb config, Map<String, Object> arguments) throws PageException {
        return null;
    }

    @Override
    public void init(ConfigServer configServer, String name, boolean logEnabled) {
        this.name = name;
        this.logEnabled = logEnabled;
    }

    @Override
    public short getType() {
        return TYPE_REQUEST;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public Class getClazz() {
        return getClass();
    }

    @Override
    public boolean isLogEnabled() {
        return logEnabled;
    }
}
```

Notes on aborting:

- Only a silent abort stops the request. Any other exception thrown from `init(PageContext)` is handled as before and does not stop the request.
- Monitors are called in the order they are configured. After a monitor has aborted the request, the `init(PageContext)` of the monitors that follow it is not called.
- An asynchronous monitor (`"async": true`) runs in its own thread and never blocks the request, it cannot abort a request. Do not set `async` on a monitor that blocks requests.
- Monitoring must be enabled (`monitoring.enabled`), otherwise no request monitor is called at all.
- Aborting from `init(PageContext)` is available in Lucee 7.1 (see [LDEV-3792](https://luceeserver.atlassian.net/browse/LDEV-3792) for the exact version). In earlier versions an exception thrown from `init(PageContext)` is swallowed and the request continues.

Register the monitor like any other request monitor, for example in `.CFConfig.json`:

```json
{
  "monitoring": {
    "enabled": true,
    "monitor": [
      {
        "name": "BlockingRequestMonitor",
        "type": "request",
        "class": "com.mycompany.monitors.BlockingRequestMonitor",
        "maven": "com.mycompany:monitor-lib:2.1.0"
      }
    ]
  }
}
```

### Use Cases

Request monitors are ideal for:

- Application performance monitoring (APM)
- Error rate tracking
- User behavior analysis
- Load pattern identification
- Security monitoring
- Blocking unwanted requests before the application sees them (rate limiting, IP block lists)

## Interval Monitors

Interval monitors collect system and application metrics at regular intervals (every 5000ms by default). They run independently of user requests and are perfect for system health monitoring.

### Interface Implementation

```java
package com.mycompany.monitors;

import java.io.IOException;
import java.util.Map;
import lucee.runtime.config.ConfigServer;
import lucee.runtime.exp.PageException;
import lucee.runtime.monitor.IntervallMonitor;
import lucee.runtime.type.Query;

public class MyIntervalMonitor implements IntervallMonitor {

    private String name;
    private boolean logEnabled;
    
    @Override
    public void log() throws IOException {
        // Called every 5000ms (configurable)
        Runtime runtime = Runtime.getRuntime();
        long totalMemory = runtime.totalMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = totalMemory - freeMemory;
        
        System.out.println("System Stats - Used Memory: " + (usedMemory / 1024 / 1024) + "MB" +
                          " | Free Memory: " + (freeMemory / 1024 / 1024) + "MB" +
                          " | Total Memory: " + (totalMemory / 1024 / 1024) + "MB");
        
        // Collect additional metrics:
        // - CPU usage
        // - Thread counts  
        // - Database connection pool status
        // - Cache statistics
        // - Custom application metrics
    }
    
    @Override
    public Query getData(Map<String, Object> arguments) throws PageException {
        // Return interval data collected over time
        // Filter by arguments like date range, metric type, etc.
        return createIntervalDataQuery(arguments);
    }
    
    private Query createIntervalDataQuery(Map<String, Object> arguments) throws PageException {
        // Implementation to return collected interval data
        // Columns typically include: timestamp, memoryUsed, memoryFree, cpuUsage, etc.
        return null; // Implement based on your storage mechanism
    }
    
    // Base Monitor interface methods
    @Override
    public void init(ConfigServer configServer, String name, boolean logEnabled) {
        this.name = name;
        this.logEnabled = logEnabled;
    }

    @Override
    public short getType() {
        return TYPE_INTERVAL;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public Class getClazz() {
        return getClass();
    }

    @Override
    public boolean isLogEnabled() {
        return logEnabled;
    }
}
```

### Use Cases

Interval monitors are ideal for:

- System resource monitoring
- Memory leak detection
- Performance baseline establishment
- Capacity planning data
- Health check implementations

## Deployment via Extension

Extensions can declare all three monitor types in their `META-INF/MANIFEST.MF` file:

```manifest
Manifest-Version: 1.0
Built-Date: 2022-03-22 11:46:12
version: "1.0.0.176"
id: "58110B5E-E7CB-47AF-8E80D70DDD80C46F"
name: "Argus Monitor"
description: "Argus Monitor is a tool to show the current state of your system."
start-bundles: false
category: "Monitor"
author: "Michael Offner"
release-type: server
monitor: "[{'name':'ArgusMonitorActionMonitor','type':'action','class':'ch.rasia.extension.argus.monitor.ActionMonitorImpl','bundleName':'argus.monitor','bundleVersion':'1.0.0.176'},
 {'name':'ArgusMonitorIntervalMonitor','type':'interval','class':'ch.rasia.extension.argus.monitor.IntervalMonitorImpl','bundleName':'argus.monitor','bundleVersion':'1.0.0.176'},
  {'name':'ArgusMonitorRequestMonitor','type':'request','class':'ch.rasia.extension.argus.monitor.RequestMonitorImpl','bundleName':'argus.monitor','bundleVersion':'1.0.0.176'}]"
```

A monitor can also be resolved from Maven instead of an OSGi bundle, use the `maven` key instead of `bundleName` and `bundleVersion`:

```manifest
monitor: "[{'name':'BlockingRequestMonitor','type':'request','class':'com.mycompany.monitors.BlockingRequestMonitor','maven':'com.mycompany:monitor-lib:2.1.0'}]"
```

Installing an extension that declares a monitor also enables monitoring (`monitoring.enabled`) and registers the monitor with logging enabled. The `async` option is not available in the manifest, set it in `.CFConfig.json` if you need it.

## Accessing Monitor Data from CFML

Lucee provides CFML functions to interact with monitor data programmatically:

```javascript
// Get action monitor data
actionData = getMonitorData("action", {
    startDate: dateAdd("d", -7, now()),
    endDate: now(),
    type: "query"
});

// Get request monitor data  
requestData = getMonitorData("request", {
    startDate: dateAdd("h", -1, now()),
    endDate: now(),
    errorOnly: true
});

// Get interval monitor data
systemData = getMonitorData("interval", {
    startDate: dateAdd("h", -2, now()),
    endDate: now()
});
```

# Security Considerations

When implementing hooks and monitors, consider these security aspects:

- **Class Loading**: Ensure only trusted classes are loaded
- **Configuration**: Protect sensitive configuration data
- **Monitor Data**: Be careful about exposing sensitive data through monitor interfaces
- **Resource Access**: Monitors have access to request data and system information
- **Performance Impact**: Keep monitor logic lightweight to avoid performance degradation

# Troubleshooting

## Common Issues

**Hook Not Loading**

- Verify class name and path are correct
- Check bundle/Maven dependencies are available  
- Review Lucee logs for error messages

**Monitor Not Triggering**

- Ensure monitoring is enabled in `.CFConfig.json`
- For a request monitor that should be called at the start of the request, check that the class declares a public `init(PageContext)` and implements `RequestMonitor` directly
- Check that the monitor interface is implemented correctly
- Verify the extension manifest syntax is valid

**Performance Issues**

- Keep monitor logic lightweight
- Use asynchronous processing for expensive operations
- Implement proper error handling to prevent monitor failures

## Debugging

Enable detailed logging to troubleshoot issues:

```json
{
  "loggers": {
    "startup": {
      "level": "DEBUG"
    },
    "monitor": {
      "level": "INFO"
    }
  }
}
```

# Future Development

Both the hook and monitoring systems continue to evolve with plans for:

- **Additional Hook Points**: More lifecycle events for hook integration
- **Real-time Monitor Streaming**: WebSocket-based real-time monitor data
- **Integrated Dashboards**: Combined view of hook status and monitor data
- **Alerting Framework**: Built-in alerting based on monitor thresholds
- **Configuration Templates**: Pre-built configurations for common use cases

Your feedback and suggestions are welcome to help shape the future of Lucee's extension and monitoring capabilities.