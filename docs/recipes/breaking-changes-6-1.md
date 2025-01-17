
<!--
{
  "title": "Breaking Changes Between Lucee 6.0 and 6.1",
  "id": "breaking-changes-6-0-to-6-1",
  "categories": ["breaking changes", "migration","compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 6.0 and 6.1",
  "keywords": ["breaking changes", "Lucee 6.0", "Lucee 6.1", "migration", "upgrade"],
  "related": [
    "logging-cfhttp-calls"
  ]
}
-->

# Breaking Changes Between Lucee 6.0 and 6.1

This document outlines the breaking changes introduced when upgrading from Lucee 6.0 to Lucee 6.1. Be aware of these changes when migrating your applications to ensure smooth compatibility.

## Removal of the Lucee Language Dialect

As of Lucee 6.1, the **Lucee Language dialect** has been fully removed. This means that the Lucee-specific language dialect can no longer be used in any way within your applications. Ensure that any code utilizing this dialect is updated to use standard CFML.

## Exception Handling in `<cfcontent>` Tag

In Lucee 6.0, using the `<cfcontent>` tag with a file URL that returns a **403 Forbidden** response did not throw an exception. In Lucee 6.1, this behavior has changed, and now an exception **will be thrown** in this scenario. Make sure to adjust your error handling if this is relevant to your application.

### Previous Behavior (Lucee 6.0):

```cfml
<cfcontent file="https://example.com/protected-file" />
```

- No exception was thrown, even if a 403 was returned.

### New Behavior (Lucee 6.1):

- An exception is now thrown if the server returns a 403 status code.

## `fileExists()` Function Behavior with HTTP Paths

In Lucee 6.0, the `fileExists()` function returned `true` when checking an HTTP path that returned a **403 Forbidden** status. In Lucee 6.1, the function now correctly returns `false` if the server responds with a 403.

### Previous Behavior (Lucee 6.0):

```cfml
fileExists("https://example.com/protected-file") // Returns true, even with a 403 response
```

### New Behavior (Lucee 6.1):

```cfml
fileExists("https://example.com/protected-file") // Now returns false for a 403 response
```

## `dollarFormat()` Function Behavior

The behavior of the `dollarFormat()` function when formatting negative numbers has been standardized to match **Adobe ColdFusion (ACF)**. In previous versions of Lucee, this function had inconsistent behavior depending on the Java version.

### Previous Behavior (Lucee 5 on Java 8):

```cfml
dollarFormat(-11.34) // Returns ($11.34)
```

### Previous Behavior (Lucee 5 on Java 11):

```cfml
dollarFormat(-11.34) // Returns -$11.34
```

### New Behavior (Lucee 6.1):

The function now returns `($11.34)` for negative values, which aligns with ACF's behavior.

```cfml
dollarFormat(-11.34) // Returns ($11.34) on Lucee 6.1
```

## Conclusion

These breaking changes in Lucee 6.1 may impact existing applications that rely on the old behaviors. Review your code to ensure it is compatible with these updates, particularly if you are using the Lucee Language dialect, the `cfcontent` tag with protected files, the `fileExists()` function with HTTP paths, or the `dollarFormat()` function.

## Query of Queries (QoQ) Behavior in Lucee 6.1

Query of Queries (QoQ) in CFML allows you to run SQL queries on existing result sets (known as `Query` objects in CFML). There have been notable changes to QoQ functionality in Lucee 6.1 that could impact backward compatibility.

### Previous Behavior (Lucee 6.0 and earlier)

In previous versions of Lucee, the following SQL would return **1 matching row** when executed in **MSSQL** or **Adobe ColdFusion's QoQ**:

```cfml
employees = queryNew( 'name,foo', 'varchar,varchar',[
    ['Brad','cm_4test5'],
    ['Luis','yeah']
]);

actual = QueryExecute(
    sql = "SELECT * from employees WHERE foo LIKE 'cm_[0-9]%[0-9]'",
    options = { dbtype: 'query' }
);

writedump( actual );

```

However, **MySQL**, **Oracle**, and **PostgreSQL** do not support square bracket character sets in their `LIKE` operator, which caused inconsistencies in behavior across different databases.

### New Behavior (Lucee 6.1)

Starting with Lucee 6.1, the square bracket character set (used in the `LIKE` operator) behaves more consistently and similarly to **regular expressions**. This feature allows matching of a single character from the set or range of characters defined.

#### Example Matching:

- `[abc]` – Matches a single character: `"a"`, `"b"`, or `"c"`
- `[0-9]` – Matches a single digit: `"0"` through `"9"`

### Potential Backward Compatibility Issues

This change can introduce backward compatibility issues for existing code using literal square brackets in the `LIKE` operator. For example, the following SQL:

```sql
WHERE col1 LIKE 'foo[bar]baz%'
```

Would need to be updated to:

```sql
WHERE col1 LIKE 'foo\[bar]baz%'
```

If a custom escape character is preferred, you can use the standard SQL `ESCAPE` syntax:

```sql
WHERE col1 LIKE 'foo@[bar]baz%' ESCAPE '@'
```

### Escape Character Support

In Lucee 6.1, support for the escape character has been fixed. The default escape character is now `\`, but you can specify a custom escape character using the `ESCAPE` clause in your SQL.

#### Example with Default Escape Character (`\`):

```sql
WHERE col1 LIKE 'foo\[bar]baz%'
```

#### Example with Custom Escape Character (`@`):

```sql
WHERE col1 LIKE 'foo@[bar]baz%' ESCAPE '@'
```

This update ensures more consistent behavior and improved support for matching patterns with special characters, making QoQ more reliable across different databases.
