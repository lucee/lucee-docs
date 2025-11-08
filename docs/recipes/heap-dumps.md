<!--
{
  "title": "Creating Heap Dumps in Lucee",
  "id": "heap-dumps",
  "since": "5.0",
  "categories": ["troubleshooting", "performance", "memory"],
  "description": "Documentation for creating and analyzing heap dumps in Lucee for memory troubleshooting",
  "keywords": [
    "Heap Dump",
    "Memory",
    "OutOfMemoryError",
    "Troubleshooting",
    "Performance",
    "Debugging",
    "JVM"
  ],
  "related": [
    "performance-monitoring"
  ]
}
-->

# Creating Heap Dumps in Lucee

Heap dumps are essential diagnostic tools for troubleshooting memory issues in Lucee applications. This guide explains what heap dumps are, how to configure automatic generation on memory errors, and how to create them on demand.

## What is a Heap Dump?

A heap dump is a snapshot of all the objects in the Java Virtual Machine (JVM) memory at a specific point in time. It captures:

- All Java objects currently in memory
- Object references and relationships
- Memory allocation details
- Class hierarchies and instances

### When to Use Heap Dumps

Heap dumps are invaluable for diagnosing:

- **OutOfMemoryError issues**: Identify what objects are consuming excessive memory
- **Memory leaks**: Track objects that should have been garbage collected but remain in memory
- **Performance degradation**: Analyze memory usage patterns that may slow down your application
- **Object retention issues**: Discover why certain objects persist longer than expected

### Analyzing Heap Dumps

Once created, heap dumps can be analyzed using tools such as:

- **Eclipse Memory Analyzer (MAT)**: Industry-standard tool for heap dump analysis
- **VisualVM**: Bundled with JDK, provides heap dump browsing and analysis
- **JProfiler**: Commercial profiler with advanced heap analysis features
- **YourKit Java Profiler**: Another commercial option with powerful memory analysis

## Automatic Heap Dump on OutOfMemoryError

The most common use case for heap dumps is capturing the memory state when an OutOfMemoryError occurs. This can be configured through JVM arguments.

### JVM Configuration

Add the following arguments to your JVM startup configuration:

```bash
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/var/lucee/heapdumps/
```

### Configuration by Platform

#### Lucee with Tomcat (Linux/Unix)

Edit your `setenv.sh` file (typically in `{tomcat}/bin/`):

```bash
# Existing CATALINA_OPTS
export CATALINA_OPTS="$CATALINA_OPTS -Xms512m -Xmx2048m"

# Add heap dump configuration
export CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
export CATALINA_OPTS="$CATALINA_OPTS -XX:HeapDumpPath=/var/lucee/heapdumps/"
```

Ensure the dump directory exists and is writable:

```bash
mkdir -p /var/lucee/heapdumps
chown tomcat:tomcat /var/lucee/heapdumps
```

#### CommandBox

Add to your `server.json`:

```json
{
  "jvm": {
    "heapSize": 2048,
    "args": [
      "-XX:+HeapDumpOnOutOfMemoryError",
      "-XX:HeapDumpPath=/path/to/dumps/"
    ]
  }
}
```

Or use CommandBox CLI:

```bash
server set jvm.args="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/path/to/dumps/"
```

### Additional Useful JVM Arguments

```bash
# Generate heap dump on OutOfMemoryError and exit JVM (prevents zombie processes)
-XX:+HeapDumpOnOutOfMemoryError -XX:+ExitOnOutOfMemoryError

# Include additional diagnostic information
-XX:+PrintGCDetails -XX:+PrintGCTimeStamps

# Limit heap dump file size (in MB) - useful for very large heaps
-XX:HeapDumpSegmentSize=1024m
```

### Important Considerations

- **Disk Space**: Heap dumps can be as large as your maximum heap size. Ensure adequate disk space (at least 1.5x your `-Xmx` value)
- **Performance Impact**: Creating a heap dump causes a "stop-the-world" pause. The application will be unresponsive during dump creation
- **File Permissions**: Ensure the JVM process has write permissions to the dump directory
- **One Dump Per Error**: By default, only one heap dump is created per OutOfMemoryError. Subsequent errors won't generate new dumps unless you restart

## Creating Heap Dumps On Demand

Sometimes you need to capture a heap dump proactively without waiting for an OutOfMemoryError. Lucee provides a programmatic way to create heap dumps at any time.

### Implementation

Here's a complete implementation for creating and managing heap dumps:

