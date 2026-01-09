<!--
{
  "title": "Lucee Extension Utilities",
  "id": "extension-utilities",
  "since": "5.0",
  "categories": ["extension", "development", "java"],
  "description": "Comprehensive guide to accessing Lucee core utilities when developing extensions",
  "keywords": [
    "Extension",
    "Development",
    "Utilities",
    "CFMLEngine",
    "Java",
    "API"
  ]
}
-->

# Lucee Extension Utilities

When developing Lucee extensions, you have access to the Lucee core engine which provides a comprehensive set of utility classes for various operations. These utilities give you powerful tools to work with data types, databases, files, HTTP requests, and much more.

## Overview

All utilities are accessed through the CFMLEngine instance, providing a consistent API for extension developers. This guide covers the most commonly used utilities and provides practical examples for each.

## Getting Started

All utilities are accessed through the CFMLEngine instance:

```java
CFMLEngine engine = CFMLEngineFactory.getInstance();
PageContext pc = engine.getThreadPageContext();
```

The `PageContext` object (`pc`) is essential for many operations as it provides access to the current request context, configuration, and scopes.

## Available Utilities

### 1. AI Util

**Since:** 6.2  
**Purpose:** Access AI-related functionality and Large Language Model integrations

**Getting the utility:**
```java
AI ai = engine.getAIUtil();
```

**Common Methods:**
```java
// Get available AI model names
String[] models = ai.getModelNames(null);

// Get AI metadata
Struct metadata = ai.getAIMetadata(pc, "mychatgpt", false);
```

**Use Cases:**
- Integrating AI capabilities into extensions
- Creating custom AI-powered tools
- Building AI-enhanced error handling

---

### 2. Creation Util

**Purpose:** Create Lucee-specific data structures (Arrays, Queries, Structs, etc.)

**Getting the utility:**
```java
Creation creator = engine.getCreationUtil();
```

**Common Methods:**
```java
// Create an empty array
Array arr = creator.createArray();

// Create a query with defined columns
Query qry = creator.createQuery(
    new String[] { "firstname", "lastname", "age" }, 
    0,  // initial row count
    "people"  // query name
);

// Create a struct
Struct struct = creator.createStruct();

// Create a component
Component cfc = creator.createComponent(pc, "path.to.Component");

// Create date/time objects
DateTime dt = creator.createDateTime(2024, 1, 15, 14, 30, 0, 0);
```

**Use Cases:**
- Building data structures to return from extension functions
- Creating queries from database results
- Generating complex data types for CFML consumption

---

### 3. Cast Util

**Purpose:** Convert between different data types safely and reliably

**Getting the utility:**
```java
Cast caster = engine.getCastUtil();
```

**Common Methods:**
```java
// Cast to specific types
Query qry = caster.toQuery(object);
Array arr = caster.toArray(object);
Struct struct = caster.toStruct(object);
String str = caster.toString(object);
boolean bool = caster.toBooleanValue(object);
double num = caster.toDoubleValue(object);
int integer = caster.toIntValue(object);

// Generic casting with type name
Object result = caster.to("array", object, false);  // throw exception = false

// Cast to specific types with defaults
String str = caster.toString(object, "defaultValue");
boolean bool = caster.toBoolean(object, false);

// Check if castable
boolean canCast = caster.isCastableTo("array", object);
```

**Use Cases:**
- Safely converting user input to expected types
- Handling data from external sources
- Ensuring type safety in extension functions

---

### 4. Class Util

**Purpose:** Load classes and BIFs (Built-in Functions) from Lucee's internal classloader

**Getting the utility:**
```java
ClassUtil classing = engine.getClassUtil();
```

**Common Methods:**
```java
// Load a class from Lucee's internal classloader
Class<?> cls = classing.loadClass("lucee.runtime.type.StructImpl");
Class<?> cls2 = classing.loadClass("lucee.runtime.type.QueryImpl");

// Load a Built-in Function (BIF)
BIF arrayLen = classing.loadBIF(pc, "lucee.runtime.functions.array.ArrayLen");
BIF structKeyExists = classing.loadBIF(pc, "lucee.runtime.functions.struct.StructKeyExists");

// Invoke the BIF
Object result = arrayLen.invoke(pc, new Object[] { myArray });

// Check if a BIF exists
boolean exists = classing.isBIF("arrayLen");
```

