<!--
{
  "title": "Using cachedWithin",
  "id": "cache-a-query-for-the-curr-context",
  "related": [
    "tag-query",
    "tag-http",
    "tag-file",
    "caching-getting-started",
    "selective-cache-invalidation"
  ],
  "categories": [
    "cache",
    "query"
  ],
  "description": "How to use the cachedWithin attribute on queries, functions, cfhttp, and cffile in Lucee.",
  "keywords": [
    "Cache",
    "Query",
    "Request cache",
    "cachedWithin",
    "cfquery",
    "cfhttp",
    "cffile"
  ]
}
-->

# Using cachedWithin

The `cachedWithin` attribute tells Lucee to cache the result of an operation for a specified duration. It's supported on queries, functions, [[tag-http]], and [[tag-file]] — anything where re-running the same operation repeatedly is wasteful.

## Queries

The most common use — cache a query result so identical queries reuse the cached result instead of hitting the database again:

```lucee
<cfquery cachedWithin="#createTimeSpan( 0, 0, 5, 0 )#">
  SELECT * FROM products WHERE active = 1
</cfquery>
```

This caches the query result for 5 minutes. Any request running the same SQL with the same parameters gets the cached result.

### Per-request caching

A common pattern is caching a query for just the current request — the same query might run multiple times within one page (e.g. in a header, a sidebar, and the main content). Using a short timespan like 1 second works but applies across all requests, which adds unnecessary overhead.

Instead, pass `"request"` as the `cachedWithin` value:

```lucee
<cfquery cachedWithin="request">
  SELECT * FROM products WHERE active = 1
</cfquery>
```

The query result is cached for only the current request, regardless of how long the request takes. No cross-request caching, no expiry timing to worry about.

## Functions

Cache the return value of a function based on its arguments:

```luceescript
function getUserPlan( required string userId ) cachedwithin="#createTimeSpan( 0, 1, 0, 0 )#" {
	return queryExecute(
		"SELECT plan, features FROM users WHERE id = :id",
		{ id: arguments.userId }
	);
}

// first call hits the database, subsequent calls with the same userId are cached
plan = getUserPlan( "42" );
```

Each unique set of arguments gets its own cache entry. See [[selective-cache-invalidation]] for how to flush specific cached function results in Lucee 7.1.

## HTTP requests

Cache the response from an external HTTP call:

```lucee
<cfhttp url="https://api.example.com/data" cachedWithin="#createTimeSpan( 0, 0, 10, 0 )#" />
```

Useful for API responses that don't change frequently — weather data, exchange rates, configuration endpoints.

## File reads

Cache the contents of a file read:

```lucee
<cffile action="read" file="config.json" variable="content" cachedWithin="request" />
```

Handy when the same file is read multiple times during a request — templates, config files, translation bundles.

## Cache types and defaults

For `cachedWithin` to work, Lucee needs a cache connection configured for the relevant type. When you set a default query cache, all `cachedWithin` queries use it automatically. Same for function, http, and file caches. See [[caching-getting-started]] for how to set up cache connections and [[category-cache]] for the full list of cache types.

>>> **Note:** `cachedWithin="request"` is a special case — it uses an internal per-request store and doesn't require a cache connection to be configured.
