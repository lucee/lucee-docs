<!--
{
  "title": "Query Execution in Lucee",
  "id": "query-execution-recipe",
  "categories": [
    "database",
    "query",
    "performance",
    "best-practices"
  ],
  "description": "Complete guide to executing database queries in Lucee with performance comparisons and best practices",
  "keywords": [
    "cfquery",
    "queryExecute",
    "Query",
    "database",
    "parameters",
    "performance",
    "SQL",
    "prepared statements"
  ],
  "related": [
    "tag-syntax",
    "tag-queryparam",
    "tag-query",
    "function-queryexecute"
  ]
}
-->

# Query Execution

Lucee provides multiple ways to execute database queries, each with different syntax styles, performance characteristics, and use cases. This comprehensive guide covers all approaches from simple queries to complex parameterized statements, including performance analysis and best practices.

## Three Ways to Execute Queries in Lucee

1. **cfquery** - Traditional tag-based approach with flexible syntax
2. **queryExecute** - Modern functional approach  
3. **new Query()** - Object-oriented approach with rich metadata

## Quick Start - Simple Query

Let's start with the most basic database query using [[tag-query]]. Lucee supports multiple tag syntaxes in script - for complete details on tag syntax options, see the [[tag-syntax]].

### Function Syntax (Recommended for Scripts)

```javascript
cfquery(name="users", datasource="myDB", sql="SELECT * FROM users");
dump(users);
```

### Migration Syntax (Alternative Script Style)

```javascript
query name="users" datasource="myDB" sql="SELECT * FROM users";
dump(users);
```

### Traditional Tag Syntax (For Mixed HTML/CFML)

```html
<cfquery name="users" datasource="myDB">
    SELECT * FROM users
</cfquery>
<cfdump var="#users#">
```

## Adding Parameters - Security First

**Never concatenate user input directly into SQL strings!** Always use parameters to prevent SQL injection attacks.

### Simple Array Parameters

When you have positional parameters (using `?` placeholders):

```javascript
cfquery(
    name="userById", 
    datasource="myDB", 
    sql="SELECT * FROM users WHERE id = ?", 
    params=[123]
);
```

### Named Parameters - Simple Values

For named parameters (using `:paramName` placeholders):

```javascript
cfquery(
    name="userByName", 
    datasource="myDB", 
    sql="SELECT * FROM users WHERE name = :username", 
    params={"username": "John"}
);
```

### Named Parameters - With Type Specification

For better type safety and performance, specify parameter types:

```javascript
cfquery(
    name="userByNameAndAge", 
    datasource="myDB", 
    sql="SELECT * FROM users WHERE name = :username AND age > :minAge", 
    params={
        "username": {
            "value": "John",
            "type": "varchar"
        },
        "minAge": {
            "value": 18,
            "type": "integer"
        }
    }
);
```

### Parameter Reference Styles

Lucee supports two ways to reference parameters in your SQL:

**Positional Parameters (using `?`):**

```javascript
cfquery(
    name="users", 
    datasource="myDB", 
    sql="SELECT * FROM users WHERE department = ? AND salary > ? AND active = ?",
    params=["IT", 50000, true]
);
```

**Named Parameters (using `:paramName`):**

```javascript
cfquery(
    name="users", 
    datasource="myDB", 
    sql="SELECT * FROM users WHERE department = :dept AND salary > :minSal AND active = :status",
    params={
        "dept": "IT",
        "minSal": 50000, 
        "status": true
    }
);
```

Both approaches offer the same security and performance benefits. Choose based on readability and maintainability preferences.

### Complex Parameter Example

Combining different parameter types and approaches:

```javascript
cfquery(
    name="complexSearch", 
    datasource="myDB", 
    sql=`
        SELECT u.*, d.name as department_name 
        FROM users u 
        JOIN departments d ON u.dept_id = d.id 
        WHERE u.name LIKE :searchName 
        AND u.created_date > :startDate 
        AND u.salary BETWEEN :minSalary AND :maxSalary
    `, 
    params={
        "searchName": {
            "value": "%John%",
            "type": "varchar"
        },
        "startDate": {
            "value": "2023-01-01",
            "type": "date"
        },
        "minSalary": {
            "value": 40000,
            "type": "numeric"
        },
        "maxSalary": {
            "value": 100000,
            "type": "numeric"
        }
    }
);
```

