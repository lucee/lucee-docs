<!--
{
  "title": "Creating Component-Based Jobs with Quartz Scheduler",
  "id": "component-jobs-quartz-scheduler",
  "related": ["scheduler-quartz", "clustering-quartz-scheduler", "tag-schedule"],
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

Execute CFML components (CFCs) as scheduled tasks with Quartz Scheduler.

For general overview, see [[scheduler-quartz]].

Advantages over URL-based jobs:

- Full CFML capabilities
- Object-oriented design
- Dependency injection for configuration
- Testable, reusable components

## Component Mappings

Lucee uses component mappings to locate your components.

### Default Component Mappings

Default mapping configuration:

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

Similar to Java classpath.

### Configuring Custom Mappings

Extend mappings by:

1. Editing `lucee-server/context/.CFConfig.json`
2. Using Lucee Administrator > Archives & Resources > Component Mappings

## Creating a Component-Based Job

### Step 1: Create the Component

Create a CFC with an `execute()` method. Optionally include `init()` to receive configuration parameters.

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

- Save in default directory: `{lucee-config}/components/jobs/DatabaseCleanupJob.cfc`
- Or create a custom mapping to your component's location

### Step 3: Configure the Job

Add to Quartz Scheduler configuration:

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

- **Transient** (default): New instance per execution. Use when no state needed between runs.
- **Singleton**: Single reused instance. Use for stateful jobs or expensive initialization.

Singleton example:

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

Job listeners monitor job execution events - useful for logging, notifications, or job coordination.

### Step 1: Create the Listener Component

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

Save in a mapped location, e.g. `{lucee-config}/components/listeners/JobMonitorListener.cfc`

### Step 3: Configure the Listener

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

1. **Organize Components**: Use clear structure and namespaces (e.g., `myapp.jobs.DataCleanup`)
2. **Handle Exceptions**: Always implement error handling in `execute()`, log detailed errors
3. **Keep Jobs Focused**: Single responsibility per job, use helper components for complex operations
4. **Use Dependency Injection**: Pass config values through job configuration, avoid hardcoding
5. **Include Logging**: Track execution, use listeners for centralized monitoring