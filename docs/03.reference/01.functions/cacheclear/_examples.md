```luceescript+trycf
// define a RAM cache as the default object cache
application action="update" caches="#{ trycf: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

// store some values
cachePut( "fruit:apple", "red" );
cachePut( "fruit:banana", "yellow" );
cachePut( "vehicle:car", "blue" );

dump( cacheCount() ); // 3

// clear only keys matching a wildcard filter
cacheClear( "fruit:*" );
dump( cacheCount() ); // 1 — only vehicle:car remains

// clear everything
cacheClear();
dump( cacheCount() ); // 0
```
