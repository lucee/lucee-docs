<!--
{
  "title": "Invalidating and Grouping Cached Queries",
  "id": "query-cache-invalidation",
  "related": [
    "tag-query",
    "function-cachedwithinflush",
    "function-cachedwithinid",
    "function-cacheclear",
    "function-cacheget",
    "function-cacheput",
    "function-cachegetallids",
    "function-cacheidexists",
    "function-systemcacheclear",
    "function-cachegetdefaultcachename",
    "cache-a-query-for-the-curr-context",
    "selective-cache-invalidation",
    "caching-getting-started",
    "caches-defined-in-application-cfc"
  ],
  "categories": [
    "cache",
    "query",
    "performance"
  ],
  "menuTitle": "Invalidating Cached Queries",
  "description": "How to remove a single cached query, clear cached queries by tag or all at once, and group cached queries under a key prefix so they can be cleared together cheaply.",
  "keywords": [
    "Cache",
    "Query cache",
    "cachedWithin",
    "cachedWithinFlush",
    "cacheClear",
    "systemCacheClear",
    "tags",
    "Cache invalidation",
    "Key prefix",
    "Redis"
  ]
}
-->

# Invalidating and Grouping Cached Queries

Caching a query with `cachedWithin` is easy. Getting rid of the right cached queries when the data changes is the harder part. This recipe covers the options, from removing one query to clearing a whole group of related queries at once, and what each one costs.

## How `cachedWithin` builds its cache key

When you cache a query with `cachedWithin`, Lucee stores the result in the **default query cache** of the application (`this.cache.query`, or the default set in the Administrator). The `cacheName` attribute of `cfquery` is not used.

The cache key is a hash of:

- the SQL and its parameters
- the datasource name
- the username and password
- the `returntype`
- `maxrows`

The **query name is not part of the key**. Two queries with different names but the same SQL, parameters and settings share one cache entry:

```lucee
query name="qA" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#" {
	echo( "SELECT * FROM users WHERE active = 1" );
}
// served from the entry created by qA
query name="qB" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#" {
	echo( "SELECT * FROM users WHERE active = 1" );
}
```

You can't choose the key yourself, which matters when you want to clear groups of queries (see "Grouping cached queries with a key prefix" below).

## Removing a single cached query

### `cachedWithinFlush()` (Lucee 7.1+)

```lucee
query name="qUser" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#" {
	echo( "SELECT * FROM users WHERE id = 42" );
}

// later, when user 42 changes
cachedWithinFlush( qUser );
```

`cachedWithinId()` returns the key, so you can also store it and remove the entry later with `cacheRemove( id, false, cacheGetDefaultCacheName( "query" ) )`. See [[selective-cache-invalidation]] for details.

### Timespan 0 (any version)

On any version, including 6.2, run the same query again with a timespan of 0. That removes its entry from the cache, and the result isn't stored again:

```lucee
query name="qUser" cachedWithin="#createTimeSpan( 0, 0, 0, 0 )#" {
	echo( "SELECT * FROM users WHERE id = 42" );
}
```

Both are cheap (one entry, no scan), but you need to know the exact query (SQL and parameters). That works for "user 42", not for "every query about active users".

## Clearing cached queries by tag

`cfquery` has a `tags` attribute. You can clear every cached query that has one of the given tags:

```lucee
query name="qActive" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#" tags="users,users:active" {
	echo( "SELECT * FROM users WHERE active = 1" );
}

// clear every cached query tagged "users:active"
cacheClear( [ "users:active" ], cacheGetDefaultCacheName( "query" ) );

// or for a datasource other than the application's default one
cacheClear( { tags: [ "users:active" ], datasource: "myOtherDsn" }, cacheGetDefaultCacheName( "query" ) );
```

Things to know:

- Pass the query cache name. Without a cache name, `cacheClear()` works on the default **object** cache.
- Only queries of one datasource are matched: the one in the struct form, otherwise the application's default datasource.
- **Clearing by tag reads every value in the cache.** The tags are stored inside the cached query, not in the key, so Lucee has to load and deserialize every entry to check its tags. On a local RAM cache that's fine. On a remote cache like Redis, it's a `KEYS *` followed by one `GET` per entry, so it gets slow as the cache grows.

