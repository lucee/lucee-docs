---
title: CachedWithinId
id: function-cachedwithinid
related:
- function-cachedwithinflush
- function-cacheget
- function-cacheput
categories:
- cache
---

Returns the cache identifier (cache key) for a cached object. 
This ID can be used with `cacheRemove()` to manually flush the cache entry. 
Works with cached queries, functions, and HTTP results. 
For cached functions, the cache ID is unique per combination of function and arguments.