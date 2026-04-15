<!--
{
  "title": "Getting Started with Caching",
  "id": "caching-getting-started",
  "related": [
    "function-cacheput",
    "function-cacheget",
    "function-cacheclear",
    "function-cachedelete",
    "function-cachecount",
    "function-cachegetall",
    "function-cachegetallids",
    "function-cacheidexists",
    "function-cachegetmetadata",
    "caches-defined-in-application-cfc",
    "cache-a-query-for-the-curr-context",
    "selective-cache-invalidation",
    "dynamodb-cache-extension"
  ],
  "categories": [
    "cache"
  ],
  "menuTitle": "Getting Started",
  "description": "An introduction to Lucee's cache layer — what it is, why you'd use it, and how to get started with the cache BIFs.",
  "keywords": [
    "Cache",
    "cachePut",
    "cacheGet",
    "cacheClear",
    "cacheDelete",
    "RAM cache",
    "Object cache",
    "Application.cfc",
    "Getting started"
  ]
}
-->

# Getting Started with Caching

If you've used `cachedWithin` on a query, you've already been caching. The cache BIFs give you the same idea — store something expensive once, reuse it — but for any data, with full control over what gets cached and when it expires.

## Why cache?

Every time your code runs an expensive operation — a slow query, an external API call, a complex calculation — the result is thrown away at the end of the request. The next request does the same work all over again.

Caching lets you keep that result around. One request does the expensive work, every subsequent request gets the answer from memory until you decide it's stale. Your database gets fewer queries, your external APIs get fewer calls, and your pages load faster.

## How Lucee's cache layer works

Lucee has a pluggable cache layer. You define a **cache connection** (think of it like a datasource, but for cached data), pick a backend (RAM, EHCache, Redis, DynamoDB), and your code talks to it through a small set of BIFs: [[function-cacheput]], [[function-cacheget]], [[function-cacheclear]], and so on.

The backend is swappable. Your code doesn't change — just the config. Start with RAM for development, switch to Redis or DynamoDB for production when you need distributed caching across multiple servers.

Lucee also has the concept of **cache types**: object, query, function, template, resource, http, and others. When you set a cache connection as the "default object cache", the cache BIFs use it automatically without you specifying a name. When you set one as the "default query cache", `cachedWithin` on queries uses it. Same layer, different entry points.

Lucee ships with a built-in RAM cache and supports several extension-based providers (Redis, EHCache, DynamoDB, Memcached, MongoDB). See [[category-cache]] for the full list of providers with class names and Maven coordinates. Start with RamCache — it's zero-config and fast. When you outgrow a single server, swap in a distributed provider without changing your application code.

## Setting up a cache connection

Before you can cache anything, you need a cache connection. The easiest way is in `Application.cfc`:

```luceescript
// Application.cfc
this.cache.connections["myCache"] = {
	class: 'lucee.runtime.cache.ram.RamCache',
	storage: false,
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
};
```

That creates a RAM cache named "myCache" and sets it as the default object cache. The `custom` struct controls how long entries live — here, 1 hour for both idle timeout and absolute lifetime.

For the examples in this guide, we'll use `application action="update"` to define the cache inline — this makes the examples self-contained and runnable on [trycf.com](https://trycf.com):

```luceescript+trycf
application action="update" caches="#{ myCache: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cachePut( "greeting", "G'day!" );
dump( cacheGet( "greeting" ) );
```

For full details on cache connection configuration, see [[caches-defined-in-application-cfc]].

## Storing and retrieving data

The core workflow is [[function-cacheput]] and [[function-cacheget]]. You store a value with a key, get it back later. Works with any CFML type — strings, structs, arrays, queries, components.

```luceescript+trycf
application action="update" caches="#{ myCache: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();

// cache a struct
cachePut( "user:42", {
	name: "Zac",
	email: "zac@example.com",
	plan: "pro"
} );

// retrieve it
user = cacheGet( "user:42" );
dump( user );
```

**Tip:** Use prefixed keys like `"user:42"` or `"config:site"` to namespace your cache entries. This makes wildcard filtering much easier later.

### Checking before getting

If you [[function-cacheget]] a key that doesn't exist, the return value is `null`. You can either check first with [[function-cacheidexists]], or handle the null:

```luceescript+trycf
application action="update" caches="#{ myCache: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();

// pattern 1: check first
if ( cacheIdExists( "user:99" ) ) {
	user = cacheGet( "user:99" );
}

// pattern 2: just get it, check for null
user = cacheGet( "user:99" );
if ( !isNull( user ) ) {
	dump( user );
} else {
	dump( "not cached" );
}
```

### Removing a single entry

[[function-cachedelete]] removes one entry by its key:

```luceescript+trycf
application action="update" caches="#{ myCache: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();
cachePut( "user:42", "Zac" );
cachePut( "user:43", "Alice" );
dump( cacheCount() ); // 2

cacheDelete( "user:42" );
dump( cacheCount() ); // 1
```

