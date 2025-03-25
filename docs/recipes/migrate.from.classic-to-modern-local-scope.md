<!--
{
  "title": "Migrating from Classic to Modern Local Scope Mode",
  "id": "local-scope-migration",
  "categories": ["scopes", "variables", "migration"],
  "description": "Guide for safely migrating your Lucee application from classic to modern local scope mode",
  "keywords": [
    "local scope",
    "variables",
    "migration",
    "scope mode",
    "classic mode",
    "modern mode"
  ]
}
-->

# Migrating from Classic to Modern Local Scope Mode

Lucee offers two different modes for managing unscoped variables within functions: Classic and Modern. This document explains the differences between these modes and provides a structured approach for migrating from Classic to Modern mode.

## Understanding Local Scope Modes

The "Local scope mode" setting defines how variables with no explicit scope are handled within functions:

* **Classic Mode (CFML Default)**: Unscoped variables are stored in the variables scope, unless the key already exists in one of the function's local scopes (arguments or local).
* **Modern Mode**: Unscoped variables are always stored in the local scope, regardless of whether they exist elsewhere.

## Why Migrate to Modern Mode?

Modern mode offers several advantages:

1. **Thread Safety**: Variables are isolated to the function instance, preventing race conditions when component instances are shared across requests.
2. **Predictable Behavior**: All unscoped variables behave the same way, making code more intuitive and easier to maintain.
3. **Performance**: Local scope lookups are typically faster than cascading scope resolution.

### Classic Mode Race Condition Example

Consider this component when running in Classic mode:

```javascript
component {
    function createToken(id) {
        token = createUUID();  // Stored in variables scope
        storeToken(id, token);
        return token;
    }
}
```

If this component is stored in application scope and used across multiple concurrent requests, `token` becomes a shared variable. This creates a race condition where multiple threads could overwrite each other's values.

## Configuring Local Scope Mode

Local scope mode can be configured at several levels:

### 1. Server Level (Lucee Administrator)

Under "Settings > Scope", set "Local scope mode" to either "Modern" or "Classic".

### 2. Server Configuration (.CFConfig.json)

```json
{
    "localScopeMode": "modern"
}
```

Or:

```json
{
    "localScopeMode": "classic"
}
```

### 3. Application Level (Application.cfc)

```javascript
this.localMode = "modern"; // or "classic"
```

### 4. Function Level

```javascript
function test() localMode="modern" {
    // Function body
}
```

## Migration Strategy: Using Cascading Write Logging

Switching directly to Modern mode may break existing applications that rely on Classic behavior. A safer approach is to:

1. Enable variable scope cascading write logging
2. Identify and fix all occurrences of unscoped variables
3. Switch to Modern mode

### Step 1: Enable Cascading Write Logging

Set the following environment variables or system properties (This setting only applies to Lucee 6.2.1.82 and above):

**Environment Variable:** `LUCEE_CASCADING_WRITE_TO_VARIABLES_LOG`
**System Property:** `-Dlucee.cascading.write.to.variables.log`

This specifies the log name where cascading write detections will be recorded.

You can also customize the log level (default is DEBUG):

**Environment Variable:** `LUCEE_CASCADING_WRITE_TO_VARIABLES_LOGLEVEL`
**System Property:** `-Dlucee.cascading.write.to.variables.loglevel`

Valid log levels include: DEBUG, INFO, WARN, ERROR.

Example configuration:

```
# Environment variables
LUCEE_CASCADING_WRITE_TO_VARIABLES_LOG=application
LUCEE_CASCADING_WRITE_TO_VARIABLES_LOGLEVEL=INFO

# System properties
-Dlucee.cascading.write.to.variables.log=application
-Dlucee.cascading.write.to.variables.loglevel=INFO
```

### Step 2: Analyze Logs and Modify Code

Monitor your application logs for entries like:

```
Variable Scope Cascading Write Detected: The variable [token] is being implicitly written to the variables scope at [MyComponent.cfc:42]. This occurs when no explicit scope (such as local, arguments, or variables) is specified in the assignment.
```

For each occurrence, decide whether to:

1. **Add explicit variables scope** (if the variable should remain in the component's variables scope):

    ```javascript
    variables.token = createUUID();
    ```

2. **Add explicit local scope** (if the variable should be function-local):

    ```javascript
    local.token = createUUID();
    ```

### Common Patterns Requiring Attention

#### Component Properties

Properties meant to be stored at the component level need an explicit variables scope:

```javascript
// Before
function init(datasourceName) {
    datasourceName = arguments.datasourceName;
}

// After
function init(datasourceName) {
    variables.datasourceName = arguments.datasourceName;
}
```

#### Local Counters and Temporary Variables

Variables that should be local to a function call:

```javascript
// Before
function processItems(items) {
    result = [];
    for(i=1; i <= arrayLen(items); i++) {
        processed = processItem(items[i]);
        arrayAppend(result, processed);
    }
    return result;
}

// After
function processItems(items) {
    local.result = [];
    for(local.i=1; local.i <= arrayLen(items); local.i++) {
        local.processed = processItem(items[local.i]);
        arrayAppend(local.result, local.processed);
    }
    return local.result;
}
```

### Step 3: Test Thoroughly

After updating your code:

1. Test your application thoroughly
2. Verify that all functionality works correctly
3. Look for unexpected behaviors or errors
4. Make sure you no longer get any log entries 

### Step 4: Disable Logging and Switch to Modern Mode

Once all code has been updated and tested:

1. Disable the cascading write logging by removing the environment variables or system properties:

   ```
   # Remove environment variables
   unset LUCEE_CASCADING_WRITE_TO_VARIABLES_LOG
   unset LUCEE_CASCADING_WRITE_TO_VARIABLES_LOGLEVEL
   
   # Or remove system properties from startup configuration
   # -Dlucee.cascading.write.to.variables.log
   # -Dlucee.cascading.write.to.variables.loglevel
   ```

2. Switch to Modern mode at your preferred configuration level (server, application, or function).

## Conclusion

Migrating to Modern mode improves thread safety and code predictability, but requires careful examination of existing code. Using cascading write logging helps identify potential issues before they become problems, allowing for a smooth transition.