<!--
{
  "title": "SQL Types",
  "id": "sql-types",
  "description": "SQL types for query parameters",
  "categories": [
    "query"
  ],
  "keywords": [
    "SQL",
    "SQL types",
    "CF_SQL",
    "queryparam",
    "queryexecute",
    "cfsqltype"
  ],
  "related": [
    "tag-query",
    "tag-queryparam",
    "tag-storedproc",
    "tag-procparam",
    "function-queryexecute"
  ]
}
-->

# SQL Types

Here are the SQL types supported by Lucee.

All are supported with and without the `CF_SQL_` prefix (ACF too since 11):

* CF_SQL_ARRAY / ARRAY
* CF_SQL_BIGINT / BIGINT
* CF_SQL_BINARY / BINARY
* CF_SQL_BIT / BIT
* CF_SQL_BOOLEAN / BOOLEAN
* CF_SQL_BLOB / BLOB
* CF_SQL_CHAR / CHAR
* CF_SQL_CLOB / CLOB
* CF_SQL_DATALINK / DATALINK
* CF_SQL_DATE / DATE
* CF_SQL_DISTINCT / DISTINCT
* CF_SQL_NUMERIC / NUMERIC
* CF_SQL_DECIMAL / DECIMAL
* CF_SQL_DOUBLE / DOUBLE
* CF_SQL_REAL / REAL
* CF_SQL_FLOAT / FLOAT
* CF_SQL_TINYINT / TINYINT
* CF_SQL_SMALLINT / SMALLINT
* CF_SQL_STRUCT / STRUCT
* CF_SQL_INTEGER / INTEGER
* CF_SQL_VARCHAR / VARCHAR
* CF_SQL_NVARCHAR / NVARCHAR
* CF_SQL_VARCHAR2 / VARCHAR2
* CF_SQL_LONGVARBINARY / LONGVARBINARY
* CF_SQL_VARBINARY / VARBINARY
* CF_SQL_LONGVARCHAR / LONGVARCHAR
* CF_SQL_TIME / TIME
* CF_SQL_TIMESTAMP / TIMESTAMP
* CF_SQL_REF / REF
* CF_SQL_REFCURSOR / REFCURSOR
* CF_SQL_OTHER / OTHER
* CF_SQL_NULL / NULL

Since 5.3.6.16

* CF_SQL_NCHAR / NCHAR
* CF_SQL_NVARCHAR / NVARCHAR
* CF_SQL_LONGNVARCHAR / LONGNVARCHAR
* CF_SQL_NCLOB / NCLOB
* CF_SQL_SQLXML / SQLXML

Since 5.3.8.109

* CF_SQL_DATETIME / DATETIME

## Usage Examples

### Using cfquery with cfqueryparam

```cfml
<cfquery name="qUsers" datasource="myDB">
	SELECT  *
	FROM 	users
	WHERE 	username = <cfqueryparam value="#username#" cfsqltype="VARCHAR">
			AND age >= <cfqueryparam value="#minAge#" cfsqltype="INTEGER">
			AND created_date > <cfqueryparam value="#startDate#" cfsqltype="TIMESTAMP">
			AND is_active = <cfqueryparam value="#isActive#" cfsqltype="BIT">
</cfquery>
```

### Using queryExecute with parameter struct

```cfml
qUsers = queryExecute(
    "SELECT * FROM users WHERE username = :username AND age >= :minAge",
    {
        username: { value: username, cfsqltype: "VARCHAR" },
        minAge: { value: minAge, cfsqltype: "INTEGER" }
    },
    { datasource: "myDB" }
);
```

### Using queryExecute with positional parameters

```cfml
qUsers = queryExecute(
    "SELECT * FROM users WHERE username = ? AND age >= ?",
    [
        { value: username, cfsqltype: "VARCHAR" },
        { value: minAge, cfsqltype: "INTEGER" }
    ],
    { datasource: "myDB" }
);
```

### Common SQL Type Usage

```cfml
// Strings
{ value: "John", cfsqltype: "VARCHAR" }
{ value: "A", cfsqltype: "CHAR" }

// Numbers
{ value: 42, cfsqltype: "INTEGER" }
{ value: 99.99, cfsqltype: "DECIMAL" }
{ value: 12345678901, cfsqltype: "BIGINT" }

// Dates and Times
{ value: now(), cfsqltype: "TIMESTAMP" }
{ value: dateFormat( now(), "yyyy-mm-dd" ), cfsqltype: "DATE" }
{ value: timeFormat( now(), "HH:mm:ss" ), cfsqltype: "TIME" }

// Boolean
{ value: true, cfsqltype: "BIT" }
{ value: false, cfsqltype: "BOOLEAN" }

// Binary
{ value: fileReadBinary( filePath ), cfsqltype: "BLOB" }

// Null values
{ value: "", null: true, cfsqltype: "VARCHAR" }
```

## Why Use SQL Types?

Using the correct SQL type provides several benefits:

1. **Security**: Prevents SQL injection attacks by properly escaping values
2. **Performance**: Helps the database optimize query execution
3. **Data Integrity**: Ensures values are properly converted to the correct database type
4. **Compatibility**: Works consistently across different database engines

## Notes

- You can use either the `CF_SQL_` prefix or just the type name (e.g., `VARCHAR` instead of `CF_SQL_VARCHAR`)
- The `CF_SQL_` prefix style is more explicit but longer
- Always use SQL types with dynamic values to prevent SQL injection
- The `null` attribute can be used with any SQL type to pass NULL values to the database

## Breaking Change in Lucee 6.0

**Important**: Prior to Lucee 6, `cfqueryparam` would automatically cast empty strings to NULL.

With Lucee 6, this behavior changed to match Adobe ColdFusion. Empty strings are no longer automatically converted to NULL.

**Before (Lucee 5):**

```cfml
<cfquery name="qUsers" datasource="myDB">
    SELECT * FROM users
    WHERE id = <cfqueryparam value="#userID#" cfsqltype="INTEGER">
</cfquery>
<!-- If userID was an empty string, it would become NULL -->
```

**After (Lucee 6):**

```cfml
<cfquery name="qUsers" datasource="myDB">
    SELECT * FROM users
    WHERE id = <cfqueryparam
                value="#len( trim( userID ) ) ? userID : javaCast( 'null', '' )#"
                cfsqltype="INTEGER"
                null="#not len( trim( userID ) )#">
</cfquery>
<!-- Explicitly handle empty strings -->
```

### Affected SQL Types

The following SQL types no longer auto-convert empty strings to NULL:

- INTEGER, BIGINT, SMALLINT, TINYINT
- DECIMAL, NUMERIC, DOUBLE, FLOAT, REAL
- DATE, TIME, TIMESTAMP, DATETIME
- BIT, BOOLEAN

### Migration

If you need the old behavior temporarily during migration, set the environment variable:

```bash
LUCEE_QUERY_ALLOWEMPTYASNULL=true
```

However, it's recommended to explicitly handle NULL values in your code for better clarity and to match Adobe ColdFusion behavior.

See [[breaking-changes-5-4-to-6-0]] and [[lucee-5-to-6-migration-guide]] for more details.