By default, deleting a key that doesn't exist is silently ignored. Pass `throwOnError=true` if you want an exception instead.

## Exploring what's in the cache

When you need to see what's cached — for debugging, monitoring, or bulk operations:

```luceescript+trycf
application action="update" caches="#{ myCache: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();
cachePut( "user:42", "Zac" );
cachePut( "user:43", "Alice" );
cachePut( "config:theme", "dark" );

// how many entries?
dump( cacheCount() ); // 3

// what keys exist? (returns an array, keys are uppercased)
dump( cacheGetAllIds() );

// wildcard filter — get only user keys
dump( cacheGetAllIds( "user:*" ) );

// get everything as a struct (key -> value)
dump( cacheGetAll( "user:*" ) );
```

[[function-cachegetallids]] and [[function-cachegetall]] both support wildcard filters using the same pattern syntax as `cfdirectory` — `*` matches any sequence of characters.

## Clearing the cache

[[function-cacheclear]] with no arguments wipes everything. With a wildcard filter, it removes only matching entries:

```luceescript+trycf
application action="update" caches="#{ myCache: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();
cachePut( "user:42", "Zac" );
cachePut( "user:43", "Alice" );
cachePut( "config:theme", "dark" );

// clear only user entries
cacheClear( "user:*" );
dump( cacheCount() ); // 1 — config:theme remains

// clear everything
cacheClear();
dump( cacheCount() ); // 0
```

Use [[function-cachedelete]] when you know the exact key. Use [[function-cacheclear]] with a filter when you want to wipe a category of entries. Use [[function-cacheclear]] with no arguments when you want a fresh start.

## Cache expiration

Cache entries can expire automatically. [[function-cacheput]] takes two optional timespan arguments:

- **timeSpan** — the entry expires after this much time, regardless of access
- **idleTime** — the entry expires if it hasn't been accessed within this time

```luceescript+trycf
application action="update" caches="#{ myCache: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();

// expire after 5 minutes — good for API responses where you want freshness
cachePut( "api:weather", { temp: 22, wind: "NW" }, createTimeSpan( 0, 0, 5, 0 ) );

// expire after 5 min absolute, or 1 min idle — good for session-like data
cachePut( "session:abc", { user: "Zac" }, createTimeSpan( 0, 0, 5, 0 ), createTimeSpan( 0, 0, 1, 0 ) );

dump( cacheIdExists( "api:weather" ) ); // true (hasn't expired yet)
```

**When to use which:**

- **timeSpan only** — when data has a known freshness window (cache this API response for 5 minutes)
- **idleTime only** — when you want to keep popular entries warm but let cold ones expire
- **Both** — maximum lifetime capped by timeSpan, but idle entries drop out sooner

If you don't pass either, the cache connection's default TTL applies (the `timeToLiveSeconds` and `timeToIdleSeconds` from your config).

## Named caches

So far we've used the default object cache — the one set with `default: 'object'` in the config. But you can define multiple cache connections with different settings and use the `cacheName` parameter to target them:

```luceescript+trycf
application action="update" caches="#{
	shortLived: {
		class: 'lucee.runtime.cache.ram.RamCache',
		custom: { timeToIdleSeconds: 60, timeToLiveSeconds: 300 },
		default: 'object'
	},
	longLived: {
		class: 'lucee.runtime.cache.ram.RamCache',
		custom: { timeToIdleSeconds: 86400, timeToLiveSeconds: 86400 }
	}
}#";

// API responses in the short-lived cache (5 min TTL)
cachePut( id: "api:weather", value: { temp: 22 }, cacheName: "shortLived" );

// config data in the long-lived cache (24 hour TTL)
cachePut( id: "config:features", value: { darkMode: true }, cacheName: "longLived" );

dump( cacheGet( id: "api:weather", cacheName: "shortLived" ) );
dump( cacheGet( id: "config:features", cacheName: "longLived" ) );
```

Every cache BIF — [[function-cacheget]], [[function-cacheput]], [[function-cacheclear]], [[function-cachedelete]], [[function-cachecount]], [[function-cachegetallids]], [[function-cachegetall]], [[function-cacheidexists]] — accepts an optional `cacheName` parameter.

## A practical example

Here's a common pattern — cache-aside (also called lazy loading). Check the cache first, only do the expensive work on a miss:

```luceescript
function getUserProfile( required string userId ) {
	var cacheKey = "userProfile:" & arguments.userId;

	// try the cache first
	var cached = cacheGet( cacheKey );
	if ( !isNull( cached ) ) return cached;

	// cache miss — do the expensive work
	var profile = queryExecute(
		"SELECT name, email, plan FROM users WHERE id = :id",
		{ id: arguments.userId }
	);

	// store it for 10 minutes
	cachePut( cacheKey, profile, createTimeSpan( 0, 0, 10, 0 ) );

	return profile;
}
```

When the user updates their profile, flush just that one entry:

```luceescript
cacheDelete( "userProfile:" & userId );
```

Next request gets a fresh copy from the database.
