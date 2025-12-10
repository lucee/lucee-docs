<!--
{
  "title": "Lucee MSSQL Modern Mode",
  "id": "mssql-modern-mode",
  "since": "5.3.8.169",
  "categories": ["database", "mssql"],
  "description": "How to enable and use MSSQL modern mode in Lucee for proper handling of RAISERROR exceptions and complex T-SQL batches",
  "keywords": [
    "mssql",
    "sql server",
    "raiserror",
    "deferred exceptions",
    "modern mode",
    "jdbc",
    "stored procedures",
    "t-sql"
  ],
  "related": [
    "database-connection-management",
    "datasource-configuration",
    "tag-query",
    "function-queryexecute",
    "tag-storedproc"
  ]
}
-->

# MSSQL Modern Mode

Microsoft SQL Server's JDBC driver has unique behaviour that differs from other database drivers. Lucee provides a "modern mode" that properly handles these quirks, particularly around deferred exceptions like RAISERROR.

## The Problem

The MSSQL JDBC driver queues certain exceptions (like those from RAISERROR) and only surfaces them when you iterate through all result sets. Without proper handling, these exceptions can be silently ignored, leading to:

- RAISERROR statements not throwing exceptions in CFML
- Stored procedure errors going undetected
- Silent data corruption when validation errors are missed

### Example of the Problem

```sql
-- SQL Server stored procedure
CREATE PROCEDURE ValidateAndInsert @value INT
AS
BEGIN
    IF @value < 0
        RAISERROR('Value cannot be negative!', 16, 1);

    INSERT INTO MyTable (value) VALUES (@value);
END
```

Without modern mode enabled, calling this procedure with a negative value might:

1. Execute the RAISERROR (queueing the exception)
2. Still execute the INSERT
3. Return successfully to CFML without throwing an error

## Enabling Modern Mode

Enable MSSQL modern mode by setting a system property or environment variable:

### System Property

```bash
-Dlucee.datasource.mssql.modern=true
```

### Environment Variable

```bash
LUCEE_DATASOURCE_MSSQL_MODERN=true
```

### In Docker

```dockerfile
ENV LUCEE_DATASOURCE_MSSQL_MODERN=true
```

Or via JVM args:

```dockerfile
ENV LUCEE_JAVA_OPTS="-Dlucee.datasource.mssql.modern=true"
```

## What Modern Mode Does

When enabled, Lucee uses a specialised execution path for MSSQL queries that:

1. **Iterates through all result sets** - Ensures deferred exceptions surface by calling `getMoreResults()` until no more results exist
2. **Properly handles RAISERROR** - Exceptions with severity 10+ are thrown as CFML exceptions
3. **Supports complex T-SQL batches** - Multiple statements, OUTPUT clauses, and interleaved results are handled correctly

## When to Use Modern Mode

Enable modern mode if your application:

- Uses stored procedures with RAISERROR or THROW statements
- Relies on T-SQL validation that raises errors
- Uses complex batches with multiple statements
- Uses INSERT/UPDATE with OUTPUT clauses
- Needs reliable error handling from SQL Server

## Code Examples

### RAISERROR Handling

```javascript
// With modern mode enabled, this will throw an exception
try {
    queryExecute("
        SELECT 1 as result;
        RAISERROR('Something went wrong!', 16, 1);
    ", {}, { datasource: "mssql" });
} catch (database e) {
    writeOutput("Caught error: " & e.message);
    // Output: "Caught error: Something went wrong!"
}
```

### Stored Procedure Errors

```javascript
// Stored procedure with validation
try {
    queryExecute("EXEC ValidateAndInsert @value = :val",
        { val: -5 },
        { datasource: "mssql" }
    );
} catch (database e) {
    writeOutput("Validation failed: " & e.message);
}
```

### INSERT with OUTPUT Clause

```javascript
// Modern mode properly handles OUTPUT clause results
var result = queryExecute("
    INSERT INTO Users (name, email)
    OUTPUT INSERTED.id, INSERTED.created_at
    VALUES (:name, :email)
", {
    name: "John Doe",
    email: "john@example.com"
}, {
    datasource: "mssql",
    result: "info"
});

// result contains the OUTPUT data
writeOutput("New user ID: " & result.id);
writeOutput("Generated key: " & info.generatedKey);
```

## RAISERROR Severity Levels

SQL Server's RAISERROR uses severity levels to indicate error type:

| Severity | Behaviour |
|----------|-----------|
| 0-9 | Informational - becomes SQLWarning (not thrown) |
| 10 | Informational - becomes SQLWarning (not thrown) |
| 11-16 | User errors - thrown as SQLException |
| 17-19 | Resource/software errors - thrown as SQLException |
| 20-25 | Fatal errors - connection terminated |

For errors to be caught in CFML, use severity 11 or higher (16 is most common for user errors):

```sql
-- This WILL throw an exception (severity 16)
RAISERROR('User error!', 16, 1);

-- This will NOT throw (severity 10, informational only)
RAISERROR('Just a notice', 10, 1);
```

## Performance Considerations

Modern mode adds minimal overhead:

- For simple SELECT queries: negligible impact
- For INSERT/UPDATE: ensures all results are consumed (required for proper cleanup anyway)
- For complex batches: necessary overhead to detect deferred errors

The performance cost is far outweighed by the correctness benefits of proper error handling.

## Compatibility

- **Lucee Version**: 5.3.8.169+ (feature added in [LDEV-3127](https://luceeserver.atlassian.net/browse/LDEV-3127), fixed in [LDEV-5970](https://luceeserver.atlassian.net/browse/LDEV-5970))
- **MSSQL JDBC Driver**: Tested with versions 9.x through 13.x
- **SQL Server**: Works with SQL Server 2012 and later

The implementation was improved in `6.2.5.7` and `7.0.2.8` as part of [LDEV-5970](https://luceeserver.atlassian.net/browse/LDEV-5970) and [LDEV-5972](https://luceeserver.atlassian.net/browse/LDEV-5972)

## Troubleshooting

### Errors Not Being Caught

1. Verify modern mode is enabled: check system properties/environment
2. Ensure RAISERROR severity is 11 or higher
3. Check that you're catching the correct exception type (`database` or `any`)

### "Result set is closed" Errors

If you see this error with older Lucee versions, upgrade to 6.2+ or 6.1.1+ where this was fixed (LDEV-5970).

### Stored Procedure Returns No Data

Some stored procedures return multiple result sets. Modern mode processes all of them but only returns the first. Use OUTPUT parameters or restructure your procedure if you need all results.

## Related Resources

- [Microsoft JDBC Driver Documentation](https://learn.microsoft.com/en-us/sql/connect/jdbc/using-multiple-result-sets)
- [RAISERROR (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql)
- [Database Connection Management](database-connection-management.md)