**Use Cases:**
- Reusing Lucee's built-in functionality in extensions
- Loading and instantiating Lucee core classes
- Creating custom function wrappers

**Example - Using ArrayLen BIF:**
```java
Creation creator = engine.getCreationUtil();
ClassUtil classing = engine.getClassUtil();

// Create an array
Array arr = creator.createArray();
arr.append("item1");
arr.append("item2");

// Load and invoke ArrayLen function
BIF arrayLen = classing.loadBIF(pc, "lucee.runtime.functions.array.ArrayLen");
Object length = arrayLen.invoke(pc, new Object[] { arr });

System.out.println("Array length: " + length);  // Output: 2
```

---

### 5. DB Util

**Purpose:** Manage database connections and execute queries

**Getting the utility:**
```java
DBUtil db = engine.getDBUtil();
```

**Common Methods:**
```java
DatasourceConnection dc = null;
try {
    // Get a datasource connection
    dc = db.getDatasourceConnection(pc, "mydatasource", null, null);
    // Or with custom credentials
    dc = db.getDatasourceConnection(pc, "mydatasource", "username", "password");
    
    // Get datasource information
    DataSource ds = dc.getDatasource();
    String connectionString = ds.getConnectionStringTranslated();
    
    // Get JDBC connection
    Connection conn = dc.getConnection();
    
    // Execute queries
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE active = 1");
    
    // Or use prepared statements
    PreparedStatement pstmt = conn.prepareStatement("UPDATE users SET username = ? WHERE id = ?");
    pstmt.setString(1, "newusername");
    pstmt.setInt(2, 123);
    pstmt.executeUpdate();
    
    // Get query as Lucee Query object
    Query luceeQuery = db.toQuery(rs, "myquery", 100);
}
finally {
    // IMPORTANT: Always release connections back to the pool
    if (dc != null) {
        db.releaseDatasourceConnection(pc.getConfig(), dc);
    }
}
```

**Use Cases:**
- Executing database queries from extensions
- Managing connection pooling
- Converting JDBC ResultSets to Lucee Query objects

**Best Practices:**
- Always release connections in a finally block
- Use prepared statements to prevent SQL injection
- Handle exceptions appropriately

---

### 6. Decision Util

**Purpose:** Check data types and make type decisions

**Getting the utility:**
```java
lucee.runtime.util.Decision decision = engine.getDecisionUtil();
```

**Common Methods:**
```java
// Type checking
boolean isArray = decision.isArray(object);
boolean isStruct = decision.isStruct(object);
boolean isQuery = decision.isQuery(object);
boolean isComponent = decision.isComponent(object);
boolean isSimpleValue = decision.isSimpleValue(object);
boolean isNumeric = decision.isNumeric(object);
boolean isBoolean = decision.isBoolean(object);
boolean isDate = decision.isDate(object, true);
boolean isBinary = decision.isBinary(object);

// Castability checks
boolean canCastToArray = decision.isCastableToArray(object);
boolean canCastToNumeric = decision.isCastableToNumeric(object);
boolean canCastToBoolean = decision.isCastableToBoolean(object);

// Special checks
boolean isEmpty = decision.isEmpty(object);
boolean isValid = decision.isValid("email", emailString);
boolean isValid2 = decision.isValid("url", urlString);
```

**Use Cases:**
- Validating input parameters
- Determining appropriate handling for unknown data types
- Implementing type-safe extension functions

**Example:**
```java
public Object myExtensionFunction(PageContext pc, Object input) throws PageException {
    Decision decision = CFMLEngineFactory.getInstance().getDecisionUtil();
    
    if (decision.isArray(input)) {
        // Handle as array
        return processArray((Array) input);
    }
    else if (decision.isQuery(input)) {
        // Handle as query
        return processQuery((Query) input);
    }
    else if (decision.isSimpleValue(input)) {
        // Handle as string/number
        return processSimpleValue(input);
    }
    else {
        throw new ApplicationException("Unsupported input type");
    }
}
```

---

### 7. Exception Util

