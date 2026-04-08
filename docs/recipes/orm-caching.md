<!--
{
  "title": "ORM - Caching",
  "id": "orm-caching",
  "categories": [
    "orm"
  ],
  "description": "Configuring the Hibernate second-level cache and query cache with EHCache in Lucee ORM",
  "related": [
    "orm-configuration",
    "orm-querying",
    "orm-session-and-transactions",
    "function-ormevictentity",
    "function-ormevictcollection",
    "function-ormevictqueries"
  ]
}
-->

# ORM - Caching

Hibernate provides two levels of caching:

- **First-level cache (L1)** — the ORM session itself. Automatic, per-request, always on. Loading the same entity twice in one request returns the same instance. See [[orm-session-and-transactions]]
- **Second-level cache (L2)** — shared across requests. Caches entity data and query results so repeated loads don't hit the database. Must be explicitly enabled

This page covers the L2 cache and query cache.

## Enabling the L2 Cache

Add these settings to your [[orm-configuration]]:

```cfml
this.ormSettings = {
	secondaryCacheEnabled: true,
	cacheProvider: "ehcache"
};
```

That's enough to enable caching. Lucee generates a default EHCache configuration automatically.

### Custom EHCache Configuration

For control over cache sizes, expiry, and disk overflow, provide an `ehcache.xml`:

```cfml
this.ormSettings = {
	secondaryCacheEnabled: true,
	cacheProvider: "ehcache",
	cacheconfig: "ehcache.xml"
};
```

Example `ehcache.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="ehcache.xsd"
	updateCheck="false" name="myAppCache">
	<diskStore path="java.io.tmpdir"/>
	<defaultCache
		maxElementsInMemory="10000"
		eternal="false"
		timeToIdleSeconds="120"
		timeToLiveSeconds="120"
		maxElementsOnDisk="10000000"
		diskExpiryThreadIntervalSeconds="120"
		memoryStoreEvictionPolicy="LRU">
		<persistence strategy="localTempSwap"/>
	</defaultCache>
</ehcache>
```

You can add entity-specific `<cache>` elements for fine-grained control — the cache region name defaults to the fully qualified entity name.

## Caching Entities

Mark an entity for L2 caching with the `cacheuse` component attribute:

```cfml
component persistent="true" table="products" accessors="true"
	cacheuse="read-write" {

	property name="id"   fieldtype="id" ormtype="string";
	property name="name" ormtype="string";

}
```

### Cache Strategies

| Strategy | Description | Use When |
|----------|-------------|----------|
| `"read-only"` | Cached data is never modified. Fastest, safest | Reference/lookup tables that never change |
| `"nonstrict-read-write"` | Occasional writes, no strict consistency guarantee | Data that changes rarely and where stale reads are acceptable |
| `"read-write"` | Read/write with soft locks for consistency | General-purpose entities with moderate write frequency |
| `"transactional"` | Full transactional consistency via JTA | When you need strict consistency (requires JTA transaction manager) |

For most applications, `"read-write"` is the right choice. Use `"read-only"` for lookup tables (countries, statuses, categories) that you load frequently but rarely change.

## Caching Collections

Cache a relationship's collection separately by adding `cacheuse` to the relationship property:

```cfml
property name="items"
	fieldtype="one-to-many"
	cfc="Item"
	fkcolumn="categoryId"
	type="array"
	cacheuse="read-write";
```

This caches the list of child IDs. The child entities themselves are only cached if their entity CFC also has `cacheuse` set.

## Query Cache

The query cache stores the results of HQL queries. Enable it by passing `cacheable: true` in query options:

```cfml
results = ORMExecuteQuery(
	"FROM Product WHERE category = :cat",
	{ cat: "electronics" },
	false,
	{ cacheable: true }
);
```

The second time this query runs with the same parameters, Hibernate returns the cached result instead of hitting the database.

> **Note:** Query caching requires `secondaryCacheEnabled: true`. The query cache stores entity IDs — the actual entity data comes from the L2 entity cache. For best results, enable both entity caching and query caching together.

### Named Cache Regions

Organise cached queries into named regions:

```cfml
results = ORMExecuteQuery(
	"FROM Product WHERE active = true",
	{},
	false,
	{ cacheable: true, cachename: "activeProducts" }
);
```

This lets you evict specific groups of queries without clearing everything.

## Cache Eviction

When data changes outside ORM (direct SQL, another application, database triggers), the cache becomes stale. Evict manually with [[function-ormevictentity]], [[function-ormevictcollection]], and [[function-ormevictqueries]]:

```cfml
// Evict a specific entity from L2 cache
ORMEvictEntity( "Product" );              // all Product instances
ORMEvictEntity( "Product", "abc-123" );   // specific instance by PK

// Evict a collection
ORMEvictCollection( "Category", "items" );  // all "items" collections on Category

// Evict query cache
ORMEvictQueries();                    // all cached queries
ORMEvictQueries( "activeProducts" );  // specific cache region
```

## When to Use L2 Cache

**Good candidates:**

- Reference data loaded frequently but changed rarely (countries, statuses, categories, configuration)
- Read-heavy entities where the same records are loaded across many requests
- Query results that are expensive to compute and stable

**Bad candidates:**

- Entities that change frequently — the cache overhead (invalidation, locking) outweighs the benefit
- Entities with large data volumes — memory pressure
- Data that must always be current (financial transactions, inventory counts)

## Diagnosing Cache Behaviour

Enable cache logging in your [[orm-configuration]] to see hits, misses, and evictions:

```cfml
this.ormSettings = {
	logCache: true
};
```

See [[orm-logging]] for full logging setup.

## What's Next?

- [[orm-configuration]] — `secondaryCacheEnabled`, `cacheProvider`, `cacheconfig` settings
- [[orm-logging]] — `logCache` to monitor cache activity
- [[orm-querying]] — `cacheable` and `cachename` query options