### Traditional Tag Approach (cfqueryparam)

```html
<!-- With parameters using cfqueryparam -->
<cfquery name="userById" datasource="myDB">
    SELECT * FROM users 
    WHERE id = <cfqueryparam sqltype="cf_sql_integer" value="#url.id#">
    AND active = <cfqueryparam sqltype="cf_sql_bit" value="1">
</cfquery>
<cfdump var="#userById#">
```

## The Three Query Dialects

All of the following dialects uses the same underlying code path, the alternatives are CFML wrappers around the [[tag-query]] tag.

Lucee offers three distinct approaches to execute queries, each with unique characteristics:

### 1. cfquery - The Traditional Powerhouse

**Syntax Options:**

```javascript
// Function syntax
cfquery(name="result", datasource="myDB", sql="SELECT * FROM table", params=[]);

// Migration syntax  
query name="result" datasource="myDB" sql="SELECT * FROM table" params=[];

// Tag syntax (in .cfm files)
<cfquery name="result" datasource="myDB" sql="SELECT * FROM table" params="#[]#">
```

**Pros:**

- **Fastest performance** - baseline for all comparisons
- **Most mature and stable** - decades of optimization
- **Flexible syntax options** - function, migration, or tag style
- **Extensive parameter support** - arrays, structs, complex types
- **Familiar to all CFML developers**
- **Works in all contexts** (components, pages, scripts)

**Cons:**

- **Tag-style syntax** may feel outdated in modern script-heavy applications
- **Less functional programming friendly** - requires named result variable

**Best for:** High-performance applications, legacy codebases, developers who prefer explicit control

### 2. QueryExecute - The Modern Alternative

**Syntax:**

```luceescript
result = QueryExecute(
    "SELECT * FROM users WHERE id = :id",
    {id: {value: 123, type: "integer"}},
    {
        datasource: "myDB",  // if not configured globally
        returntype: "query"  // optional
    }
);
```

**Pros:**

- **Near-identical performance** to cfquery (minimal 0-2ms overhead)
- **Modern functional style** - returns result directly
- **Clean, readable syntax** - no separate name attribute needed
- **Consistent parameter handling** - always uses same structure
- **Better for functional programming** patterns

**Cons:**

- **Slightly more verbose** for simple queries
- **Less flexible syntax** - only one way to write it
- **Newer addition** - less familiar to some developers

**Best for:** Modern applications, functional programming styles, developers who prefer explicit return values

### 3. new Query() - The Object-Oriented Approach

**Syntax:**

```javascript
queryObj = new Query();
queryObj.setSQL("SELECT * FROM users WHERE id = ?");
queryObj.setDatasource("myDB");
queryObj.setParams([{
    "value": 123,
    "type": "integer"
}]);
result = queryObj.execute().getResult();
```

**Pros:**

- **Object-oriented design** - full OOP capabilities
- **Fluent interface potential** - chainable methods
- **Most flexible for complex scenarios** - dynamic query building
- **Rich result metadata** - execution time, SQL, parameters, etc.
- **Reusable objects** - can modify and re-execute

**Cons:**

- **Additional overhead** - fixed metadata collection cost that's most noticeable on fast queries
- **More verbose syntax** - requires multiple method calls
- **Object creation overhead** - especially for simple queries
- **Complex parameter syntax** - requires struct format
- **Always processes result metadata** - even when not needed

**Best for:** Complex applications with dynamic query building, OOP architectures, scenarios where rich metadata is required, applications with predominantly slower-running queries where the fixed overhead is negligible

## Performance Analysis

Based on comprehensive benchmarks (100 iterations, best of 10 runs):

### Simple Queries (fast execution)

```
cfquery:           baseline (fastest)
queryExecute:      ~identical to cfquery (0-2ms overhead)
new Query():       ~4-5x slower than cfquery*
new Query(reused): ~4-5x slower than cfquery*
```

*Note: This overhead ratio applies to fast queries. For slower queries, the relative impact decreases significantly.

### Parameterized Queries (fast execution)

```
cfquery variants:       baseline (fastest)
queryExecute:           minimal overhead (~1-3ms vs cfquery)
new Query():           ~4-5x slower than cfquery*
new Query(reused):     ~4-5x slower than cfquery*
```

*Note: This overhead ratio applies to fast queries. For slower queries, the relative impact decreases significantly.

