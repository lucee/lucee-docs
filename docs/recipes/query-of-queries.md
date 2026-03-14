<!--
{
  "title": "Query of Queries (QoQ)",
  "id": "query-of-queries",
  "related": [
    "tag-query"
  ],
  "categories": [
    "query"
  ],
  "description": "Query of queries (QoQ) is a technique for re-querying an existing (in memory) query without another trip to the database.",
  "keywords": [
    "Query of Queries",
    "QoQ",
    "SQL",
    "In memory query",
    "Lucee",
    "dbtype query"
  ]
}
-->

# Query of Queries (QoQ)

Query of queries (QoQ) is a technique for re-querying an existing (in memory) query without another trip to the database. This allows you to dynamically combine queries from different databases.

```lucee
<!--- query a database in the normal manner --->
<cfquery name="sourceQry" datasource="mydsn">
  SELECT    *
  FROM   my_db_table
</cfquery>

<!--- query the above query *object*. (this doesn't make a call to the database.) --->
<cfquery name="newQry" dbtype="query"><!--- the dbtype="query" attribute/value enables QoQ --->
  SELECT    *
  FROM    sourceQry <!--- instead of a real database table name, use the variable name of the source query object --->
</cfquery>
```

The above example isn't very useful, because `newQry` is a straight copy of the source query, but it demonstrates the two requirements of `QoQ`:

- The dbtype="query" attribute
- A source query object name (e.g., sourceQry) instead of a table name in the FROM clause.

## Example: Filtering

Let's say you have the following database query, `myQuery`:

```lucee
<cfquery name="myQuery" datasource="mydsn">
  SELECT    Name, Age, Location
  FROM    People
</cfquery>
```

You would now have a list of names, ages, and locations for all the people in a query called `myQuery`.

Say you want to filter out people under 18 and over 90, but you don't want to hit the database again:

```lucee
<cfquery name="filteredQuery" dbtype="query">
  SELECT     Name, Age, Location
  FROM    myQuery
  WHERE    Age >= 18
           AND Age <= 90
</cfquery>
```

`filteredQry` contains the desired records.

## Internals

Lucee uses its own fast SQL implementation (basic ANSI92 subset); if that fails, it falls back to [HSQLDB](http://hsqldb.org/doc/2.0/guide/sqlgeneral-chapt.html) (more complete but slower, as the source queries are dyanically loaded into the in memory database).

## Lucee's SQL Implementation

**Keywords and Operators**

- <=
- <>
- =
- =>
- =
- !=
- ALL
- AND
- AS
- BETWEEN x AND y
- DESC/ASC
- DISTINCT
- FROM
- GROUP BY
- HAVING
- IN ()
- IS
- IS NOT NULL
- IS NULL
- LIKE
- NOT
- NOT IN ()
- NOT LIKE
- OR
- ORDER BY
- SELECT
- TOP
- UNION
- WHERE
- XOR

Functions

TODO: Flesh this out.

## HSQLDB SQL Implementation

This is the fallback for when Lucee's SQL implementation can't handle the QoQ syntax. See the [HSQLDB documentation](http://hsqldb.org/doc/2.0/guide/sqlgeneral-chapt.html) for details.

## Case Sensitivity

::: since
Lucee 7.1
:::

By default, QoQ string comparisons (`LIKE`, `=`, `<>`, `IN`) are **case-insensitive**. This means `WHERE name LIKE '%mod%'` matches both `Modica` and `mod-lower`.

This differs from Adobe ColdFusion, where QoQ string operations are case-sensitive.

You can enable case-sensitive comparisons with the `caseSensitive` option. When enabled, `WHERE name LIKE '%mod%'` matches only `mod-lower`, and `WHERE name = 'modica'` won't match `Modica`.

### Per-Query: `dbtype` Struct

The `dbtype` attribute now accepts a struct as well as a string. The struct form lets you set QoQ options per query:

```lucee
<cfset qry = queryNew( "name", "varchar", [
	[ "Modica" ],
	[ "mod-lower" ],
	[ "Tabitha" ]
] />

<!--- case-insensitive (default, backwards compatible) --->
<cfquery name="result" dbtype="query">
	SELECT name FROM qry WHERE name LIKE '%mod%'
</cfquery>
<!--- result: Modica, mod-lower --->

<!--- case-sensitive --->
<cfset result = queryExecute(
	"SELECT name FROM qry WHERE name LIKE '%mod%'",
	{},
	{ dbtype: { type: "query", caseSensitive: true } }
) />
<!--- result: mod-lower --->
```

#### `dbtype` Struct Keys

| Key             | Type    | Default    | Description                                                                                           |
| --------------- | ------- | ---------- | ----------------------------------------------------------------------------------------------------- |
| `type`          | string  | (required) | `"query"` — same as the existing string value                                                         |
| `caseSensitive` | boolean | `false`    | When `true`, string comparisons (`LIKE`, `=`, `<>`, `IN`) are case-sensitive                          |
| `engine`        | string  | `"auto"`   | `"auto"` (try native first, fall back to HSQLDB), `"native"` (native only), `"hsqldb"` (force HSQLDB) |

### Per-Application: Application.cfc

Set defaults for all QoQ queries in your application:

```cfs
// Application.cfc
component {
	this.query.qoq = {
		caseSensitive: true,
		engine: "native"
	};
}
```

### Server-Wide: Environment Variables

Set a server-wide default using a system property or environment variable:

- System property: `lucee.qoq.caseSensitive=true`
- Environment variable: `LUCEE_QOQ_CASE_SENSITIVE=true`

### Precedence

When multiple levels are configured, the most specific setting wins:

1. **Per-query** (`dbtype` struct) — highest priority
2. **Per-application** (`this.query.qoq` in Application.cfc)
3. **Environment variable** — lowest priority

## Choosing the QoQ Engine

** Since Lucee 7.1 **

By default, Lucee tries the native QoQ engine first and falls back to HSQLDB if the SQL is too complex. You can now explicitly choose which engine to use with the `engine` option:

- `"auto"` — default behaviour (native first, HSQLDB fallback)
- `"native"` — use only the native engine; errors if the SQL isn't supported
- `"hsqldb"` — skip native and go straight to HSQLDB

```cfs
result = queryExecute(
	"SELECT name FROM qry ORDER BY name",
	{},
	{ dbtype: { type: "query", engine: "native" } }
);
```

The `engine` option follows the same precedence as `caseSensitive`: per-query overrides Application.cfc, which overrides the environment variable.
