Evicts cached query results from the second-level query cache. If `cacheName` is provided, only that named cache region is evicted. Otherwise the default query cache is evicted.

Only relevant when `secondaryCacheEnabled` is `true` and queries are run with `cacheable: true`.

See [[orm-caching]] for query cache details.
