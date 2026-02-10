<!--
{
  "title": "Selective Cache Invalidation",
  "id": "selective-cache-invalidation",
  "since": "7.1",
  "related": [
    "function-cachedwithinid",
    "function-cachedwithinflush",
    "function-cacheremove",
    "function-cachegetdefaultcachename",
    "tag-function",
    "tag-query"
  ],
  "categories": [
    "cache",
    "performance"
  ],
  "menuTitle": "Selective Cache Invalidation",
  "description": "How to flush specific cached queries, functions, and HTTP results in Lucee without clearing entire caches.",
  "keywords": [
    "Cache",
    "cachedWithin",
    "cachedWithinId",
    "cachedWithinFlush",
    "Query cache",
    "Function cache",
    "HTTP cache",
    "Cache invalidation",
    "Performance"
  ]
}
-->

# Selective Cache Invalidation

Lucee 7.1 introduces the ability to selectively invalidate specific cached entries for queries, functions, and HTTP results. This allows you to cache results for extended periods while maintaining data freshness by flushing only the affected cache entries when underlying data changes.

## Overview

Traditional caching in Lucee requires either waiting for cache expiration or clearing entire caches, which can be inefficient. Selective cache invalidation solves this by allowing you to:

- Cache queries, functions, and HTTP results for long periods (hours or days)
- Invalidate only specific cache entries when data changes
- Maintain optimal performance without serving stale data
- Target cache entries by their specific arguments or parameters

## Prerequisites

For selective cache invalidation to work, you must have **default caches configured** for the cache types you want to use (`query`, `function`, or `http`).

### Configuring Default Caches

Define default caches in `Application.cfc`:

```lucee
// Define a cache connection
this.cache.connections["myCache"] = {
    class: 'org.lucee.extension.cache.eh.EHCache',
    storage: false,
    custom: {
        "timeToIdleSeconds": "86400",
        "timeToLiveSeconds": "86400"
    }
};

// Set as default for query, function, and http operations
this.cache.query = "myCache";
this.cache.function = "myCache";
this.cache.http = "myCache";
```

Without default caches configured, `cachedWithin` will not function, and selective invalidation will not work.

## Basic Usage

### Cached Queries

Cache a query result and flush it when the underlying data changes:

```lucee
// Cache the query for 1 day
query datasource="mydsn" name="qUserPlan" cachedwithin="#createTimeSpan(0,1,0,0)#" {
    echo("SELECT plan, features FROM users where id='#id#'");
}

// Later, when user updates their plan, flush only that specific query cache
cachedWithinFlush(qUserPlan);
```

### Cached Functions

Cache function results based on arguments, and flush specific argument combinations:

```lucee
function getUserPlan(userid) cachedwithin="#createTimeSpan(0,1,0,0)#" {
    return queryExecute(
        "SELECT plan, features FROM users WHERE id = :id",
        {id: userid}
    );
}

// Cache is created per unique argument combination
plan1 = getUserPlan(123);  // Creates cache entry for userid=123
plan2 = getUserPlan(456);  // Creates separate cache entry for userid=456

// Flush cache only for userid=123
cachedWithinFlush(getUserPlan, [123]);
// or cachedWithinFlush(getUserPlan, {userid:123});

// userid=456 cache remains intact
```

### Cached HTTP Requests

Cache HTTP responses and invalidate them when needed:

```lucee
cfhttp(
    url="https://api.example.com/data",
    result="httpResult",
    cachedwithin="#createTimeSpan(0,0,10,0)#"
);

// Flush the HTTP cache when you know the API data has changed
cachedWithinFlush(httpResult);
```

## Available Functions

### cachedWithinId()

Returns the cache identifier (cache key) for a cached object. This ID can be used with `cacheRemove()` for manual cache management.

**Syntax:**

```lucee
cacheId = cachedWithinId(cacheObject [, arguments])
```

**Arguments:**

- `cacheObject` (required) - The cached query, function, or HTTP result
- `arguments` (optional) - For functions: array or struct of arguments that identify the specific cache entry

**Returns:** String - The cache identifier

**Examples:**