```javascript
	setting requesttimeout=10000;

	HeapDumper=createObject('java','lucee.commons.surveillance.HeapDumper');
	ResourceUtil=createObject('java','lucee.commons.io.res.util.ResourceUtil');

	dir=getDirectoryFromPath(getCurrentTemplatePath())&"dumps/";
	urlDir=getDirectoryFromPath(cgi.script_name);

	function createIt() {
		var dest=dir&dateTimeFormat(now(),"yyyy-mm-dd-HH-nn-ss")&".hprof";
		var res=ResourceUtil.toResourceNotExisting(getPageContext(), dest);
		HeapDumper.dumpTo(res, true);

		var zip=res&".zip";
		zip action="zip" file=zip overwrite=true {
			zipparam source=res entrypath="dump.hprof";
		}
		fileDelete(res);
	}

	if(!directoryExists(dir)) directoryCreate(dir);


	// create
	if(!isNull(url.create)) {
		createIt();
		location url="#cgi.script_name#" addtoken=false;
	}
	else if(!isNull(url.delete)) {
		fileDelete(dir&url.delete);
		location url="#cgi.script_name#" addtoken=false;
	}
	else if(!isNull(url.get)) {
		content file=dir&url.get type="application/zip";
		abort;
	}
	list=directoryList(path:dir,listInfo:'query',filter:"*.hprof.zip")

echo('<h1>Heap Dump</h1>');
loop query=list {
  echo('<a href="#cgi.script_name#?get=#list.name#">#list.name# (#int(list.size/1000)/1000#mb)</a><br>');
  echo('<a href="#cgi.script_name#?delete=#list.name#">[delete]</a><br>');
}

echo('<a href="?create=1">Create Heap Dump</a>');
```

### How It Works

1. **Java Integration**: The code uses Lucee's built-in `HeapDumper` class to access JVM heap dump functionality
2. **Timestamped Files**: Each dump is named with a timestamp for easy identification
3. **Automatic Compression**: Dumps are automatically compressed to ZIP format, saving significant disk space
4. **Web Interface**: Provides a simple UI to create, download, and delete heap dumps (never expose on production environments)
5. **Live Objects Only**: The `dumpTo(res, true)` parameter ensures only reachable (live) objects are included, reducing file size

### Security Considerations

This heap dump interface should be protected in production environments:

```javascript

    // Add authentication
    if(!structKeyExists(session, "isAdmin") || !session.isAdmin) {
        writeOutput("Access Denied");
        abort;
    }
    
    // Restrict by IP address
    allowedIPs = "127.0.0.1,192.168.1.100";
    if(!listFind(allowedIPs, cgi.remote_addr)) {
        writeOutput("Access Denied - Unauthorized IP");
        abort;
    }

```

### Scheduled Heap Dumps

You can automate heap dump creation using Lucee's scheduler for periodic memory analysis:

```javascript

    // Create a scheduled task for nightly heap dumps
    schedule action="update"
        task="NightlyHeapDump"
        operation="HTTPRequest"
        url="http://localhost:8888/admin/heap-dump.cfm?create=1"
        startdate="#now()#"
        starttime="02:00 AM"
        interval="daily";

```

## Best Practices

### When to Create Heap Dumps

- **Before Issues Occur**: Create baseline dumps during normal operation for comparison
- **During High Memory Usage**: When monitoring shows increasing memory consumption
- **Performance Degradation**: When response times increase without obvious cause
- **Before/After Deployments**: Compare memory profiles to identify regressions
- **Regular Intervals**: For trending analysis in production environments

### Heap Dump Management

- **Storage**: Keep dumps in a dedicated directory with adequate disk space
- **Retention**: Implement automatic cleanup of old dumps to manage disk usage
- **Compression**: Always compress dumps to save disk space (typically 10-20x smaller)
- **Naming**: Use consistent naming with timestamps for easy identification
- **Documentation**: Log why each dump was created for future reference

### Performance Impact

Creating a heap dump has performance implications:

- **Application Pause**: All application threads are paused during dump creation
- **Duration**: Can take seconds to minutes depending on heap size
- **I/O Impact**: Significant disk I/O during write operation
- **Recommendation**: Create dumps during low-traffic periods when possible

### Analyzing Dumps

Steps for effective heap dump analysis:

1. **Download** the dump file to your local machine
2. **Open** in Eclipse MAT or similar tool
3. **Review Leak Suspects**: Most tools automatically identify potential memory leaks
4. **Check Dominators**: See which objects consume the most memory
5. **Compare Dumps**: Compare multiple dumps to identify growing objects
6. **Focus on Application Objects**: Filter out framework and JVM objects to find your code's issues

## Troubleshooting

### Common Issues

**Heap dump file is too large**

- Use the `true` parameter in `HeapDumper.dumpTo(res, true)` to include only live objects
- Enable compression in your implementation
- Consider using `-XX:HeapDumpSegmentSize` JVM argument for very large heaps

**Permission denied errors**

- Ensure the dump directory exists and is writable
- Check file system permissions for the Lucee/Java process user
- On Linux, verify SELinux policies if applicable

**OutOfMemoryError when creating dump**

- Creating a dump requires additional memory
- Ensure you have adequate memory overhead (don't set `-Xmx` too close to system limits)
- Consider reducing heap size or adding physical memory

**Dumps not created on OutOfMemoryError**

- Verify JVM arguments are properly set
- Check that only one dump per error is generated by default
- Review JVM logs for errors during dump creation

## Additional Resources

- **Eclipse MAT Tutorial**: [https://wiki.eclipse.org/MemoryAnalyzer](https://wiki.eclipse.org/MemoryAnalyzer)
- **Java Memory Management**: Understanding heap structure and garbage collection
- **Lucee Performance Tuning**: Related performance monitoring and optimization techniques