**Purpose:** Create and manage Lucee exceptions

**Getting the utility:**
```java
Excepton expUtil = engine.getExceptionUtil();
```

**Common Methods:**
```java
// Create different exception types
PageException appEx = expUtil.createApplicationException("Something went wrong!");
PageException dbEx = expUtil.createDatabaseException("Database error occurred");
PageException expEx = expUtil.createExpressionException("Invalid expression");

// Create custom exceptions
PageException customEx = expUtil.createException(
    "MyCustomType",
    "Error message",
    "Detailed information"
);

// Check exception types
boolean isAppException = expUtil.isOfType(Excepton.TYPE_APPLICATION, exception);
boolean isDbException = expUtil.isOfType(Excepton.TYPE_DATABASE, exception);

// Get exception details
String message = expUtil.getMessage(exception);
String detail = expUtil.getDetail(exception);
String type = expUtil.getType(exception);
```

**Common Exception Types:**
- `Excepton.TYPE_APPLICATION` - Application exceptions
- `Excepton.TYPE_DATABASE` - Database exceptions
- `Excepton.TYPE_EXPRESSION` - Expression exceptions
- `Excepton.TYPE_LOCK` - Lock exceptions
- `Excepton.TYPE_SECURITY` - Security exceptions
- `Excepton.TYPE_TEMPLATE` - Template exceptions

**Use Cases:**
- Throwing appropriate exceptions from extension functions
- Creating user-friendly error messages
- Categorizing errors for better handling

---

### 8. HTTP Util

**Purpose:** Make HTTP requests and handle responses

**Getting the utility:**
```java
HTTPUtil http = engine.getHTTPUtil();
```

**Common Methods:**
```java
URL url = new URL("https://api.example.com/data");

// Simple GET request
HTTPResponse response = http.get(
    url,           // URL
    null,          // username
    null,          // password
    -1,            // timeout
    null,          // charset
    null,          // user-agent
    null,          // proxy server
    -1,            // proxy port
    null,          // proxy username
    null,          // proxy password
    null           // headers
);

// Get response content
String content = response.getContentAsString();
byte[] bytes = response.getContentAsByteArray();
int statusCode = response.getStatusCode();
String statusText = response.getStatusText();

// POST request
HTTPResponse postResponse = http.post(
    url,
    null,          // username
    null,          // password
    -1,            // timeout
    null,          // charset
    null,          // user-agent
    null,          // proxy server
    -1,            // proxy port
    null,          // proxy username
    null,          // proxy password
    null,          // headers
    "data=value"   // body
);

// With custom headers
Struct headers = creator.createStruct();
headers.set("Authorization", "Bearer token123");
headers.set("Content-Type", "application/json");

HTTPResponse authResponse = http.get(url, null, null, 5000, null, null, null, -1, null, null, headers);
```

**Use Cases:**
- Integrating with external APIs
- Fetching remote data
- Webhooks and callbacks

---

### 9. HTML Util

**Purpose:** Parse and manipulate HTML content

**Getting the utility:**
```java
HTMLUtil htmlUtil = engine.getHTMLUtil();
```

**Common Methods:**
```java
String html = "<html><body><a href='/page1'>Link1</a><a href='http://example.com'>Link2</a></body></html>";
URL baseURL = new URL("http://mysite.com");

// Extract all URLs from HTML
String[] urls = htmlUtil.getURLS(html, baseURL);

// Escape HTML entities
String escaped = htmlUtil.escapeHTML("<script>alert('xss')</script>");

// Unescape HTML entities
String unescaped = htmlUtil.unescapeHTML("&lt;div&gt;Hello&lt;/div&gt;");
```

**Use Cases:**
- Scraping web content
- Sanitizing user input
- Extracting links from HTML

---

### 10. IO Util

**Purpose:** Input/Output operations and stream handling

**Getting the utility:**
```java
IO io = engine.getIOUtil();
```

