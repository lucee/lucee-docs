<!--
{
  "title": "Localmode, how to migrate from Classic to Modern Local Scope Mode",
  "id": "local-scope-migration",
  "categories": ["scopes", "variables", "migration", "server"],
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

Lucee offers two modes for handling unscoped variables in functions: Classic and Modern.

Switching to `localmode=true` (per function or application-wide) dramatically boosts performance, but requires testing.

## Understanding Local Scope Modes

The local scope mode setting defines how unscoped variables are handled in functions:

- **Classic Mode** (CFML default): Unscoped variables go to `variables` scope, unless the key exists in `arguments` or `local`.
- **Modern Mode**: Unscoped variables always go to `local` scope.

## Why Migrate to Modern Mode?

- **Thread Safety**: Variables isolated to function instance - prevents race conditions with shared components
- **Predictable Behavior**: All unscoped variables behave the same way
- **Performance**: Local scope lookups are faster than cascading scope resolution

### Classic Mode Race Condition Example

```cfml
component {
    function createToken(id) {
        token = createUUID();  // Stored in variables scope
        storeToken(id, token);
        return token;
    }
}
```

If this component is in application scope and used concurrently, `token` becomes shared - multiple threads can overwrite each other's values.

## Configuring Local Scope Mode

### Server Level (Lucee Administrator)

Under "Settings > Scope", set "Local scope mode" to "Modern" or "Classic".

### Server Configuration (.CFConfig.json)

```json
{
    "localScopeMode": "modern"
}
```

### Application Level (Application.cfc)

```cfml
this.localMode = "modern"; // or "classic"
```

### Function Level

```cfml
function test() localMode="modern" {
    // Function body
}
```

## Migration Strategy: Using Cascading Write Logging

Switching directly to Modern mode may break existing applications. A safer approach:

1. Enable cascading write logging
2. Fix all unscoped variable occurrences
3. Switch to Modern mode

### Step 1: Enable Cascading Write Logging

Set environment variables or system properties (Lucee 6.2.1.82+):

- `LUCEE_CASCADING_WRITE_TO_VARIABLES_LOG` / `-Dlucee.cascading.write.to.variables.log` - log name for detections
- `LUCEE_CASCADING_WRITE_TO_VARIABLES_LOGLEVEL` / `-Dlucee.cascading.write.to.variables.loglevel` - log level (DEBUG, INFO, WARN, ERROR)

Example:

```
# Environment variables
LUCEE_CASCADING_WRITE_TO_VARIABLES_LOG=application
LUCEE_CASCADING_WRITE_TO_VARIABLES_LOGLEVEL=INFO

# System properties
-Dlucee.cascading.write.to.variables.log=application
-Dlucee.cascading.write.to.variables.loglevel=INFO
```

### Step 2: Analyze Logs and Modify Code

Log entries look like:

```
Variable Scope Cascading Write Detected: The variable [token] is being implicitly written to the variables scope at [MyComponent.cfc:42]. This occurs when no explicit scope (such as local, arguments, or variables) is specified in the assignment.
```

For each occurrence, add explicit scope:

- `variables.token = createUUID();` - if it should remain component-level
- `local.token = createUUID();` - if it should be function-local

### Common Patterns Requiring Attention

#### Component Properties

Properties stored at the component level need explicit `variables` scope:

```cfml
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

Variables local to a function call:

```cfml
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

1. Test your application thoroughly
2. Verify all functionality works correctly
3. Check for unexpected behaviors or errors
4. Ensure no more log entries appear

### Step 4: Disable Logging and Switch to Modern Mode

Once all code is updated and tested:

1. Remove the environment variables or system properties
2. Switch to Modern mode at your preferred configuration level