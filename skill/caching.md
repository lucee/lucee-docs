# Lucee skill: Caching

Cache connections, cachedWithin, query cache invalidation, cache extensions.

Fetch a recipe with `https://docs.lucee.org/recipes/<id>.md`. "Since" is the first Lucee version with the feature.

| ID | Title | Description | Since | Keywords |
|----|-------|-------------|-------|----------|
| `caches-defined-in-application-cfc` | Caches defined in Application.cfc | How to add per-application caches via Application.cfc in Lucee. | - | Caches, Application.cfc, Per-application caches, Cache connections, Default caches, Lucee |
| `dynamodb-cache-extension` | DynamoDB Cache Extension | Documentation for using Amazon DynamoDB as a cache provider and NoSQL data store in Lucee | 7.0 | DynamoDB, Cache, AWS, NoSQL, Distributed Cache, Cloud Storage, Maven, DynamoDBCommand |
| `caching-getting-started` | Getting Started with Caching | An introduction to Lucee's cache layer — what it is, why you'd use it, and how to get started with the cache BIFs. | - | Cache, cachePut, cacheGet, cacheClear, cacheDelete, RAM cache, Object cache, Application.cfc |
| `query-cache-invalidation` | Invalidating and Grouping Cached Queries | How to remove a single cached query, clear cached queries by tag or all at once, and group cached queries under a key prefix so they can be cleared together cheaply. | - | Cache, Query cache, cachedWithin, cachedWithinFlush, cacheClear, systemCacheClear, tags, Cache invalidation |
| `list-existing-cache-conn` | List existing Cache Connections | How to list and check for cache connections at runtime in Lucee. | - | Cache, Cache connections, List cache, getApplicationSettings, Lucee |
| `cache-invalidation-selective` | Selective Cache Invalidation | How to flush specific cached queries, functions, and HTTP results in Lucee without clearing entire caches. | 7.1 | Cache, cachedWithin, cachedWithinId, cachedWithinFlush, Query cache, Function cache, HTTP cache, Cache invalidation |
| `cached-within-request` | Using cachedWithin | How to use the cachedWithin attribute on queries, functions, cfhttp, and cffile in Lucee. | - | Cache, Query, Request cache, cachedWithin, cfquery, cfhttp, cffile |