**Common Methods:**
```java
// Copy streams
InputStream input = new ByteArrayInputStream("Hello World".getBytes());
OutputStream output = new ByteArrayOutputStream();
io.copy(input, output, true, true);  // closeInput=true, closeOutput=true

// Read stream to string
String content = io.toString(inputStream, "UTF-8");

// Read stream to byte array
byte[] bytes = io.toBytes(inputStream);

// Write string to output stream
io.write(outputStream, "content", "UTF-8", true);  // close=true

// Get reader/writer
Reader reader = io.getReader(inputStream, "UTF-8");
Writer writer = io.getWriter(outputStream, "UTF-8");

// Close resources safely
io.close(inputStream);
io.closeEL(resource);  // Close without throwing exception
```

**Use Cases:**
- Stream processing
- File operations
- Converting between streams and strings/bytes

---

### 11. List Util

**Purpose:** Work with delimited lists (similar to CFML list functions)

**Getting the utility:**
```java
lucee.runtime.util.ListUtil listUtil = engine.getListUtil();
```

**Common Methods:**
```java
String list = "apple,banana,cherry,date";

// Convert list to array
Array arr = listUtil.toArray(list, ",");
Array arrTrim = listUtil.toArrayTrim(",,,first,second,,,third,,,", ",");

// Convert array back to list
String result = listUtil.toList(arr, ";");  // "apple;banana;cherry;date"

// List operations
int len = listUtil.len(list, ",");
String first = listUtil.getAt(list, ",", 1);
String last = listUtil.getLast(list, ",");
boolean contains = listUtil.contains(list, "banana", ",", true);  // case-sensitive

// Find position
int pos = listUtil.find(list, "cherry", ",");

// Modify lists
String appended = listUtil.append(list, "elderberry", ",");
String prepended = listUtil.prepend(list, "apricot", ",");
String deleted = listUtil.deleteAt(list, ",", 2);  // Remove "banana"

// List sorting
String sorted = listUtil.sort(list, "text", "asc", ",");

// Remove duplicates
String unique = listUtil.removeDuplicates(list, ",", false);  // case-insensitive
```

**Use Cases:**
- Processing comma-separated values
- Converting between lists and arrays
- Data manipulation and filtering

---

### 12. Operation Util

**Purpose:** Perform various operations (comparison, math, etc.)

**Getting the utility:**
```java
Operation opUtil = engine.getOperationUtil();
```

**Common Methods:**
```java
// Compare values (Lucee-style comparison)
int cmp = opUtil.compare("false", false);  // Returns 0 (equal)
int cmp2 = opUtil.compare(10, "10");       // Returns 0 (equal in Lucee)
int cmp3 = opUtil.compare("abc", "xyz");   // Returns -1 (abc < xyz)

// Math operations
double sum = opUtil.plus(5, 3);           // 8.0
double diff = opUtil.minus(10, 4);        // 6.0
double product = opUtil.multiply(6, 7);   // 42.0
double quotient = opUtil.divide(15, 3);   // 5.0
double mod = opUtil.modulus(10, 3);       // 1.0
double power = opUtil.exponent(2, 8);     // 256.0

// Increment/Decrement
double inc = opUtil.increment(5);         // 6.0
double dec = opUtil.decrement(5);         // 4.0

// Concatenate
String concat = opUtil.concat("Hello", " World");  // "Hello World"

// Unary operations
double neg = opUtil.negate(5);            // -5.0
```

**Use Cases:**
- Implementing custom operators
- Safe mathematical operations
- Type-aware comparisons

---

### 13. ORM Util

**Purpose:** Work with Object-Relational Mapping functionality

**Getting the utility:**
```java
ORMUtil ormUtil = engine.getORMUtil();
```

**Common Methods:**
```java
// Check if object is ORM entity
boolean isEntity = ormUtil.isEntity(object);

// Check relationships
boolean isRelated = ormUtil.isRelated(entity);

// Get entity information
String entityName = ormUtil.getEntityName(entity);
Component entityCFC = ormUtil.getEntityByCFCName(pc, "User");

// Session management
Object session = ormUtil.getSession(pc);
ormUtil.flush(pc);
ormUtil.closeSession(pc);

// Entity operations
ormUtil.reload(pc, entity);
ormUtil.evict(pc, entity);
```

**Use Cases:**
- Working with Hibernate ORM entities
- Managing ORM sessions
- Entity lifecycle management

---

### 14. Resource Util

**Purpose:** Work with Lucee's Virtual File System (VFS) - supports local files, HTTP, FTP, S3, RAM, etc.

