<!--
{
  "title": "Quartz Scheduler",
  "id": "scheduler-quartz",
  "since": "6.2",
  "categories": ["extensions"],
  "description": "Advanced task scheduling using Quartz Scheduler integration",
  "keywords": [
    "scheduler",
    "quartz",
    "cron",
    "scheduled task",
    "clustering"
  ]
}
-->

# Quartz Scheduler Extension for Lucee

Lucee 6.2 and 7.0 include a powerful extension for task scheduling using the industry-standard Quartz Scheduler. This extension provides robust scheduling capabilities with clustering support, flexible job definitions, and integration with the Lucee ecosystem. The extension is written entirely in CFML (100%), showcasing the power and flexibility of the language.

## Overview

The Quartz Scheduler extension brings industry-standard scheduling capabilities to Lucee, leveraging the most widely adopted scheduling system in the Java world. This provides access to a mature ecosystem of tools and a large community beyond the CFML world, including numerous free and commercial products for interacting with your scheduled tasks.

Starting with Lucee 7, the traditional "Scheduled Task" system has been moved to an extension, allowing you to choose between the legacy system and the new Quartz Scheduler. During this transition period, the legacy Scheduled Task extension is installed by default, while Quartz Scheduler requires explicit installation.

## Key Features

- **Multiple Job Types**: Schedule URL calls, server-local paths, or component executions
- **Clustering Support**: Distribute your scheduled tasks across multiple servers using database or Redis persistence
- **Flexible Scheduling**: Use simple interval-based scheduling or powerful cron expressions
- **Event Listeners**: Attach listener components to monitor job execution
- **JSON Configuration**: Define your tasks using flexible JSON configuration
- **Component Integration**: Execute CFML components as scheduled tasks with dependency injection

## Installation

The Quartz Scheduler extension can be installed in two ways:

### Using the Lucee Administrator

1. Navigate to the Extensions > Available Extensions section
2. Look for "Quartz Scheduler" in the list
3. Click "Install" to add the extension

### Manual Installation

