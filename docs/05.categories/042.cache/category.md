---
title: Cache
id: category-cache
description: Lucee's pluggable cache layer — store and retrieve data with swappable backends.
---

Lucee has a pluggable cache layer that sits between your code and a swappable backend. You define a cache connection (like a datasource, but for cached data), pick a provider, and interact with it through a consistent set of BIFs: [[function-cacheput]], [[function-cacheget]], [[function-cacheclear]], and others listed below.

Your code stays the same regardless of which provider you use — only the configuration changes. If you're new to caching in Lucee, start with the [[caching-getting-started]] recipe.

## Cache providers

| Provider | Class | Maven GAV (Lucee 7+) | Best for |
| -------- | ----- | -------------------- | -------- |
| RamCache | `lucee.runtime.cache.ram.RamCache` | Built-in | Development, single server, fastest option |
| [EHCache](https://download.lucee.org/#87FE44E5-179C-43A3-A87B3D38BEF4652E) | `org.lucee.extension.cache.eh.EHCache` | `org.lucee:ehcache-extension` | Single server, disk overflow, mature ([source](https://github.com/lucee/extension-ehcache)) |
| [Redis](https://download.lucee.org/#60772C12-F179-D555-8E2CD2B4F7428718) | `lucee.extension.io.cache.redis.RedisCache` | `org.lucee:redis-extension` | Distributed, multi-server production ([source](https://github.com/lucee/extension-redis)) |
| [DynamoDB](https://download.lucee.org/#E0ACA85A-22DB-48FF-B2D6CD89D5D1709F) | `org.lucee.extension.aws.dynamodb.DynamoDBCache` | `org.lucee:dynamodb-extension` | AWS, fully managed, auto-scaling ([docs](https://docs.lucee.org/recipes/dynamodb-cache-extension.html), [source](https://github.com/lucee/extension-dynamodb)) |
| [Memcached](https://download.lucee.org/#16FF9B13-C595-4FA7-B87DED467B7E61A0) | `org.lucee.extension.cache.mc.MemcachedCache` | Legacy (Ant/OSGi) | Distributed, simple key-value, high throughput ([source](https://github.com/lucee/extension-memcached)) |
| [MongoDB](https://download.lucee.org/#E6634E1A-4CC5-4839-A83C67549ECA8D5B) | `org.lucee.mongodb.cache.MongoDBCache` | Legacy (Ant/OSGi) | Distributed, document store with cache interface ([source](https://github.com/lucee/extension-mongodb)) |

## Cache types

Lucee supports default caches for different operation types. When you set a cache connection as the default for a type, the relevant features use it automatically:

- **object** — used by the cache BIFs ([[function-cacheput]], [[function-cacheget]], etc.) when no `cacheName` is specified
- **query** — used by `cachedWithin` on [[tag-query]]
- **function** — used by `cachedWithin` on functions
- **template** — used for template caching
- **http** — used by `cachedWithin` on [[tag-http]]
- **resource** — used for virtual filesystem caching
- **include** — used for cfinclude caching
- **file** — used by `cachedWithin` on [[tag-file]]
- **webservice** — used for web service response caching
