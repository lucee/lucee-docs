Evicts entity data from the second-level (L2) cache. Does not affect the first-level session cache — use [[function-ormclearsession]] for that.

If `primaryKey` is provided, only that specific instance is evicted. Otherwise all cached instances of the entity are evicted.

Only relevant when `secondaryCacheEnabled` is `true` in [[orm-configuration]].

See [[orm-caching]] for L2 cache details.