**Getting the utility:**
```java
lucee.runtime.util.ResourceUtil resUtil = engine.getResourceUtil();
```

**Common Methods:**
```java
// Get temp directory
Resource tempDir = resUtil.getTempDirectory();

// Get real resources (create if not exists)
Resource localFile = tempDir.getRealResource("test.txt");
Resource folder = tempDir.getRealResource("myfolder/");

// Access different resource types
Resource httpFile = pc.getConfig().getResource("http://example.com/data.json");
Resource ftpFile = pc.getConfig().getResource("ftp://ftp.example.com/file.txt");
Resource s3File = pc.getConfig().getResource("s3://mybucket/myfile.txt");
Resource ramFile = pc.getConfig().getResource("ram:///temp/data.txt");

// Copy resources
resUtil.copy(httpFile, localFile);

// Move resources
resUtil.moveTo(sourceResource, targetResource);

// Delete operations
resUtil.delete(localFile);                      // Delete file
resUtil.deleteContent(folder, null);            // Delete folder contents
resUtil.deleteEmptyFolders(folder);             // Delete empty subfolders

// Read/Write
String content = resUtil.toString(localFile, "UTF-8");
resUtil.touch(localFile, "Hello World");        // Create or update file

// Get file info
long size = resUtil.size(localFile);
boolean exists = resUtil.exists(localFile);
boolean isFile = resUtil.isFile(localFile);
boolean isDirectory = resUtil.isDirectory(folder);

// Create directories
resUtil.createDirectory(folder, true);          // createParent=true

// Get canonical path
String path = resUtil.getCanonicalPath(localFile);

// List resources
Resource[] files = resUtil.listResources(folder, "*.txt");
```

**Supported Resource Schemes:**
- `file://` - Local file system
- `http://` - HTTP resources
- `https://` - HTTPS resources
- `ftp://` - FTP resources
- `ftps://` - Secure FTP
- `s3://` - Amazon S3
- `ram://` - RAM file system
- `zip://` - ZIP archives
- Custom extensions can add more

**Use Cases:**
- Unified file access across different storage systems
- Reading remote files as easily as local files
- Implementing cloud storage integration

**Example - Download and Process:**
```java
ResourceUtil resUtil = engine.getResourceUtil();

// Download from HTTP and save locally
Resource remoteFile = pc.getConfig().getResource("https://example.com/data.csv");
Resource localFile = resUtil.getTempDirectory().getRealResource("downloaded.csv");

resUtil.copy(remoteFile, localFile);

// Process the file
String csvData = resUtil.toString(localFile, "UTF-8");
```

---

### 15. Strings Util

**Purpose:** String manipulation operations

**Getting the utility:**
```java
Strings stringUtil = engine.getStringUtil();
```

**Common Methods:**
```java
// Remove quotes
String unquoted = stringUtil.removeQuotes("'Hello World'", false);  // Hello World

// Add quotes
String quoted = stringUtil.addQuotes("Hello World");  // "Hello World"

// Case conversion
String upper = stringUtil.ucFirst("hello");    // Hello
String lower = stringUtil.lcFirst("HELLO");    // hELLO

// String operations
boolean isEmpty = stringUtil.isEmpty(str);
boolean isEmpty2 = stringUtil.isEmpty(str, true);  // trim before check

// Generate random strings
String random = stringUtil.randomString(16);

// MD5/Hash
String md5 = stringUtil.md5(input);

// Replace operations
String replaced = stringUtil.replace(original, search, replace, true);  // case-sensitive
```

**Use Cases:**
- String sanitization
- Format conversion
- Random string generation

---

### 16. System Util

**Purpose:** Access system-level information and utilities

**Getting the utility:**
```java
lucee.runtime.util.SystemUtil systemUtil = engine.getSystemUtil();
```

