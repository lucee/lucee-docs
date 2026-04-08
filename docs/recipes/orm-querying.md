<!--
{
  "title": "ORM - Querying",
  "id": "orm-querying",
  "categories": [
    "orm"
  ],
  "description": "HQL queries, entity loading functions, pagination, bulk DML, JOIN FETCH, aggregate functions, and query caching in Lucee ORM",
  "related": [
    "orm-getting-started",
    "orm-entity-mapping",
    "orm-relationships",
    "orm-session-and-transactions",
    "function-ormexecutequery",
    "function-entityload",
    "function-entityloadbypk",
    "function-entityloadbyexample",
    "function-entitytoquery"
  ]
}
-->

# ORM - Querying

Lucee ORM gives you multiple ways to load data: entity loading functions for simple lookups, and HQL (Hibernate Query Language) for complex queries. HQL looks like SQL but operates on entities and properties instead of tables and columns.

## Entity Loading Functions

### entityLoadByPK

[[function-entityloadbypk]] loads a single entity by primary key. Returns the entity or `null` if not found:

```cfml
user = entityLoadByPK( "User", 42 );

if ( isNull( user ) )
	throw( message="User not found" );
```

### entityLoad with Filter

[[function-entityload]] accepts a struct of property values to filter by. Always returns an array:

```cfml
// All active users
activeUsers = entityLoad( "User", { status: "active" } );

// Multiple filters (AND)
results = entityLoad( "User", { status: "active", role: "admin" } );
```

### entityLoad with Sorting

Pass a third argument for SQL-style ORDER BY:

```cfml
// Sorted alphabetically
users = entityLoad( "User", { status: "active" }, "name ASC" );

// Descending
users = entityLoad( "User", {}, "createdAt DESC" );
```

### entityLoad with Pagination

Pass an options struct as the fourth argument:

```cfml
// First 10 active users sorted by name
page1 = entityLoad( "User", { status: "active" }, "name ASC", { maxresults: 10, offset: 0 } );

// Next 10
page2 = entityLoad( "User", { status: "active" }, "name ASC", { maxresults: 10, offset: 10 } );
```

Available options:

| Option | Description |
|--------|-------------|
| `maxresults` | Maximum number of results to return |
| `offset` | Number of results to skip |
| `cacheable` | `true` to cache the query results |
| `cachename` | Name of the cache region |
| `timeout` | Query timeout in seconds |
| `ignorecase` | `true` for case-insensitive filter matching |

### entityLoad — All Entities

Call with just the entity name to load all instances:

```cfml
allProducts = entityLoad( "Product" );
```

### entityLoadByExample

[[function-entityloadbyexample]] loads entities matching an example instance. Any non-null properties on the example are used as filter criteria:

```cfml
example = entityNew( "User" );
example.setStatus( "active" );
example.setRole( "admin" );
matches = entityLoadByExample( example );
```

### entityToQuery

[[function-entitytoquery]] converts an array of entities to a CFML query object — useful when you need tabular data:

```cfml
users = entityLoad( "User" );
qUsers = entityToQuery( users );
writeDump( qUsers );
```

### entityNameArray / entityNameList

Get the names of all mapped entities:

```cfml
names = entityNameArray();  // [ "User", "Product", "Order" ]
list  = entityNameList();   // "User,Product,Order"
```

## HQL with ORMExecuteQuery

For anything beyond simple property filters, use HQL. [[function-ormexecutequery]] (aliased as `ORMQueryExecute()`) runs HQL queries through Hibernate.

### Basic Syntax

```cfml
ORMExecuteQuery( hql [, params [, unique [, options ]]] )
```

| Argument | Type | Description |
|----------|------|-------------|
| `hql` | string | The HQL query |
| `params` | struct or array | Named (struct) or positional (array) parameters |
| `unique` | boolean | `true` to return a single entity instead of an array. Returns `null` if no match |
| `options` | struct | `maxresults`, `offset`, `cacheable`, `cachename`, `datasource`, `timeout` |

### Named Parameters

Use `:paramName` placeholders with a struct:

```cfml
// String parameter
results = ORMExecuteQuery(
	"FROM Product WHERE name = :name",
	{ name: "Widget" }
);

// Multiple parameters
results = ORMExecuteQuery(
	"FROM Product WHERE price > :minPrice AND active = :active",
	{ minPrice: 9.99, active: true }
);
```

Hibernate handles type binding automatically — strings, numbers, dates, and booleans all work:

```cfml
// Date parameter
results = ORMExecuteQuery(
	"FROM Order WHERE created > :since",
	{ since: createDate( 2025, 1, 1 ) }
);

// Integer parameter
results = ORMExecuteQuery(
	"FROM Product WHERE id = :id",
	{ id: 42 }
);
```

### Positional Parameters

Use `?1`, `?2`, etc. with an array:

```cfml
results = ORMExecuteQuery(
	"FROM Product WHERE name = ?1",
	[ "Widget" ]
);
```

Named parameters are generally preferred — they're more readable and less error-prone.

### IN Clause with Arrays

Pass an array value for IN queries:

