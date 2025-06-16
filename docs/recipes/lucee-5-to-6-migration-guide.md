<!--
{
  "title": "Lucee 5 to 6 Migration Guide",
  "id": "lucee-5-to-6-migration-guide",
  "categories": ["migration", "lucee"],
  "since": "6.0",
  "description": "Comprehensive guide for migrating from Lucee 5 to Lucee 6, addressing breaking changes and compatibility issues",
  "keywords": [
    "Migration",
    "Lucee 5",
    "Lucee 6",
    "Breaking Changes",
    "Compatibility",
    "DeserializeJSON",
    "Query Parameters",
    "Precise Math"
  ]
}
-->

# Lucee 5 to 6 Migration Guide

Lucee 6 introduces several breaking changes that may affect existing applications. This guide provides a systematic approach to identify and resolve compatibility issues during migration from Lucee 5 to Lucee 6.

## Migration Strategy Overview

The recommended approach for migrating to Lucee 6 involves:

1. **Enable compatibility mode**: Use environment variables to maintain backward compatibility temporarily
2. **Enable warning logs**: Set logging to capture deprecated functionality usage
3. **Identify issues**: Run the application to collect warning logs
4. **Fix systematically**: Address each identified issue by updating code
5. **Verify changes**: Test application without compatibility settings
6. **Remove compatibility flags**: Disable environment variables once all issues are resolved

This systematic approach allows efficient identification and resolution of all compatibility issues through log analysis rather than manual code inspection.

## Breaking Changes and Solutions

### 1. DeserializeJSON Empty String Handling

**Issue**: Lucee 6's `DeserializeJSON()` function no longer accepts empty strings as valid input. In Lucee 5, `DeserializeJSON("")` would return an empty string, but in Lucee 6 this throws an exception: "input value cannot be empty string."

#### Temporary Solution

Set the environment variable to enable backward compatibility:
```
LUCEE_DESERIALIZEJSON_ALLOWEMPTY=true
```

#### Identifying Issues

1. Set application logging to WARN level
2. Run your application to generate warning logs
3. Look for log entries like:
```
Deprecated functionality used at [...]. An empty string was passed as a value to the function DeserializeJSON.;
```

#### Permanent Fix

Update code to handle empty strings before calling `DeserializeJSON()`:

**Before (Lucee 5):**
```cfml
<cfset result = DeserializeJSON(someVariable)>
```

**After (Lucee 6):**
```cfml
<cfset result = len(trim(someVariable)) ? DeserializeJSON(someVariable) : "">
```

#### Verification Steps

1. Update all identified instances
2. Test with appropriate scenarios
3. Verify no warning logs are generated
4. Set `LUCEE_DESERIALIZEJSON_ALLOWEMPTY=false` and confirm application functions correctly

### 2. Query Parameter Empty String to NULL Conversion

**Issue**: The `<cfqueryparam>` tag and `params` attribute in `<cfquery>` no longer convert empty strings to NULL values for various SQL types. In Lucee 5, empty strings were implicitly converted to NULL for many data types.

#### Affected SQL Types

- BIGINT, BIT
- BLOB, CLOB
- DECIMAL, NUMERIC
- DOUBLE, FLOAT
- BINARY types (VARBINARY, LONGVARBINARY, BINARY)
- REAL
- TINYINT, SMALLINT, INTEGER
- DATE, TIME, TIMESTAMP

#### Temporary Solution

Set the environment variable to enable backward compatibility:
```
LUCEE_QUERY_ALLOWEMPTYASNULL=true
```

#### Identifying Issues

1. Set datasource logging to WARN level
2. Run your application to generate warning logs
3. Look for log entries like:
```
Deprecated functionality used at [...]. An empty string was passed as a value for type [TYPE]. Currently, this is treated as null, but it will be rejected in future releases.
```

#### Permanent Fix

Explicitly handle empty strings in query parameters:

**Before (Lucee 5):**
```cfml
<cfquery name="myQuery" datasource="myDS">
    SELECT * FROM users 
    WHERE id = <cfqueryparam value="#userID#" cfsqltype="cf_sql_integer">
</cfquery>
```

**After (Lucee 6):**
```cfml
<cfquery name="myQuery" datasource="myDS">
    SELECT * FROM users 
    WHERE id = <cfqueryparam value="#len(trim(userID)) ? userID : javaCast('null', '')#" cfsqltype="cf_sql_integer" null="#not len(trim(userID))#">
</cfquery>
```

For dates:
```cfml
<cfquery name="myQuery" datasource="myDS">
    SELECT * FROM events 
    WHERE event_date = <cfqueryparam value="#isDate(eventDate) ? eventDate : javaCast('null', '')#" cfsqltype="cf_sql_timestamp" null="#not isDate(eventDate)#">
</cfquery>
```

#### Verification Steps

1. Categorize issues by SQL type
2. Update all identified query parameters
3. Test all modified queries
4. Verify no warning logs are generated
5. Set `LUCEE_QUERY_ALLOWEMPTYASNULL=false` and confirm application functions correctly

### 3. Precise Math Performance Impact

**Issue**: Lucee 6 switched from using `double` as the default numeric type to using `BigDecimal`. While BigDecimal provides higher precision, it introduces significant performance overhead for mathematical calculations.

#### Temporary Solution

Set the environment variable to maintain double-based calculations globally:
```
LUCEE_PRECISE_MATH=false
```

#### Identifying Performance Issues

1. Perform profiling to identify performance-critical code paths
2. Analyze areas with heavy mathematical calculations
3. Benchmark performance with and without precise math
4. Focus on loops, financial calculations, and data processing operations


#### Verification Steps

1. Document all locations where precise math is disabled and rationale
2. Establish performance benchmarks
3. Verify precision-critical calculations maintain accuracy
4. Test application without global `LUCEE_PRECISE_MATH` setting
5. Run performance tests under various scenarios


## Environment Variables Reference

| Variable | Purpose | Default | Migration Phase |
|----------|---------|---------|-----------------|
| `LUCEE_DESERIALIZEJSON_ALLOWEMPTY` | Allow empty strings in DeserializeJSON | false | Temporary compatibility |
| `LUCEE_QUERY_ALLOWEMPTYASNULL` | Convert empty strings to NULL in queries | false | Temporary compatibility |
| `LUCEE_PRECISE_MATH` | Use BigDecimal for all calculations | true | Performance optimization |

## Logging Configuration

Set appropriate logging levels to capture compatibility warnings:


## Testing Strategy

### Unit Tests

Create tests for edge cases introduced by breaking changes:

```cfml
<cfcomponent extends="TestCase">
    <cffunction name="testDeserializeJSONEmpty">
        <cfset var result = "">
        <cfset var emptyString = "">
        
        <!-- Test empty string handling -->
        <cfset result = len(trim(emptyString)) ? DeserializeJSON(emptyString) : "">
        <cfset assertEquals("", result)>
    </cffunction>
    
    <cffunction name="testQueryParamNull">
        <cfset var userID = "">
        
        <!-- Test NULL parameter handling -->
        <cfquery name="testQuery" datasource="test">
            SELECT COUNT(*) as cnt FROM users 
            WHERE id = <cfqueryparam value="#len(trim(userID)) ? userID : javaCast('null', '')#" 
                      cfsqltype="cf_sql_integer" 
                      null="#not len(trim(userID))#">
        </cfquery>
        
        <cfset assertTrue(isDefined("testQuery.cnt"))>
    </cffunction>
</cfcomponent>
```