```lucee
// Get cache ID for a query
query datasource="mydsn" name="q" cachedwithin="#createTimeSpan(0,1,0,0)#" {
    writeOutput("SELECT * FROM users");
}
cacheId = cachedWithinId(q);
dump(cacheId);  // Outputs: unique cache identifier

// Get cache ID for a function with specific arguments
function getUser(id) cachedwithin="#createTimeSpan(0,1,0,0)#" {
    return queryExecute("SELECT * FROM users WHERE id = :id", {id: id});
}

// Positional arguments (array)
cacheId = cachedWithinId(getUser, [123]);

// Named arguments (struct)
cacheId = cachedWithinId(getUser, {id: 123});

// Get cache ID for HTTP result
cfhttp(url="https://example.com", result="res", cachedwithin="#createTimeSpan(0,1,0,0)#");
cacheId = cachedWithinId(res);
```

### cachedWithinFlush()

Flushes a specific cached entry from the cache. This is the primary function for selective cache invalidation.

**Syntax:**

```lucee
success = cachedWithinFlush(cacheObject [, arguments])
```

**Arguments:**

- `cacheObject` (required) - The cached query, function, or HTTP result to flush
- `arguments` (optional) - For functions: array or struct of arguments that identify the specific cache entry

**Returns:** Boolean - `true` if the cache entry was successfully removed, `false` otherwise

**Examples:**

```lucee
// Flush a cached query
query datasource="mydsn" name="qProducts" cachedwithin="#createTimeSpan(0,1,0,0)#" {
    writeOutput("SELECT * FROM products WHERE active = 1");
}
success = cachedWithinFlush(qProducts);
dump(success);  // true if flushed successfully

// Flush a function cache with specific arguments
function calculatePrice(productId, quantity) cachedwithin="#createTimeSpan(0,1,0,0)#" {
    return queryExecute(
        "SELECT price FROM products WHERE id = :id",
        {id: productId}
    ).price * quantity;
}

// Flush cache for specific product
cachedWithinFlush(calculatePrice, [101, 5]);

// Both argument formats work
cachedWithinFlush(calculatePrice, {productId: 101, quantity: 5});

// Flush HTTP cache
cfhttp(url="https://api.example.com/prices", result="priceData", cachedwithin="#createTimeSpan(0,0,30,0)#");
cachedWithinFlush(priceData);
```

## Advanced Usage

### Manual Cache Removal with cacheRemove()

For more control, combine `cachedWithinId()` with `cacheRemove()`:

```lucee
// Get the cache ID
query datasource="mydsn" name="q" cachedwithin="#createTimeSpan(0,1,0,0)#" {
    writeOutput("SELECT * FROM products");
}
cacheId = cachedWithinId(q);

// Manually remove from cache using the ID
cacheRemove(
    ids: cacheId,
    cacheName: cacheGetDefaultCacheName("query")
);
```

This approach gives you the flexibility to store cache IDs and flush them later, or to use custom cache management logic.

### Working with Query Result Metadata

When using the `result` attribute in queries, the cache ID is automatically included in the result metadata:

```lucee
query datasource="mydsn" name="q" cachedwithin="#createTimeSpan(0,1,0,0)#" result="r" {
    writeOutput("SELECT * FROM users");
}

// Access cache ID from result metadata
dump(r.cachedWithinId);

// Use it to remove from cache
cacheRemove(
    ids: r.cachedWithinId,
    cacheName: cacheGetDefaultCacheName("query")
);
```

### Function Arguments: Array vs Struct

For cached functions, you can specify arguments as either an array (positional) or struct (named):

```lucee
function searchProducts(category, minPrice, maxPrice) cachedwithin="#createTimeSpan(0,1,0,0)#" {
    return queryExecute(
        "SELECT * FROM products WHERE category = :cat AND price BETWEEN :min AND :max",
        {cat: category, min: minPrice, max: maxPrice}
    );
}

// Positional arguments (array) - order matters
cachedWithinFlush(searchProducts, ["Electronics", 100, 500]);

// Named arguments (struct) - order doesn't matter
cachedWithinFlush(searchProducts, {
    category: "Electronics",
    minPrice: 100,
    maxPrice: 500
});

// Both target the same cache entry
```

## Limitations and Considerations

- **Default Caches Required**: Selective invalidation only works when default caches are configured for the relevant cache type.

- **Function Arguments Must Match**: For functions, the arguments passed to `cachedWithinFlush()` must exactly match the arguments used when the cache entry was created.

- **No Wildcard Flushing**: You cannot flush all cache entries for a function at once; you must target specific argument combinations.

- **Cache Type Specificity**: Each cache type (`query`, `function`, `http`) uses its own default cache. Ensure the correct cache is configured.

- **Cross-Request Consistency**: Cache IDs are consistent across requests, so you can store them and use them later to flush caches.
