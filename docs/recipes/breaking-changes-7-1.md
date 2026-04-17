<!--
{
  "title": "Breaking Changes between Lucee 7.0 and 7.1",
  "id": "breaking-changes-7-0-to-7-1",
  "categories": ["breaking changes", "migration","compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 7.0 and 7.1",
  "keywords": ["breaking changes", "Lucee 7.0", "Lucee 7.1", "migration", "upgrade"],
  "related": [
    "tag-application",
    "single-vs-multi-mode"
  ]
}
-->

# Breaking Changes between Lucee 7.0 and 7.1

This document outlines the breaking changes introduced when upgrading from Lucee 7.0 to Lucee 7.1.

Be aware of these changes when migrating your applications to ensure smooth compatibility.

## Other Breaking Changes in Lucee Releases

- [[breaking-changes-5-4-to-6-0]]
- [[breaking-changes-6-0-to-6-1]]
- [[breaking-changes-6-1-to-6-2]]
- [[breaking-changes-6-2-to-7-0]]

## Struct Key Ordering Changes

The internal ordering of keys in unordered (non-linked) structs has changed in Lucee 7.1. This means that `serializeJSON()` output for regular structs may produce keys in a different order than previous versions.

Any code that relied on unordered structs having a consistent key order may break (e.g. comparing serialized JSON strings, iterating keys, or generating cached markup).

**Example:**

```cfc
var s = { "data": {}, "includes": ["a.js"], "adhoc": {} };
// 7.0: {"data":{},"includes":["a.js"],"adhoc":{}}
// 7.1: {"includes":["a.js"],"adhoc":{},"data":{}}
```

**Workarounds:**

- Use `StructNew("ordered")` or `StructNew("linked")` if key order matters
- Compare deserialized structs instead of raw JSON strings
- Use `structSort()` or sorted keys when generating deterministic output

This change was made to improve struct performance.

[LDEV-5908](https://luceeserver.atlassian.net/browse/LDEV-5908)

## QoQ SQL String Concatenation with NULL values

Previously, the HSQLDB-backed Query of Queries engine propagated NULL during string concatenation (like MySQL's `CONCAT()`) — `'foo' || NULL` would return `NULL`. This caused rows with NULL values to be silently excluded from query results when using `||` or `CONCAT()` in WHERE clauses.

The native QoQ engine, which previously didn't support `||` or N-arg `CONCAT()` and fell back to HSQLDB.

Lucee 7.1 now treats NULL as an empty string during string concatenation in QoQ, matching Adobe ColdFusion behaviour, Oracle's `||` operator and SQL Server's `CONCAT()` function.

**Examples using `||` operator:**

```sql
-- Given a query with four rows: "", "123", NULL, "456"

SELECT name FROM qry WHERE CONCAT( ',', name, ',' ) NOT LIKE '%,123,%'
-- or
SELECT name FROM qry WHERE ',' || name || ',' NOT LIKE '%,123,%'

-- 7.0: returns 1 row (456) — ',' || NULL || ',' returns NULL, and NULL NOT LIKE '%..%' is NULL, not TRUE
-- 7.1: returns 3 rows ("", NULL, "456") — NULL is treated as empty string

```

Both `||` and `CONCAT()` are functionally identical — they now treat NULL as an empty string in both the native and HSQLDB engines.

If your code relies on NULL propagation in QoQ string concatenation, you may need to update your queries.

[LDEV-6154](https://luceeserver.atlassian.net/browse/LDEV-6154)