**Common Methods:**
```java
// Get system information
String macAddress = systemUtil.getMacAddress();
String osName = systemUtil.getOSName();
String osVersion = systemUtil.getOSVersion();
int processors = systemUtil.getProcessorCount();

// Memory information
long freeMemory = systemUtil.getFreeMemory();
long totalMemory = systemUtil.getTotalMemory();
long maxMemory = systemUtil.getMaxMemory();

// Environment variables
String envVar = systemUtil.getEnv("PATH");
Properties envProps = systemUtil.getEnv();

// System properties
String javaVersion = systemUtil.getSystemProperty("java.version");
String userHome = systemUtil.getSystemProperty("user.home");

// Execute system commands
String output = systemUtil.execute("ls -la");
```

**Use Cases:**
- System diagnostics
- Environment detection
- License verification based on hardware

---

### 17. Script Engine Factory

**Purpose:** Execute scripting languages (CFML, JavaScript, etc.)

**Getting the utility:**
```java
ScriptEngineFactory scriptEngine = engine.getScriptEngineFactory();
```

**Common Methods:**
```java
// Get script engine
ScriptEngine cfmlEngine = scriptEngine.getScriptEngine();

// Evaluate CFML code
Object result = cfmlEngine.eval("echo('Hello from eval!'); return 42;");

// Evaluate with bindings
Bindings bindings = cfmlEngine.createBindings();
bindings.put("myVar", "value");
Object result2 = cfmlEngine.eval("echo(myVar); return myVar;", bindings);
```

**Use Cases:**
- Dynamic code execution
- Evaluating user-provided expressions
- Creating plugin systems

---

### 18. Template Util

**Purpose:** Work with CFML templates and components

**Getting the utility:**
```java
TemplateUtil templateUtil = engine.getTemplateUtil();
```

**Common Methods:**
```java
// Search for components
Component cfc = templateUtil.searchComponent(
    pc,
    null,                    // page source
    "com.example.MyComponent", // component name
    null,                    // search list
    null,                    // search paths
    false,                   // execute constructor
    false                    // isRealPath
);

// Get current template path
String currentTemplate = templateUtil.getCurrentTemplate(pc);

// Get template source
PageSource pageSource = templateUtil.getPageSource(pc, "/path/to/template.cfm");

// Check if template exists
boolean exists = templateUtil.exists(pc, "/path/to/template.cfm");
```

**Use Cases:**
- Dynamic component loading
- Template introspection
- Custom framework implementations

---

### 19. Zip Util

**Purpose:** Compress and decompress ZIP archives

**Getting the utility:**
```java
ZipUtil zipUtil = engine.getZipUtil();
```

**Common Methods:**
```java
ResourceUtil resUtil = engine.getResourceUtil();

// Get resources
Resource sourceDir = resUtil.getTempDirectory().getRealResource("myfiles/");
Resource zipFile = resUtil.getTempDirectory().getRealResource("archive.zip");
Resource targetDir = resUtil.getTempDirectory().getRealResource("extracted/");

// Create ZIP archive
zipUtil.zip(sourceDir, zipFile, null);  // filter=null (include all)

// Extract ZIP archive
zipUtil.unzip(zipFile, targetDir);

// Add files to existing ZIP
Resource fileToAdd = resUtil.getTempDirectory().getRealResource("newfile.txt");
zipUtil.addFile(zipFile, fileToAdd, "subdir/newfile.txt");

// List ZIP contents
Resource[] entries = zipUtil.getEntries(zipFile);
for (Resource entry : entries) {
    System.out.println(entry.getName());
}
```

**Use Cases:**
- Creating backups
- File compression
- Archive management

---

## Complete Working Example

Here's a complete extension function that demonstrates multiple utilities:

```java
package com.example.lucee.extension;

import lucee.loader.engine.CFMLEngine;
import lucee.loader.engine.CFMLEngineFactory;
import lucee.runtime.PageContext;
import lucee.runtime.exp.PageException;
import lucee.runtime.type.Array;
import lucee.runtime.type.Query;
import lucee.runtime.type.Struct;
import lucee.runtime.util.Cast;
import lucee.runtime.util.Creation;
import lucee.runtime.util.Decision;
import lucee.runtime.util.Excepton;
import lucee.runtime.util.ListUtil;

public class DataProcessor {
    
    /**
     * Process input data and return structured result
     * 
     * @param pc PageContext
     * @param input Input data (can be Array, Query, or String)
     * @param delimiter Delimiter for string input
     * @return Struct with processed results
     * @throws PageException
     */
    public static Struct processData(PageContext pc, Object input, String delimiter) 
            throws PageException {
        
        CFMLEngine engine = CFMLEngineFactory.getInstance();
        Creation creator = engine.getCreationUtil();
        Cast caster = engine.getCastUtil();
        Decision decision = engine.getDecisionUtil();
        Excepton expUtil = engine.getExceptionUtil();
        ListUtil listUtil = engine.getListUtil();
        
        // Create result structure
        Struct result = creator.createStruct();
        Array processedItems = creator.createArray();
        
        try {
            // Handle different input types
            if (decision.isArray(input)) {
                // Process array
                Array arr = caster.toArray(input);
                result.set("inputType", "array");
                result.set("itemCount", arr.size());
                
                for (int i = 1; i <= arr.size(); i++) {
                    Object item = arr.getE(i);
                    processedItems.append(processItem(item));
                }
            }
            else if (decision.isQuery(input)) {
                // Process query
                Query qry = caster.toQuery(input);
                result.set("inputType", "query");
                result.set("itemCount", qry.getRecordcount());
                result.set("columns", qry.getColumnNames());
                
                for (int row = 1; row <= qry.getRecordcount(); row++) {
                    Struct rowData = creator.createStruct();
                    String[] columns = qry.getColumnNames();
                    for (String col : columns) {
                        rowData.set(col, qry.getAt(col, row));
                    }
                    processedItems.append(rowData);
                }
            }
            else if (decision.isSimpleValue(input)) {
                // Process delimited string
                String str = caster.toString(input);
                Array arr = listUtil.toArrayTrim(str, delimiter);
                result.set("inputType", "delimitedString");
                result.set("itemCount", arr.size());
                
                for (int i = 1; i <= arr.size(); i++) {
                    processedItems.append(processItem(arr.getE(i)));
                }
            }
            else {
                throw expUtil.createApplicationException(
                    "Unsupported input type. Expected Array, Query, or String."
                );
            }
            
            result.set("processedItems", processedItems);
            result.set("success", true);
            
        } catch (Exception e) {
            result.set("success", false);
            result.set("error", e.getMessage());
            throw expUtil.createApplicationException(
                "Error processing data: " + e.getMessage()
            );
        }
        
        return result;
    }
    
    private static Object processItem(Object item) {
        // Custom processing logic here
        return item.toString().toUpperCase();
    }
}
```

## Best Practices

### 1. Always Release Resources

```java
// Database connections
DatasourceConnection dc = null;
try {
    dc = db.getDatasourceConnection(pc, "myds", null, null);
    // Use connection
} finally {
    if (dc != null) db.releaseDatasourceConnection(pc.getConfig(), dc);
}

// Streams
InputStream input = null;
try {
    input = new FileInputStream(file);
    // Use stream
} finally {
    if (input != null) io.closeEL(input);
}
```

### 2. Use Appropriate Exception Types

```java
Excepton expUtil = engine.getExceptionUtil();

// For user errors
throw expUtil.createApplicationException("Invalid input provided");

// For database errors
throw expUtil.createDatabaseException("Failed to connect to database");

// For expression errors
throw expUtil.createExpressionException("Invalid expression syntax");
```

### 3. Type Safety

```java
Decision decision = engine.getDecisionUtil();
Cast caster = engine.getCastUtil();

// Check before casting
if (decision.isCastableToArray(input)) {
    Array arr = caster.toArray(input);
    // Safely use array
} else {
    // Handle non-array input
}
```

### 4. Use Virtual File System

```java
// Instead of hardcoding file system paths
Resource file = pc.getConfig().getResource("http://example.com/data.json");

// Works for local, HTTP, FTP, S3, etc.
String content = resUtil.toString(file, "UTF-8");
```

### 5. Leverage Built-in Functions

```java
// Instead of reimplementing functionality
ClassUtil classing = engine.getClassUtil();
BIF arrayLen = classing.loadBIF(pc, "lucee.runtime.functions.array.ArrayLen");
Object length = arrayLen.invoke(pc, new Object[] { myArray });
```

## Common Patterns

