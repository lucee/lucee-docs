Evicts a cached relationship collection from the second-level (L2) cache. The `collectionName` is the property name of the relationship on the owning entity.

If `primaryKey` is provided, only the collection for that specific entity instance is evicted. Otherwise all cached collections of that relationship are evicted.

Only relevant when `secondaryCacheEnabled` is `true` and the relationship has `cacheuse` set.

See [[orm-caching]] for L2 cache details.
