```luceescript+trycf
// define a RAM cache as the default object cache
application action="update" caches="#{ trycf: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();
cachePut( "myKey", "hello world" );

// returns a struct with metadata about the cache entry
// the exact keys depend on the cache implementation
meta = cacheGetMetadata( "myKey" );
dump( meta );
// typical keys include: created, lastHit, lastAccessed, hitCount, idleTime, timeSpan
```
