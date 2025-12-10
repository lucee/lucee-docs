<!--
{
  "title": "Java Scripting with Lucee",
  "id": "java-scripting-lucee",
  "since": "5.0",
  "categories": ["scripting", "integration", "jsr223"],
  "description": "Documentation for using Lucee as a scripting engine in Java applications via JSR-223",
  "keywords": [
    "Java",
    "JSR-223",
    "ScriptEngine",
    "CFML",
    "Scripting",
    "Integration",
    "Serverless",
    "Lambda"
  ]
}
-->

# Java Scripting with Lucee

Lucee provides comprehensive support for JSR-223 (Java Scripting API), enabling CFML to be used as a scripting language in any environment that supports the Java platform. 

This opens up powerful integration scenarios where you can leverage CFML's expressive syntax and built-in functions across diverse technology stacks, build tools, serverless platforms, and automation frameworks.

## Overview

Through JSR-223 support, Lucee can be used as a scripting engine in any environment that runs on the Java platform. This includes build tools like Ant and Maven, serverless platforms like AWS Lambda, CI/CD pipelines, data processing workflows, and standalone scripts. 

The integration requires only adding Lucee JAR files to your classpath - no complex setup or application server needed.

## AI-Optimized Technical Reference

For developers using AI assistance or requiring structured technical data, see the companion specification:
**[Java Scripting Technical Spec](https://github.com/lucee/lucee-docs/blob/master/docs/technical-specs/java-scripting.yaml)**

This YAML document contains pure technical facts optimized for:

- AI systems generating code implementations
- Quick reference lookup of engine names, dependencies, and system properties  
- Tool consumption and automated integration
- Developers already familiar with JSR-223 who need only Lucee-specific details

## Requirements

- Java 11 or higher
- Lucee 5.0 or higher (lucee.jar)
- Servlet API implementation (javax.servlet or jakarta.servlet)
- Optional: Additional Lucee extensions as needed

## How It Works

1. Lucee registers itself as a JSR-223 ScriptEngine via `META-INF/services/javax.script.ScriptEngineFactory`
2. The Java application discovers Lucee through the standard ScriptEngineManager
3. CFML code can be executed directly from Java strings or files
4. Variables and objects can be passed bidirectionally between Java and CFML
5. CFML functions and features work as expected within the scripting context

## Basic Setup

### Adding Lucee to Your Project

#### Maven Dependencies

```xml
<dependencies>
    <!-- Lucee Core -->
    <dependency>
        <groupId>org.lucee</groupId>
        <artifactId>lucee</artifactId>
        <version>6.0.0.677-SNAPSHOT</version>
    </dependency>
    
    <!-- Servlet API (choose javax or jakarta based on your environment) -->
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
        <version>4.0.1</version>
    </dependency>
</dependencies>
```

#### Gradle Dependencies

```gradle
dependencies {
    implementation 'org.lucee:lucee:6.0.0.677-SNAPSHOT'
    implementation 'javax.servlet:javax.servlet-api:4.0.1'
}
```

### Simple Java Integration

```java
import javax.script.*;

public class LuceeScriptingExample {
    public static void main(String[] args) throws ScriptException {
        // Get the script engine manager
        ScriptEngineManager manager = new ScriptEngineManager();
        
        // Get the CFML script engine
        ScriptEngine engine = manager.getEngineByName("CFML");
        
        if (engine == null) {
            System.err.println("CFML script engine not found!");
            return;
        }
        
        // Execute simple CFML code
        String cfmlCode = """
            name = "World";
            message = "Hello, " & name & "!";
            writeOutput(message);
        """;
        
        Object result = engine.eval(cfmlCode);
        System.out.println("Script executed successfully");
    }
}
```

## Basic Examples

### Example 1: Variable Exchange

```java
import javax.script.*;

public class VariableExchange {
    public static void main(String[] args) throws ScriptException {
        ScriptEngineManager manager = new ScriptEngineManager();
        ScriptEngine engine = manager.getEngineByName("CFML");
        
        // Pass variables from Java to CFML
        engine.put("javaVariable", "Hello from Java!");
        engine.put("numbers", new int[]{1, 2, 3, 4, 5});
        
        // Execute CFML that uses Java variables
        engine.eval("""
            writeOutput("Java sent: " & javaVariable & "<br>");
            
            total = 0;
            for(num in numbers) {
                total += num;
            }
            
            result = "Sum of numbers: " & total;
            writeOutput(result);
        """);
        
        // Get results back from CFML
        String result = (String) engine.get("result");
        System.out.println("CFML result: " + result);
    }
}
```

### Example 2: Build Automation

Simple build script processing with Ant:

```xml
<!-- build.xml -->
<project name="DataProcessor" default="process">
    <target name="process">
        <script language="CFML">
            <![CDATA[
            // Read configuration
            configFile = "config.json";
            if(fileExists(configFile)) {
                config = deserializeJSON(fileRead(configFile));
                
                // Process based on configuration
                writeOutput("Processing " & config.environment & " build...<br>");
                
                // Simple file operations
                if(config.cleanBuild) {
                    if(directoryExists("./dist")) {
                        directoryDelete("./dist", true);
                    }
                    directoryCreate("./dist");
                }
                
                // Update version
                config.buildNumber++;
                config.lastBuild = dateTimeFormat(now(), "iso8601");
                
                // Write back configuration
                fileWrite(configFile, serializeJSON(config));
                
                writeOutput("Build " & config.buildNumber & " completed!<br>");
            }
            ]]>
        </script>
    </target>
</project>
```

### Example 3: Command Line Utility

```java
// SimpleProcessor.java
import javax.script.*;

public class SimpleProcessor {
    public static void main(String[] args) throws ScriptException {
        if (args.length == 0) {
            System.out.println("Usage: java SimpleProcessor <command>");
            return;
        }
        
        ScriptEngineManager manager = new ScriptEngineManager();
        ScriptEngine engine = manager.getEngineByName("CFML");
        
        engine.put("command", args[0]);
        engine.put("arguments", args);
        
        engine.eval("""
            switch(command) {
                case "hash":
                    if(arrayLen(arguments) > 1) {
                        result = hash(arguments[2], "SHA-256");
                        writeOutput("SHA-256: " & result);
                    }
                    break;
                    
                case "uuid":
                    result = createUUID();
                    writeOutput("UUID: " & result);
                    break;
                    
                case "date":
                    result = dateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss");
                    writeOutput("Current time: " & result);
                    break;
                    
                default:
                    writeOutput("Unknown command: " & command);
            }
        """);
    }
}
```

## Real-World Scenarios

### CI/CD Pipeline Processing

```yaml
# GitHub Actions example
- name: Process Release Data
  run: |
    java -cp "lucee.jar:servlet-api.jar" \
         lucee.runtime.script.CFMLScriptEngineFactory \
         eval "
         version = '${{ github.event.release.tag_name }}';
         writeOutput('Processing release: ' & version);
         
         // Generate release notes
         notes = {
           'version': version,
           'date': dateTimeFormat(now(), 'yyyy-mm-dd'),
           'build': '${{ github.run_number }}'
         };
         
         fileWrite('release-info.json', serializeJSON(notes));
         "
```

### Data Migration Scripts

```java
// MigrationRunner.java
ScriptEngine engine = manager.getEngineByName("CFML");
engine.put("sourceDB", dataSource1);
engine.put("targetDB", dataSource2);

engine.eval("""
    // Simple data transformation
    sourceData = queryExecute("SELECT * FROM old_table", {}, {datasource: sourceDB});
    
    for(row in sourceData) {
        transformedData = {
            id: row.id,
            name: uCase(row.name),
            created_date: dateFormat(row.date_created, "yyyy-mm-dd")
        };
        
        queryExecute("
            INSERT INTO new_table (id, name, created_date) 
            VALUES (:id, :name, :created_date)
        ", transformedData, {datasource: targetDB});
    }
    
    writeOutput("Migrated " & sourceData.recordCount & " records");
""");
```

### Configuration Processing

```java
// ConfigProcessor.java - For deployment automation
engine.put("environment", System.getProperty("env", "dev"));
engine.put("configTemplate", Files.readString(Paths.get("config.template")));

engine.eval("""
    config = deserializeJSON(configTemplate);
    
    // Environment-specific settings
    switch(environment) {
        case "prod":
            config.database.host = "prod-db.company.com";
            config.cache.enabled = true;
            break;
        case "staging":
            config.database.host = "staging-db.company.com";
            config.debug = false;
            break;
        default:
            config.database.host = "localhost";
            config.debug = true;
    }
    
    finalConfig = serializeJSON(config);
""");

String result = (String) engine.get("finalConfig");
Files.writeString(Paths.get("application.json"), result);
```

### Log Analysis

```java
// LogAnalyzer.java
engine.put("logContent", Files.readString(Paths.get("app.log")));

engine.eval("""
    lines = listToArray(logContent, chr(10));
    
    stats = {
        total: arrayLen(lines),
        errors: 0,
        warnings: 0,
        timeRange: {}
    };
    
    for(line in lines) {
        if(findNoCase("ERROR", line)) stats.errors++;
        if(findNoCase("WARN", line)) stats.warnings++;
    }
    
    // Extract first and last timestamps
    if(arrayLen(lines) > 0) {
        firstLine = lines[1];
        lastLine = lines[arrayLen(lines)];
        
        // Simple timestamp extraction (adjust pattern as needed)
        timestampPattern = "\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}";
        firstTimestamp = reMatch(timestampPattern, firstLine);
        lastTimestamp = reMatch(timestampPattern, lastLine);
        
        if(arrayLen(firstTimestamp)) stats.timeRange.start = firstTimestamp[1];
        if(arrayLen(lastTimestamp)) stats.timeRange.end = lastTimestamp[1];
    }
    
    summary = "Log Analysis: " & stats.total & " lines, " & 
              stats.errors & " errors, " & stats.warnings & " warnings";
    writeOutput(summary);
""");
```

### Test Data Generation

```java
// TestDataGenerator.java
engine.put("recordCount", 1000);

engine.eval("""
    testData = [];
    
    for(i = 1; i <= recordCount; i++) {
        record = {
            id: i,
            name: "User" & i,
            email: "user" & i & "@test.com",
            created: dateAdd("d", -randRange(1, 365), now()),
            active: (i % 3 != 0) // ~66% active
        };
        arrayAppend(testData, record);
    }
    
    // Convert to CSV
    csvData = "id,name,email,created,active" & chr(10);
    for(record in testData) {
        csvData &= record.id & "," & 
                  record.name & "," & 
                  record.email & "," & 
                  dateFormat(record.created, "yyyy-mm-dd") & "," &
                  record.active & chr(10);
    }
    
    writeOutput("Generated " & arrayLen(testData) & " test records");
""");

String csvData = (String) engine.get("csvData");
Files.writeString(Paths.get("test-data.csv"), csvData);
```

### Docker Container Scripts

```dockerfile
# Dockerfile example
FROM openjdk:11-jre-slim

COPY lucee.jar servlet-api.jar /app/lib/
COPY process-script.cfm /app/

WORKDIR /app

CMD ["java", "-cp", "lib/*", "lucee.runtime.script.CFMLScriptEngineFactory", \
     "eval", "include 'process-script.cfm';"]
```

### Kubernetes Job Processing

```yaml
# k8s-job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processor
spec:
  template:
    spec:
      containers:
      - name: processor
        image: openjdk:11
        command:
        - java
        - -cp
        - /app/lucee.jar:/app/servlet-api.jar
        - lucee.runtime.script.CFMLScriptEngineFactory
        - eval
        - |
          writeOutput("Processing started at: " & dateTimeFormat(now(), "iso8601"));
          
          // Your processing logic here
          env = server.system.environment;
          writeOutput("Environment: " & env.NODE_NAME ?: "unknown");
          
          // Process data from mounted volumes or environment variables
          if(structKeyExists(env, "DATA_SOURCE")) {
              writeOutput("Processing data from: " & env.DATA_SOURCE);
          }
          
          writeOutput("Processing completed successfully");
        env:
        - name: DATA_SOURCE
          value: "/data/input.json"
        volumeMounts:
        - name: data-volume
          mountPath: /data
      restartPolicy: Never
```

## Advanced Integration Scenarios

### AWS Lambda Integration

Simple serverless function entry point:

```java
// LuceeLambdaHandler.java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import javax.script.*;
import java.util.Map;

public class LuceeLambdaHandler implements RequestHandler<Map<String, Object>, Map<String, Object>> {
    
    private static ScriptEngine engine;
    
    static {
        ScriptEngineManager manager = new ScriptEngineManager();
        engine = manager.getEngineByName("CFML");
    }
    
    @Override
    public Map<String, Object> handleRequest(Map<String, Object> input, Context context) {
        try {
            engine.put("inputData", input);
            engine.put("requestId", context.getAwsRequestId());
            
            engine.eval("""
                // Your business logic here
                result = {
                    "message": "Hello from Lucee!",
                    "requestId": requestId,
                    "timestamp": dateTimeFormat(now(), "iso8601"),
                    "processed": true
                };
                
                // Process input data
                if(structKeyExists(inputData, "name")) {
                    result.greeting = "Hello, " & inputData.name & "!";
                }
            """);
            
            @SuppressWarnings("unchecked")
            Map<String, Object> result = (Map<String, Object>) engine.get("result");
            return result;
            
        } catch (Exception e) {
            return Map.of("error", e.getMessage());
        }
    }
}
```

### Spring Boot Integration

Basic service integration:

```java
@Service
public class LuceeScriptService {
    private final ScriptEngine engine;
    
    public LuceeScriptService() {
        ScriptEngineManager manager = new ScriptEngineManager();
        this.engine = manager.getEngineByName("CFML");
    }
    
    public Object processRequest(String script, Map<String, Object> variables) throws ScriptException {
        if (variables != null) {
            variables.forEach(engine::put);
        }
        return engine.eval(script);
    }
}

@RestController
public class ScriptController {
    private final LuceeScriptService scriptService;
    
    @PostMapping("/api/process")
    public ResponseEntity<Object> process(@RequestBody Map<String, Object> request) {
        try {
            String script = """
                result = {
                    "processed": true,
                    "data": inputData,
                    "timestamp": dateTimeFormat(now(), "iso8601")
                };
            """;
            
            scriptService.processRequest(script, Map.of("inputData", request));
            return ResponseEntity.ok(scriptService.engine.get("result"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
```

## Performance and Best Practices

### Engine Reuse

```java
public class EngineManager {
    private static final ScriptEngineManager manager = new ScriptEngineManager();
    private static final ScriptEngine engine = manager.getEngineByName("CFML");
    
    public static Object execute(String script, Map<String, Object> variables) throws ScriptException {
        // Set variables
        if (variables != null) {
            variables.forEach(engine::put);
        }
        
        return engine.eval(script);
    }
}
```

### Error Handling

```java
public static class ScriptResult {
    private final boolean success;
    private final Object result;
    private final String errorMessage;
    
    public static ScriptResult execute(String script, Map<String, Object> variables) {
        try {
            ScriptEngineManager manager = new ScriptEngineManager();
            ScriptEngine engine = manager.getEngineByName("CFML");
            
            if (variables != null) {
                variables.forEach(engine::put);
            }
            
            // Add error handling in CFML
            engine.eval("""
                try {
                    // Your script here
                    scriptSuccess = true;
                    errorMsg = "";
                } catch(any e) {
                    scriptSuccess = false;
                    errorMsg = e.message;
                }
            """);
            
            engine.eval(script);
            
            Boolean success = (Boolean) engine.get("scriptSuccess");
            if (!success) {
                String error = (String) engine.get("errorMsg");
                return new ScriptResult(false, null, error);
            }
            
            Object result = engine.get("result");
            return new ScriptResult(true, result, null);
            
        } catch (Exception e) {
            return new ScriptResult(false, null, e.getMessage());
        }
    }
    
    // Constructor and getters...
}
```

### Thread Safety

```java
public class ThreadSafeScriptExecutor {
    private static final ThreadLocal<ScriptEngine> engineThreadLocal = 
        ThreadLocal.withInitial(() -> {
            ScriptEngineManager manager = new ScriptEngineManager();
            return manager.getEngineByName("CFML");
        });
    
    public static Object executeInThread(String script, Map<String, Object> variables) 
            throws ScriptException {
        ScriptEngine engine = engineThreadLocal.get();
        
        if (variables != null) {
            variables.forEach(engine::put);
        }
        
        return engine.eval(script);
    }
    
    public static void cleanup() {
        engineThreadLocal.remove();
    }
}
```

This comprehensive recipe provides everything needed to successfully integrate Lucee as a scripting engine in Java applications, from simple examples to complex enterprise scenarios like AWS Lambda and Spring Boot integration.