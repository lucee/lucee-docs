<!--
{
  "title": "Creating Component-Based Jobs with Quartz Scheduler",
  "id": "component-jobs-quartz-scheduler",
  "related": ["scheduler-quartz", "clustering-quartz-scheduler"],
  "categories": ["extensions", "recipes"],
  "description": "How to create and configure component-based jobs with the Quartz Scheduler extension",
  "keywords": [
    "scheduler",
    "quartz",
    "component",
    "cfc",
    "jobs",
    "listeners"
  ]
}
-->

# Creating Component-Based Jobs with Quartz Scheduler

This recipe provides detailed instructions for creating and configuring component-based jobs with the Quartz Scheduler extension for Lucee.

For a general overview of the Quartz Scheduler extension, see the [Quartz Scheduler documentation](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/scheduler-quartz.md).

## Overview

Component-based jobs are a powerful feature of the Quartz Scheduler extension that allow you to execute CFML components (CFCs) as scheduled tasks. This approach provides several advantages over URL-based jobs:

- **Full CFML Capabilities**: Leverage the full power of CFML in your scheduled tasks
- **Object-Oriented Design**: Organize your scheduled tasks using proper OO principles
- **Dependency Injection**: Pass configuration parameters to your components
- **Better Testing**: Create testable, reusable components

## Component Mappings

Before creating component-based jobs, it's important to understand how Lucee locates your components using component mappings.

### Default Component Mappings

Every Lucee installation comes with the following default mapping configuration:

```json
{
  "componentMappings": [
    {
      "physical": "{lucee-config}/components/",
      "virtual": "/7c0791ef8c6ceb3efef56e85a04ae393",
      "archive": "",
      "primary": "physical",
      "inspectTemplate": "always"
    }
  ]
}
```

This mapping establishes a location where Lucee looks for components, similar to classpath in Java.

### Configuring Custom Mappings

You can extend the component mappings by:

1. **Editing the Configuration File**:
   Edit `lucee-server/context/.CFConfig.json` to add your own mappings

2. **Using the Lucee Administrator**:
   Navigate to Server/Web Admin > Archives & Resources > Component Mappings

When a component is referenced in a Quartz Scheduler job configuration, Lucee will search for it in these configured mappings.

## Creating a Component-Based Job

### Step 1: Create the Component

Create a CFC with an `execute()` method that contains your job logic. Optionally, include an `init()` method to receive configuration parameters.

```cfml
// path: {lucee-config}/components/jobs/DatabaseCleanupJob.cfc
component {
    
    // Properties
    property name="tableName" type="string";
    property name="retentionDays" type="numeric";
    property name="logName" type="string" default="scheduler";
    
    // Constructor - receives job parameters
    public void function init(
        required string tableName,
        numeric retentionDays=30,
        string logName="scheduler"
    ) {
        variables.tableName = arguments.tableName;
        variables.retentionDays = arguments.retentionDays;
        variables.logName = arguments.logName;
        
        log log=variables.logName type="info" text="DatabaseCleanupJob initialized for table: #variables.tableName#";
    }
    
    // Required execute method - called when the job runs
    public void function execute() {
        try {
            log log=variables.logName type="info" text="Starting cleanup for table: #variables.tableName#";
            
            // Sample cleanup logic
            var cutoffDate = dateAdd("d", -variables.retentionDays, now());
            var result = queryExecute(
                "DELETE FROM #variables.tableName# WHERE created_date < :cutoffDate",
                {cutoffDate: {value: cutoffDate, cfsqltype: "CF_SQL_TIMESTAMP"}},
                {datasource: "myDatasource"}
            );
            
            log log=variables.logName type="info" text="Cleanup complete. Removed #result.recordCount# records from #variables.tableName#";
        }
        catch(any e) {
            log log=variables.logName type="error" text="Error in DatabaseCleanupJob: #e.message#" exception=e;
            rethrow;
        }
    }
}
```

### Step 2: Place the Component in a Mapped Location

Either:
1. Save your component in the default component directory: `{lucee-config}/components/jobs/DatabaseCleanupJob.cfc`
2. Create a custom mapping that points to your component's location

### Step 3: Configure the Job in Quartz Scheduler

Add the component job to your Quartz Scheduler configuration:

```json
{
  "jobs": [
    {
      "label": "Database Cleanup - User Logs",
      "component": "jobs.DatabaseCleanupJob",
      "cron": "0 0 3 * * ?",  // Run at 3 AM daily
      "pause": false,
      "mode": "transient",
      "tableName": "user_logs",
      "retentionDays": 90
    }
  ]
}
```

## Component Modes

Quartz Scheduler supports two modes for component jobs:

1. **Transient Mode** (default):
   - Creates a new instance of the component for each execution
   - Useful for jobs that don't need to maintain state between executions
   - Configuration: `"mode": "transient"`

