<!--
{
  "title": "QoQ SQL Functions and Operators",
  "id": "query-of-queries-functions",
  "related": [
    "query-of-queries",
    "tag-query"
  ],
  "categories": [
    "query"
  ],
  "description": "Reference for the SQL keywords, operators, and functions supported by Lucee's native Query of Queries (QoQ) engine.",
  "keywords": [
    "Query of Queries",
    "QoQ",
    "SQL",
    "functions",
    "operators",
    "HSQLDB",
    "Lucee"
  ]
}
-->

# QoQ SQL Functions and Operators

Lucee's native [Query of Queries](query-of-queries) engine supports a subset of ANSI SQL92. If the native engine can't handle the query, Lucee falls back to [HSQLDB](http://hsqldb.org/doc/2.0/guide/sqlgeneral-chapt.html) (see [Choosing the QoQ Engine](/guides/lucee-7-1.html#engine-selection) for how to control this).

## Keywords and Operators

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

## Aggregate Functions

|Function|Syntax|Description|
|---|---|---|
|COUNT|`COUNT(*)`, `COUNT(col)`, `COUNT(DISTINCT col)`, `COUNT(ALL col)`|Row count, or count of non-null values. `COUNT(*)` and `COUNT(1)` return total rows.|
|SUM|`SUM(col)`|Sum of non-null numeric values. Returns null if all values are null.|
|AVG|`AVG(col)`|Average of non-null numeric values. Returns null if all values are null.|
|MIN|`MIN(col)`|Minimum value. Numeric-aware sorting for numeric column types, text sort otherwise.|
|MAX|`MAX(col)`|Maximum value. Same type-aware sorting as MIN.|

## String Functions

|Function|Syntax|Description|
|---|---|---|
|UPPER|`UPPER(expr)`|Convert to uppercase. Also available as `UCASE`.|
|LOWER|`LOWER(expr)`|Convert to lowercase. Also available as `LCASE`.|
|TRIM|`TRIM(expr)`|Remove leading and trailing whitespace.|
|LTRIM|`LTRIM(expr)`|Remove leading whitespace only.|
|RTRIM|`RTRIM(expr)`|Remove trailing whitespace only.|
|LENGTH|`LENGTH(expr)`|Returns the length of the string as a number.|
|CONCAT|`CONCAT(expr1, expr2)`|Concatenate two strings.|
|SOUNDEX|`SOUNDEX(expr)`|Returns the SOUNDEX phonetic encoding of the string.|

## Mathematical Functions

|Function|Syntax|Description|
|---|---|---|
|ABS|`ABS(n)`|Absolute value.|
|ACOS|`ACOS(n)`|Arc cosine (input between -1 and 1, returns radians).|
|ASIN|`ASIN(n)`|Arc sine (input between -1 and 1, returns radians).|
|ATAN|`ATAN(n)`|Arc tangent (returns radians).|
|ATAN2|`ATAN2(y, x)`|Arc tangent of y/x (returns radians).|
|CEILING|`CEILING(n)`|Smallest integer greater than or equal to n.|
|COS|`COS(n)`|Cosine (input in radians).|
|EXP|`EXP(n)`|e raised to the power of n.|
|FLOOR|`FLOOR(n)`|Largest integer less than or equal to n.|
|MOD|`MOD(dividend, divisor)`|Remainder of division. Returns null if either argument is null.|
|POWER|`POWER(base, exponent)`|base raised to exponent. Returns null if either argument is null.|
|SIGN|`SIGN(n)`|Returns -1, 0, or 1 indicating the sign of n.|
|SIN|`SIN(n)`|Sine (input in radians).|
|SQRT|`SQRT(n)`|Square root.|
|TAN|`TAN(n)`|Tangent (input in radians).|
|BITAND|`BITAND(n1, n2)`|Bitwise AND of two integers.|
|BITOR|`BITOR(n1, n2)`|Bitwise OR of two integers.|

## Type Conversion

|Function|Syntax|Description|
|---|---|---|
|CAST|`CAST(expr AS type)`|Convert expr to the specified type. Supports all CFML types (string, numeric, date, boolean, etc.).|
|CONVERT|`CONVERT(expr, type)`|Same as CAST but with function-call syntax. Type can be a string literal or identifier.|

## Utility Functions

|Function|Syntax|Description|
|---|---|---|
|COALESCE|`COALESCE(expr1, expr2 [, ...])`|Returns the first non-null argument. Accepts two or more arguments.|
|ISNULL|`ISNULL(expr1, expr2)`|Returns expr2 if expr1 is null, otherwise expr1. Equivalent to `COALESCE` with two arguments.|
|RAND|`RAND()` or `RAND(seed)`|Random number between 0.0 and 1.0. Optional seed for repeatable results within a query.|

## HSQLDB SQL Implementation

HSQLDB is the fallback engine for when Lucee's native SQL implementation can't handle the QoQ syntax. It supports a much broader set of SQL features. See the [HSQLDB documentation](http://hsqldb.org/doc/2.0/guide/sqlgeneral-chapt.html) for details.