```cfml
results = ORMExecuteQuery(
	"FROM Product WHERE name IN (:names)",
	{ names: [ "Widget", "Gadget", "Doohickey" ] }
);
```

### Unique Results

Pass `true` as the third argument to get a single entity instead of an array:

```cfml
product = ORMExecuteQuery(
	"FROM Product WHERE sku = :sku",
	{ sku: "WDG-001" },
	true
);
// Returns the entity directly, or null if not found
```

### Pagination

Use the options struct for maxresults and offset:

```cfml
page = ORMExecuteQuery(
	"FROM Product WHERE active = :active ORDER BY name",
	{ active: true },
	false,
	{ maxresults: 10, offset: 20 }
);
```

## Aggregate Functions

HQL supports standard aggregate functions: `count`, `sum`, `avg`, `min`, `max`:

```cfml
// Count
total = ORMExecuteQuery( "select count(p) from Product p", {}, true );

// Sum
revenue = ORMExecuteQuery( "select sum(p.price) from Product p", {}, true );

// Average
avgPrice = ORMExecuteQuery( "select avg(p.price) from Product p", {}, true );

// Min / Max
cheapest = ORMExecuteQuery( "select min(p.price) from Product p", {}, true );
priciest = ORMExecuteQuery( "select max(p.price) from Product p", {}, true );
```

## JOIN FETCH

JOIN FETCH eagerly loads a relationship in a single query — the best fix for the N+1 problem when you know you'll need the association:

```cfml
// Without JOIN FETCH: 1 query for authors + N queries for books
authors = ORMExecuteQuery( "FROM Author" );

// With JOIN FETCH: 1 query with a JOIN
authors = ORMExecuteQuery(
	"select distinct a from Author a join fetch a.books where a.name = :name",
	{ name: "Alice" }
);
// authors[1].getBooks() is already loaded — no additional query
```

> **Note:** Use `select distinct` with JOIN FETCH to avoid duplicate parent entities in the result set. Without `distinct`, you get one result per child row.

## Subqueries

HQL supports subqueries in the WHERE clause:

```cfml
// Authors who have books priced above average
results = ORMExecuteQuery(
	"select distinct a from Author a join a.books b
	 where b.price > (select avg(b2.price) from Book b2)"
);
```

## Bulk DML

HQL UPDATE and DELETE execute directly in the database without loading entities. This is much faster for bulk operations but **does not trigger entity events** (preUpdate, preDelete, etc.):

### Bulk Update

```cfml
ORMExecuteQuery(
	"UPDATE Product SET name = :name WHERE id = :id",
	{ name: "Updated Widget", id: 1 }
);
```

### Bulk Delete

```cfml
ORMExecuteQuery(
	"DELETE FROM Product WHERE active = :active",
	{ active: false }
);
```

> **Note:** Bulk DML executes immediately against the database — no `ormFlush()` needed. However, Hibernate may auto-flush the session *before* the DML runs to ensure consistency.

> **Warning:** Bulk DML bypasses the session cache. Entities already loaded in the current session won't reflect the changes. Call `ormClearSession()` after bulk DML if you need to reload affected entities.

## Query Caching

Cache frequently-run queries with the same parameters:

```cfml
results = ORMExecuteQuery(
	"FROM Product WHERE category = :cat",
	{ cat: "electronics" },
	false,
	{ cacheable: true, cachename: "productsByCategory" }
);
```

Or with `entityLoad`:

```cfml
results = entityLoad( "Product", { category: "electronics" }, "", { cacheable: true } );
```

Query caching requires `secondaryCacheEnabled: true` in your [[orm-configuration]]. Evict cached queries with `ORMEvictQueries()`.

## Datasource-Scoped Queries

When using multiple datasources, specify which one to query:

```cfml
results = ORMExecuteQuery(
	"FROM Product WHERE active = true",
	{},
	false,
	{ datasource: "inventoryDB" }
);
```

See the multi-datasource section in [[orm-session-and-transactions]].

## HQL vs SQL

| Feature | HQL | SQL (queryExecute) |
|---------|-----|---------------------|
| Operates on | Entities and properties | Tables and columns |
| Returns | Entity objects | Query recordsets |
| Relationships | Navigate with dot notation (`a.books`) | Manual JOINs |
| Polymorphism | Automatic (queries include subclasses) | Manual UNION or type column |
| Events | Triggers entity events on load | No events |
| Session cache | Entities are session-managed | Not tracked |
| Bulk DML | Faster but bypasses events | Full control |

Use HQL when you want entities. Use SQL when you want raw performance, complex reporting, or database-specific features.

> **Important:** `entitySave()` does NOT auto-flush before `queryExecute()` runs. If you mix ORM writes with raw SQL reads in the same request, call `ormFlush()` explicitly before the SQL query. See [[orm-session-and-transactions]].

## What's Next?

- [[orm-session-and-transactions]] — how sessions, flush timing, and transactions affect queries
- [[orm-relationships]] — JOIN FETCH and batch fetching to solve N+1
- [[orm-troubleshooting]] — "Unknown entity" and other query errors
