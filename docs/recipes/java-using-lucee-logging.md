<!--
{
  "title": "Java Classes Using Lucee's Logging",
  "id": "java-using-lucee-logging",
  "categories": ["java", "logging"],
  "description": "How to make Java classes log through Lucee's logging system",
  "keywords": [
    "java",
    "logging",
    "slf4j",
    "log4j",
    "lucee.commons.io.log.Log"
  ],
  "related": [
    "logging",
    "java-class-interaction",
    "java-libraries",
    "tag-log",
    "function-writelog"
  ]
}
-->

# Java Classes Using Lucee's Logging

You've moved some heavy processing into a Java class - maybe PDF generation, image manipulation, or a payment gateway integration. It works great, but when something goes wrong, you're flying blind. You want logging, just like you'd use `writeLog()` in CFML.

You search online and every Java tutorial says "use SLF4J". So you add logging calls, deploy to Lucee, and... nothing. Your logs vanish into thin air.

This recipe shows how to get your Java classes logging alongside your CFML code, using Lucee's built-in logging system.

## The Problem with SLF4J

If you've looked into Java logging, you've probably encountered [SLF4J](https://www.slf4j.org/) (Simple Logging Facade for Java). It's the standard way Java libraries handle logging - instead of choosing a specific logging implementation, they log through SLF4J, and the application decides where those logs actually go.

Code using SLF4J looks like this:

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

private static final Logger logger = LoggerFactory.getLogger("payment");
logger.info("Processing payment...");
```

This won't work in Lucee. Lucee bundles something called `slf4j-nop` - the "no operation" binding - which deliberately silences all SLF4J logging. This stops noisy third-party libraries from flooding your logs, but it also means your Java code logs to nowhere.

You could try to fight Lucee's OSGi classloader system and swap in a different SLF4J binding, but there's a much simpler approach.

## The Solution: Pass Lucee's Logger to Java

Instead of trying to configure Java's logging infrastructure, just pass Lucee's logger directly to your Java class. Think of it like dependency injection - your CFML code creates the logger and hands it to Java.

### Step 1: Write the Java Class

Here's a simple Java class that accepts a Lucee logger. If you're new to Java, don't worry - this is about as simple as it gets:

```java
package com.mycompany.utils;

import lucee.commons.io.log.Log;

public class PaymentProcessor {

    private final Log logger;

    // Constructor - receives the logger from CFML
    public PaymentProcessor( Log logger ) {
        this.logger = logger;
    }

    public boolean processPayment( String customerId, double amount ) {
        // Log methods take two arguments: a "source" name and the message
        // The source helps you identify where the log came from
        logger.debug( "PaymentProcessor", "Starting payment for: " + customerId );
        logger.info( "PaymentProcessor", "Processing $" + amount + " for " + customerId );

        if ( amount > 10000 ) {
            logger.warn( "PaymentProcessor", "Large transaction: $" + amount );
        }

        return true;
    }
}
```

The key things to notice:

- **`import lucee.commons.io.log.Log`** - This is Lucee's logging interface
- **`private final Log logger`** - Store the logger as a class field (like a component variable)
- **Constructor takes `Log logger`** - CFML will pass this when creating the object
- **`logger.info( source, message )`** - Similar to `writeLog( text=message, log="payment" )`

### Step 2: Build with Maven

You'll need Maven to compile your Java class. If you haven't used Maven before, it's Java's equivalent of npm or CommandBox - it manages dependencies and builds your code.

Create a `pom.xml` file in your project folder:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.mycompany.utils</groupId>
    <artifactId>paymentprocessor</artifactId>
    <version>1.0.0</version>

    <properties>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
    </properties>

    <dependencies>
        <!-- Use your target Lucee version - see https://mvnrepository.com/artifact/org.lucee/lucee -->
        <dependency>
            <groupId>org.lucee</groupId>
            <artifactId>lucee</artifactId>
            <version>7.0.1.100</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>
</project>
```

The `<scope>provided</scope>` bit is important - it tells Maven "I need Lucee to compile against, but don't bundle it in my jar". Lucee is already running when your code executes.

Build your jar with:

```bash
mvn clean package
```

This creates `target/paymentprocessor-1.0.0.jar`.

### Step 3: Configure the Logger in Lucee

Before you can use a named logger, it needs to exist in Lucee. You've probably done this before for CFML logging.

Add it to your `.CFConfig.json`:

```json
{
    "loggers": {
        "payment": {
            "appender": "console",
            "layout": "classic",
            "level": "debug"
        }
    }
}
```

Or create it through Lucee Admin under Settings > Logging.

### Step 4: Call from CFML

Now the fun part - wire it all together:

```cfml
<cfscript>
    // Get the logger you configured in Lucee
    paymentLog = getPageContext().getConfig().getLog( "payment" );

    // Load your jar and pass the logger to the constructor
    jarPath = getDirectoryFromPath( getCurrentTemplatePath() ) & "lib/paymentprocessor-1.0.0.jar";
    processor = createObject( "java", "com.mycompany.utils.PaymentProcessor", jarPath )
        .init( paymentLog );

    // Use your Java class - all logging goes through Lucee
    processor.processPayment( "CUST-12345", 99.95 );
</cfscript>
```

Your Java logs now appear in the same place as your CFML logs, with the same formatting and log levels. No separate log files to check, no Java logging configuration to maintain.

## Log Levels

The log levels work just like `writeLog()` in CFML. The [`lucee.commons.io.log.Log`](https://www.javadoc.io/static/org.lucee/lucee/7.0.1.100/lucee/commons/io/log/Log.html) interface is thread-safe and provides:

| Java Method                    | CFML Equivalent                              |
|--------------------------------|----------------------------------------------|
| `logger.trace( app, message )` | `writeLog( type="trace", ... )`              |
| `logger.debug( app, message )` | `writeLog( type="debug", ... )`              |
| `logger.info( app, message )`  | `writeLog( type="information", ... )`        |
| `logger.warn( app, message )`  | `writeLog( type="warning", ... )`            |
| `logger.error( app, message )` | `writeLog( type="error", ... )`              |
| `logger.fatal( app, message )` | `writeLog( type="fatal", ... )`              |

### Logging Exceptions

In Java, you'll often want to log exceptions with their stack traces. The Log interface handles this for you:

```java
try {
    // something risky
} catch ( Exception e ) {
    // Log with a message and the exception (includes stack trace)
    logger.error( "PaymentProcessor", "Payment failed", e );
    // Or just the exception
    logger.error( "PaymentProcessor", e );
    throw e;
}
```

## Handling Missing Loggers

If you request a logger that doesn't exist, `getLog()` throws an exception. This is a good thing - you want to know immediately if your logging config is wrong, not discover missing logs in production.

If you need to support different environments where the logger might not be configured, check first:

```cfml
config = getPageContext().getConfig();
logNames = config.getLogNames();

if ( arrayContains( logNames, "payment" ) ) {
    paymentLog = config.getLog( "payment" );
} else {
    // Fall back to application log (always exists)
    paymentLog = config.getLog( "application" );
}
```

## Multiple Loggers

Just like you might use different log files in CFML for different purposes, you can pass multiple loggers to your Java class:

```cfml
config = getPageContext().getConfig();
auditLog = config.getLog( "audit" );
errorLog = config.getLog( "error" );

processor = createObject( "java", "com.mycompany.Processor", jarPath )
    .init( auditLog, errorLog );
```

Your Java constructor would then accept both:

```java
public Processor( Log auditLog, Log errorLog ) {
    this.auditLog = auditLog;
    this.errorLog = errorLog;
}
```