## Clearing the whole query cache

```lucee
systemCacheClear( "query" );
```

This removes everything in the default query cache of the current application. It only reads keys, not values.

On **Redis**, a cache connection is a database index, so this deletes **every key in that database index**, including keys stored there by other cache connections. Give each Redis cache connection its own `databaseIndex` if they shouldn't wipe each other.

## Grouping cached queries with a key prefix

If you need to clear groups of related queries ("all cached queries about active users") without reading every cached value, don't use `cachedWithin` for those queries. Cache them yourself with `cachePut()` / `cacheGet()` under a key you choose, with the group as the key prefix. Clearing a group is then a key-pattern `cacheClear()`, which only looks at keys. On Redis, that's one `KEYS users:active:*` plus one `DEL`, with no values read or deserialized.

This works on Lucee 6.2 and newer.

Define a cache for the query groups, ideally on its own Redis database index:

```lucee
// Application.cfc
this.cache.connections[ "queryGroups" ] = {
	class: "lucee.extension.io.cache.redis.RedisCache",
	bundleName: "redis.extension",
	storage: false,
	custom: { host: "localhost", port: 6379, databaseIndex: 2 }
};
```

Then a small helper caches each query under `<group><hash>` and clears a group by prefix:

```lucee
function cachedQuery( required string group, required string sql, any params = {}, struct options = {}, any timespan = createTimeSpan( 0, 1, 0, 0 ) ) {
	var key = lCase( group ) & hash( sql & serializeJSON( params ) & serializeJSON( options ) );
	var q = cacheGet( id = key, cacheName = "queryGroups" );
	if ( isNull( q ) ) {
		q = queryExecute( sql, params, options );
		cachePut( id = key, value = q, timeSpan = timespan, cacheName = "queryGroups" );
	}
	return q;
}

function clearQueryGroup( required string group ) {
	return cacheClear( lCase( group ) & "*", "queryGroups" );
}

users = cachedQuery( "users:active:", "SELECT * FROM users WHERE active = :a", { a: 1 } );
clearQueryGroup( "users:active:" ); // just that group
clearQueryGroup( "users:" );        // everything under users:
```

Because the keys are readable, you can also see what's cached without running anything:

```lucee
cacheGetAllIds( "users:*", "queryGroups" ); // e.g. [ "users:active:f626fe93..." ]
cacheIdExists( someKey, "queryGroups" );
```

Things to watch:

- **Keep prefixes lowercase.** The Redis extension stores keys lowercased, but the pattern is passed to Redis as-is, so a mixed-case pattern like `Users:Active:*` matches nothing. That's why the helper uses `lCase()`. On RAM and EHCache, patterns are case-insensitive, so lowercase works everywhere.
- **Don't use wildcard characters in group names.** `*` and `?` are wildcards for `cacheClear()`, and Redis also treats `[`, `]` and `\` specially.
- **`KEYS` scans the whole Redis database index** on the server side. Only matching keys come back, but the scan still covers every key in that index. Keeping these entries in their own `databaseIndex` keeps the scan small.
- **Memcached can't list keys,** so wildcard clears don't work there.
- **You own the key.** Put everything that changes the result into the hash. The helper hashes the SQL, the parameters and the options (which include the datasource).
- You don't get what `cachedWithin` gives you for free, like `cachedAfter` or the `cached` flag in the query result.
- `systemCacheClear( "query" )` doesn't touch this cache. Use `cacheClear( "", "queryGroups" )` to empty it.

## Which one to use

| Goal | Use | Cost |
| --- | --- | --- |
| Remove one known query | `cachedWithinFlush()` (7.1+) or timespan 0 | One entry |
| Remove queries by tag | `cacheClear( [ tags ], cacheGetDefaultCacheName( "query" ) )` | Reads every cached value |
| Remove all cached queries | `systemCacheClear( "query" )` | Keys only, but on Redis the whole database index |
| Remove a group of queries | Prefixed keys with `cachePut()` / `cacheGet()` and `cacheClear( "prefix*", cacheName )` | Keys only, matching keys removed |
