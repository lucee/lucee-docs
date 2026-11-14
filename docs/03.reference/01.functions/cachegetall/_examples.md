```luceescript+trycf
// define a RAM cache as the default object cache
application action="update" caches="#{ trycf: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();
cachePut( "fruit:apple", "red" );
cachePut( "fruit:banana", "yellow" );
cachePut( "vehicle:car", "blue" );

// returns a struct — keys are the cache ids, values are the cached data
all = cacheGetAll();
dump( all );

// use a wildcard filter to get a subset
fruits = cacheGetAll( "fruit:*" );
dump( fruits ); // struct with 2 entries: fruit:apple and fruit:banana
```