2. **Singleton Mode**:
   - Creates a single instance that's reused across all executions
   - Useful for jobs that maintain state or have expensive initialization
   - Configuration: `"mode": "singleton"`

Example of singleton mode:

```json
{
  "label": "Incremental Data Processor",
  "component": "jobs.DataProcessor",
  "cron": "0 */15 * * * ?",  // Every 15 minutes
  "mode": "singleton",
  "batchSize": 100
}
```

## Creating a Job Listener

Job listeners allow you to monitor and respond to job execution events. They can be used for logging, notifications, or to implement more complex job coordination.

### Step 1: Create the Listener Component

Create a CFC that implements the necessary listener methods:

```cfml
// path: {lucee-config}/components/listeners/JobMonitorListener.cfc
component {
    
    // Properties
    property name="name" type="string";
    property name="stream" type="string";
    property name="logFile" type="string";
    
    // Constructor - receives listener parameters
    public void function init(struct listenerData) {
        variables.name = "JobMonitorListener";
        variables.stream = listenerData.stream ?: "err";
        variables.logFile = listenerData.logFile ?: "";
        
        // Initialize any resources
        if (len(variables.logFile)) {
            // Ensure log directory exists
            var logDir = getDirectoryFromPath(variables.logFile);
            if (!directoryExists(logDir)) {
                directoryCreate(logDir);
            }
        }
    }
    
    // Required method - returns the name of the listener
    public string function getName() {
        return variables.name;
    }
    
    // Called before a job executes
    public void function jobToBeExecuted(jobExecutionContext) {
        var jobDetail = jobExecutionContext.getJobDetail();
        var jobDataMap = jobDetail.getJobDataMap();
        var jobName = jobDataMap.get("label") ?: jobDetail.getKey().toString();
        
        var message = "#now()# - Job starting: #jobName#";
        writeToLog(message);
    }
    
    // Called after a job executes
    public void function jobWasExecuted(jobExecutionContext, jobException) {
        var jobDetail = jobExecutionContext.getJobDetail();
        var jobDataMap = jobDetail.getJobDataMap();
        var jobName = jobDataMap.get("label") ?: jobDetail.getKey().toString();
        
        if (isNull(jobException)) {
            var message = "#now()# - Job completed successfully: #jobName#";
        } else {
            var message = "#now()# - Job failed: #jobName# - Error: #jobException.getMessage()#";
        }
        
        writeToLog(message);
    }
    
    // Called when a job is vetoed
    public void function jobExecutionVetoed(jobExecutionContext) {
        var jobDetail = jobExecutionContext.getJobDetail();
        var jobDataMap = jobDetail.getJobDataMap();
        var jobName = jobDataMap.get("label") ?: jobDetail.getKey().toString();
        
        var message = "#now()# - Job execution vetoed: #jobName#";
        writeToLog(message);
    }
    
    // Helper function to write to log
    private void function writeToLog(required string message) {
        // Write to console
        if (variables.stream == "out") {
            systemOutput(message, true, true);
        } else {
            systemOutput(message, true, false);
        }
        
        // Write to log file if configured
        if (len(variables.logFile)) {
            fileAppend(variables.logFile, message & chr(13) & chr(10));
        }
    }
}
```

### Step 2: Place the Listener in a Mapped Location

Save your listener component in a location accessible via component mapping, such as:
`{lucee-config}/components/listeners/JobMonitorListener.cfc`

### Step 3: Configure the Listener in Quartz Scheduler

Add the listener to your Quartz Scheduler configuration:

```json
{
  "listeners": [
    {
      "component": "listeners.JobMonitorListener",
      "stream": "err",
      "logFile": "{lucee-config}/logs/quartz-jobs.log"
    }
  ]
}
```

## Best Practices

1. **Organize Your Components**:
   - Create a clear structure for your job components (e.g., by function or application area)
   - Use namespaces to avoid conflicts (e.g., `myapp.jobs.DataCleanup`)

2. **Handle Exceptions Properly**:
   - Always implement error handling in your `execute()` method
   - Log detailed error information to help with troubleshooting

3. **Keep Jobs Focused**:
   - Each job component should have a single responsibility
   - For complex operations, consider creating helper components

4. **Use Dependency Injection**:
   - Pass configuration values through the job configuration
   - Avoid hardcoding values in your components

5. **Include Logging**:
   - Add detailed logging to track job execution
   - Use listeners for centralized monitoring

## Conclusion

Component-based jobs in Quartz Scheduler provide a powerful way to organize and implement your scheduled tasks in Lucee. By understanding component mappings and following these patterns, you can create maintainable, testable job components that leverage the full power of CFML.

Remember to place your components in locations accessible via component mappings and to configure your jobs properly in the Quartz Scheduler configuration.