1. Download the extension from [download.lucee.org](https://download.lucee.org)
2. Copy the downloaded .lex file to the Lucee deploy folder: `lucee-server/deploy`
3. Lucee will automatically detect and install the extension within a minute

In Lucee 6.2, this extension is considered experimental, primarily for testing purposes. In Lucee 7, it's fully supported as an alternative to the legacy Scheduled Task system.

## Administration

The Quartz Scheduler extension provides comprehensive administration tools to manage your scheduled tasks:

### Lucee Administrator Integration

The extension includes a full-featured frontend in the Lucee Administrator to manage all aspects of your scheduled tasks:
- Job creation and management
- Listener configuration
- Storage settings
- Real-time monitoring

### Standalone Client

In addition to the Admin integration, a read-only standalone client is available that provides an overview of all running jobs and listeners, making it easy to monitor your scheduled tasks across multiple servers.

## Configuration

The Quartz Scheduler is configured using JSON, which provides full flexibility for advanced configurations. You can define your configuration in two ways:

### 1. Using the Configuration File

Create or modify the configuration file located at:
```
{lucee-server}/lucee-server/context/quartz/config.json
```

### 2. Using the Deployment Mechanism

Lucee provides a "deploy" folder where you can place configuration files that Lucee will automatically pick up and install. To update your Quartz Scheduler configuration:

1. Create a file named `config.quartz` with your configuration
2. Place it in the Lucee deploy directory
3. Lucee will detect and process it within a minute

This mechanism updates the existing configuration rather than replacing it completely.

## Configuration Structure

The Quartz Scheduler configuration has three main sections:

```json
{
  "jobs": [...],
  "listeners": [...],
  "store": {...}
}
```

### Jobs Configuration

Jobs are the tasks that will be executed according to a schedule. Each job configuration can include:

```json
{
  "label": "Job description",
  "url": "/path/to/execute.cfm",  // OR
  "component": "path.to.component",
  "interval": "60",  // Simple interval in seconds, OR
  "cron": "0 0/5 * * * ?",  // Cron expression
  "pause": false,
  "startAt": "April 1, 2025 08:00:00",  // Optional start date
  "endAt": "December 31, 2025 17:00:00",  // Optional end date
  "mode": "singleton",  // For component jobs: "singleton" or "transient"
  // Additional custom parameters for component initialization
  "customParam1": "value1",
  "customParam2": 123
}
```

#### Job Types

1. **URL Jobs**: Execute HTTP requests to internal or external URLs
   ```json
   {
     "label": "Call external API",
     "url": "https://api.example.com/endpoint",
     "interval": "3600"
   }
   ```

2. **Internal Path Jobs**: Execute a path local to the server (important for proper load balancing in clusters)
   ```json
   {
     "label": "Process local data",
     "url": "/jobs/process-data.cfm",
     "cron": "0 0 * * * ?"
   }
   ```

3. **Component Jobs**: Execute a CFML component
   ```json
   {
     "label": "Database maintenance",
     "component": "com.example.tasks.DatabaseMaintenance",
     "cron": "0 0 3 * * ?",
     "mode": "singleton",
     "dbName": "users"
   }
   ```

#### Scheduling Options

1. **Simple Interval**: Specify execution frequency in seconds
   ```json
   "interval": "60"  // Execute every 60 seconds
   ```

2. **Cron Expression**: Use powerful cron syntax for complex schedules
   ```json
   "cron": "0 0 9-17 ? * MON-FRI"  // Every hour from 9am-5pm on weekdays
   ```

   > **Tip**: Creating cron expressions can be challenging. AI tools like Google, ChatGPT, or Claude can help you define the correct cron expression for your specific scheduling needs. Simply ask something like "Create a cron expression that runs every Tuesday at 3 PM" to get assistance.

### Listeners Configuration

Listeners are components that monitor job execution:

```json
{
  "component": "path.to.ListenerComponent",
  "stream": "err"  // "err" or "out" for console output
}
```

### Storage Configuration

Storage determines how job information is persisted and enables clustering:

1. **In-Memory (Default)**: No configuration needed
   - Jobs are stored in memory and read/saved to the config file
   - No clustering support

2. **Database Storage**:
   ```json
   "store": {
     "type": "datasource",
     "datasource": "quartz",
     "tablePrefix": "QRTZ_",
     "cluster": true,
     "clusterCheckinInterval": "15000",
     "misfireThreshold": "60000"
   }
   ```

3. **Redis Storage**:
   ```json
   "store": {
     "type": "redis",
     "host": "localhost",
     "port": 6379,
     "keyPrefix": "QRTZ_",
     "password": "${REDIS_PASSWORD}",
     "redisCluster": false,
     "redisSentinel": false,
     "masterGroupName": "",
     "database": 0,
     "lockTimeout": 30000,
     "ssl": false,
     "misfireThreshold": 60000
   }
   ```

#### Database Setup for Clustering

When using database storage for clustering, Quartz Scheduler needs specific tables in your database. The extension will attempt to create these tables automatically when it starts, but this requires the database user to have sufficient privileges.

If you encounter errors like `Table 'quartz.QRTZ_TRIGGERS' doesn't exist`, you may need to:

1. **Check Database Permissions**: Ensure your database user has privileges to create tables
2. **Create Tables Manually**: You can manually create the required tables using database-specific SQL scripts

For detailed database setup instructions, including scripts for different database systems, see the dedicated [Clustering with Quartz Scheduler](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/scheduler-quartz-clustering.md) recipe.

## Component Jobs

When using components as scheduled tasks, the component must include an `execute()` method that will be called by the scheduler. You can also include an `init()` method that will receive all job configuration parameters.

### Component Example

```cfml
component {
    
    // Constructor - receives all job parameters
    public void function init(required string label, numeric customNumber=0, boolean customBoolean=false, string customString="") {
        variables.label = arguments.label;
        variables.customNumber = arguments.customNumber;
        variables.customBoolean = arguments.customBoolean;
        variables.customString = arguments.customString;
    }
    
    // Required execute method - called when the job runs
    public void function execute() {
        // Your task logic here
        log.log(text="Executing job: #variables.label#");
    }
}
```

### Component Modes

1. **Transient Mode (Default)**: Creates a new instance of the component for each execution
2. **Singleton Mode**: Creates a single instance that is reused across all executions

```json
{
  "component": "com.example.tasks.MyTask",
  "mode": "singleton"  // Use the same instance for all executions
}
```

## URL Jobs

URL jobs can point to either external URLs (with http:// or https://) or internal relative paths:

- **External URLs**: Make standard HTTP requests
- **Internal Paths**: Use internal request mechanism to ensure execution on the current server

The extension also supports stateful vs. stateless URL jobs (coming soon).

## Clustering

One of the most powerful features of the Quartz Scheduler is clustering support, which allows you to distribute your scheduled tasks across multiple servers:

1. **Configure a Storage Backend**: Set up database or Redis persistence
2. **Enable Clustering**: Set the `cluster` parameter to `true` in your storage configuration
3. **Deploy to Multiple Servers**: Each server will coordinate with others to ensure tasks run once

When clustering is enabled, the storage backend becomes the source of truth. The configuration file is used:
- As a backup for job definitions
- To provide initial jobs only when the storage has no jobs defined
- For listener definitions (which always come from the config file)

For detailed instructions and best practices on setting up clustering with Quartz Scheduler, see the dedicated [Clustering with Quartz Scheduler](recipes/clustering-quartz-scheduler.md) recipe.

## Related Recipes

For more detailed information on specific aspects of the Quartz Scheduler extension, refer to these dedicated recipes:

- [Clustering with Quartz Scheduler](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/scheduler-quartz-clustering.md): Detailed instructions for setting up and configuring clustering
- [Creating Component-Based Jobs with Quartz Scheduler](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/scheduler-quartz-component-jobs.md): Guide to creating and configuring component-based jobs

## Full Configuration Example

```json
{
  "jobs": [
    {
      "label": "External API Call",
      "url": "https://api.example.com/daily-report",
      "cron": "0 0 8 * * ?",
      "pause": false
    },
    {
      "label": "Local Data Processing",
      "url": "/tasks/process-data.cfm",
      "interval": "3600",
      "endAt": "December 31, 2025 23:59:59"
    },
    {
      "label": "Database Maintenance",
      "component": "com.example.tasks.DatabaseMaintenance",
      "cron": "0 0 3 ? * SUN",
      "mode": "singleton",
      "customParam1": "value1",
      "customParam2": 123
    }
  ],
  "listeners": [
    {
      "component": "com.example.scheduler.ExecutionListener",
      "stream": "err"
    }
  ],
  "store": {
    "type": "datasource",
    "datasource": "quartz",
    "tablePrefix": "QRTZ_",
    "cluster": true
  }
}
```

## Migration from Legacy Scheduled Tasks

The Quartz Scheduler extension does not currently read configuration from the legacy Scheduled Task system. However, it provides similar functionality for defining tasks:

- **URL Tasks**: Use the `url` parameter with an absolute or relative URL
- **Interval-based Scheduling**: Use the `interval` parameter with seconds (similar to the legacy system)
- **Cron-based Scheduling**: Use the more powerful `cron` parameter for advanced scheduling

## Conclusion

The Quartz Scheduler extension brings robust, industry-standard scheduling capabilities to Lucee applications. With support for clustering, flexible job definitions, and powerful scheduling options, it provides a solid foundation for mission-critical scheduled tasks in your applications.

As this extension continues to evolve, additional features and improvements will be added, including better migration support from the legacy Scheduled Task system.