### Pattern 1: Input Validation
```java
public static Object myFunction(PageContext pc, Object input) throws PageException {
    CFMLEngine engine = CFMLEngineFactory.getInstance();
    Decision decision = engine.getDecisionUtil();
    Excepton expUtil = engine.getExceptionUtil();
    
    if (!decision.isCastableToArray(input)) {
        throw expUtil.createApplicationException(
            "Input must be an array or array-compatible type"
        );
    }
    
    Cast caster = engine.getCastUtil();
    Array arr = caster.toArray(input);
    
    // Process array...
}
```

### Pattern 2: HTTP API Integration
```java
public static Struct callAPI(PageContext pc, String endpoint, String apiKey) 
        throws PageException {
    
    CFMLEngine engine = CFMLEngineFactory.getInstance();
    Creation creator = engine.getCreationUtil();
    HTTPUtil http = engine.getHTTPUtil();
    Cast caster = engine.getCastUtil();
    
    try {
        URL url = new URL(endpoint);
        
        // Set up headers
        Struct headers = creator.createStruct();
        headers.set("Authorization", "Bearer " + apiKey);
        headers.set("Content-Type", "application/json");
        
        // Make request
        HTTPResponse response = http.get(url, null, null, 5000, null, null, null, -1, null, null, headers);
        
        // Parse JSON response
        String json = response.getContentAsString();
        Object data = caster.to("struct", json, false);
        
        return caster.toStruct(data);
        
    } catch (Exception e) {
        Excepton expUtil = engine.getExceptionUtil();
        throw expUtil.createApplicationException("API call failed: " + e.getMessage());
    }
}
```

### Pattern 3: File Processing
```java
public static void processFiles(PageContext pc, String sourcePath, String targetPath) 
        throws PageException {
    
    CFMLEngine engine = CFMLEngineFactory.getInstance();
    ResourceUtil resUtil = engine.getResourceUtil();
    IO io = engine.getIOUtil();
    
    Resource sourceDir = pc.getConfig().getResource(sourcePath);
    Resource targetDir = pc.getConfig().getResource(targetPath);
    
    // Ensure target directory exists
    resUtil.createDirectory(targetDir, true);
    
    // Process all files
    Resource[] files = resUtil.listResources(sourceDir, "*.txt");
    for (Resource file : files) {
        Resource targetFile = targetDir.getRealResource(file.getName());
        
        // Read, process, and write
        String content = resUtil.toString(file, "UTF-8");
        String processed = content.toUpperCase(); // Example processing
        resUtil.touch(targetFile, processed);
    }
}
```

## Performance Tips

1. **Reuse Util Instances**: Get utility instances once and reuse them
2. **Connection Pooling**: Always use `getDatasourceConnection()` and `releaseDatasourceConnection()`
3. **Stream Processing**: For large files, use streams instead of loading everything into memory
4. **Batch Operations**: Process multiple items together when possible
5. **Resource Cleanup**: Always clean up in finally blocks

## Debugging

### Enable Detailed Logging
```java
// Get logger
Log log = pc.getLog("application");

// Log debug information
log.debug("Extension", "Processing input: " + input);
log.info("Extension", "Operation completed successfully");
log.error("Extension", "Error occurred: " + e.getMessage());
```

### Inspect Objects
```java
// Get system util for debugging
SystemUtil systemUtil = engine.getSystemUtil();

// Log system information
log.debug("System", "OS: " + systemUtil.getOSName());
log.debug("System", "Free Memory: " + systemUtil.getFreeMemory());
```

## Related Documentation

- [Lucee Extension Development Guide](extension-development.md)
- [Database Operations](database-operations.md)
- [Virtual File System](virtual-file-system.md)
- [Exception Handling](exception-handling.md)

## Getting Help

- **Documentation**: [Lucee Documentation](https://docs.lucee.org)
- **Community**: [Lucee Dev Forum](https://dev.lucee.org)
- **Issues**: [Lucee GitHub](https://github.com/lucee/Lucee/issues)
- **Source Code**: Browse Lucee core source for implementation details

## See Also

- [Extension Installation](extension-installation.md)
- [Extension Configuration](extension-configuration.md)
- [Extension Best Practices](extension-best-practices.md)
- [Lucee Core API Documentation](https://javadoc.lucee.org)