### Why new Query() Has Additional Overhead

The new Query() approach has additional overhead because it **always collects comprehensive result metadata**, regardless of whether you need it. This overhead is primarily **additive (fixed cost)**, not multiplicative:

**Fixed overhead includes:**

- **Result metadata collection**:
  - SQL: The executed SQL statement
  - Cached: Whether the query was cached
  - SqlParameters: Array of parameter values
  - RecordCount: Total number of records
  - ColumnList: Comma-separated column names
  - ExecutionTime: Query execution timing
- **Always sets Statement.RETURN_GENERATED_KEYS** before Statement.execute()
- **Object instantiation and method calls**
- **Metadata processing on every execution**

The metadata collection cost remains roughly constant regardless of query complexity, so its relative impact decreases as query execution time increases.

### Key Performance Insights

1. **cfquery and queryExecute perform nearly identically** - choose based on syntax preference
2. **new Query() has fixed overhead** - most noticeable on fast queries, negligible on slow queries
3. **Parameter syntax choice has minimal impact** (1ms difference)
4. **Object reuse helps new Query()** but doesn't eliminate the metadata collection overhead
5. **Query execution time matters** - overhead becomes less significant as queries take longer to run

## Best Practices

### 1. Choose the Right Tool

- **Use cfquery** for maximum performance and familiar syntax
- **Use queryExecute** for modern, functional programming styles  
- **Use new Query()** only when you need OOP features or dynamic query building

### 2. Always Use Parameters

**Never do this:**

```javascript
cfquery(name="unsafe", datasource="myDB", sql="SELECT * FROM users WHERE name = '#form.name#'");
```

**Always do this:**

```javascript
cfquery(name="safe", datasource="myDB", sql="SELECT * FROM users WHERE name = ?", params=[form.name]);
```

**Why parameters are essential:**

- **Security**: Complete protection against SQL injection attacks
- **Performance**: Lucee can cache the query statement and reuse it with different parameter values
- **Type safety**: Explicit type conversion and validation
- **Maintainability**: Cleaner, more readable code

### 3. Parameter Syntax Guidelines

**Equivalent Parameter Approaches:**

These three approaches are functionally equivalent:

**Traditional cfqueryparam (tag syntax):**

```html
<cfquery name="user" datasource="myDB">
    SELECT * FROM users 
    WHERE name = <cfqueryparam sqltype="cf_sql_varchar" value="#form.name#">
</cfquery>
```

**Script params with array (positional):**

```javascript
cfquery(
    name="user", 
    datasource="myDB", 
    sql="SELECT * FROM users WHERE name = ?",
    params=[form.name]
);
```

**Script params with struct (named):**

```javascript
cfquery(
    name="user", 
    datasource="myDB", 
    sql="SELECT * FROM users WHERE name = :username",
    params={"username": form.name}
);
```

**Guidelines:**

- **Use positional arrays** for simple, sequential parameters
- **Use named parameters** for complex queries with many parameters  
- **Add type specification** for better performance and type safety
- **Parameter choice has minimal performance impact** - choose for readability
- **All approaches provide the same security benefits**

## Migration Guide

### From Tag to Script

**Old tag syntax:**

```html
<cfquery name="users" datasource="myDB">
    SELECT * FROM users WHERE department = <cfqueryparam value="#form.dept#" cfsqltype="CF_SQL_VARCHAR">
    AND active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT">
</cfquery>
```

**New script syntax:**

```javascript
cfquery(
    name="users", 
    datasource="myDB", 
    sql="SELECT * FROM users WHERE department = ? AND active = ?",
    params=[form.dept, true]
);
```

## Conclusion

Lucee's query execution options provide flexibility for different programming styles and requirements:

- **cfquery** remains the performance champion with flexible syntax options
- **queryExecute** offers modern, functional programming appeal with near-identical performance (minimal overhead)
- **new Query()** provides OOP capabilities with additional fixed overhead that's most noticeable on fast queries

Choose based on your specific needs: performance requirements, coding style preferences, typical query execution times, and application architecture. For applications with predominantly fast queries, cfquery or queryExecute will provide the best performance. For applications with complex, longer-running queries, the choice can be based more on coding style and feature requirements.

Remember: the most important consideration is **always using parameters** to prevent SQL injection attacks. The performance difference between parameter syntaxes is negligible compared to the security benefits they provide.