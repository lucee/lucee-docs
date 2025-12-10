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
    "function-queryexecute",
    "recommended-settings"    
  ]
}
-->

# Query Execution

Three ways to execute queries:

1. **cfquery** - Tag or function syntax, best performance
2. **queryExecute()** - Functional style, returns result directly
3. **new Query()** - OOP style, always returns metadata (has overhead)

## Query Metadata

When you use a `result` attribute (or `new Query()` which always sets it), you get metadata about the query execution:

- `SQL` - the executed SQL statement
- `Cached` - whether the query was cached
- `SqlParameters` - array of parameter values
- `RecordCount` - total number of records
- `ColumnList` - comma-separated column names
- `ExecutionTime` - query execution timing

## Quick Start

Basic [[tag-query]] examples. See [[tag-syntax]] for all tag syntax options.

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

## Parameters

**Never concatenate user input directly into SQL strings!** Always use parameters to prevent SQL injection.

### Positional Parameters (using `?`)

```javascript
cfquery(
    name="userById",
    datasource="myDB",
    sql="SELECT * FROM users WHERE id = ?",
    params=[123]
);
```

### Named Parameters (using `:paramName`)

```javascript
cfquery(
    name="userByName",
    datasource="myDB",
    sql="SELECT * FROM users WHERE name = :username",
    params={"username": "John"}
);
```

### Named Parameters with Type Specification

For better type safety and performance:

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

### Positional vs Named

Positional (using `?`):

```javascript
cfquery(
    name="users",
    datasource="myDB",
    sql="SELECT * FROM users WHERE department = ? AND salary > ? AND active = ?",
    params=["IT", 50000, true]
);
```

Named (using `:paramName`):

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

Both provide identical security and performance.

### Complex Example

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

### cfqueryparam (Tag Syntax)

```html
<cfquery name="userById" datasource="myDB">
    SELECT * FROM users 
    WHERE id = <cfqueryparam sqltype="cf_sql_integer" value="#url.id#">
    AND active = <cfqueryparam sqltype="cf_sql_bit" value="1">
</cfquery>
<cfdump var="#userById#">
```

## Query Dialects

All dialects use the same underlying code path - alternatives are wrappers around [[tag-query]].

### cfquery

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

### queryExecute

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

### new Query()

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
- **Always returns result metadata** - even when not required

## Performance

Benchmarks (100 iterations, best of 10 runs):

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

### Key Insights

- cfquery and queryExecute perform nearly identically
- new Query() overhead is fixed - negligible on slow queries
- Parameter syntax choice has minimal impact (~1ms)
- Object reuse helps but doesn't eliminate metadata overhead

## Best Practices

### Always Use Parameters

**Never do this:**

```javascript
cfquery(name="unsafe", datasource="myDB", sql="SELECT * FROM users WHERE name = '#form.name#'");
```

**Always do this:**

```javascript
cfquery(name="safe", datasource="myDB", sql="SELECT * FROM users WHERE name = ?", params=[form.name]);
```

**Why parameters are essential:**

- **Security** - complete protection against SQL injection attacks
- **Performance** - Lucee caches the statement and reuses it with different values
- **Type safety** - explicit type conversion and validation
- **Maintainability** - cleaner, more readable code

### Equivalent Approaches

```html
<cfquery name="user" datasource="myDB">
    SELECT * FROM users 
    WHERE name = <cfqueryparam sqltype="cf_sql_varchar" value="#form.name#">
</cfquery>
```

Script with array:

```javascript
cfquery(name="user", datasource="myDB", sql="SELECT * FROM users WHERE name = ?", params=[form.name]);
```

Script with struct:

```javascript
cfquery(name="user", datasource="myDB", sql="SELECT * FROM users WHERE name = :username", params={"username": form.name});
```

Use positional for simple queries, named for complex ones. All provide identical security.

## Migration: Tag to Script

```html
<cfquery name="users" datasource="myDB">
    SELECT * FROM users WHERE department = <cfqueryparam value="#form.dept#" cfsqltype="CF_SQL_VARCHAR">
</cfquery>
```

Becomes:

```javascript
cfquery(name="users", datasource="myDB", sql="SELECT * FROM users WHERE department = ?", params=[form.dept]);
```
