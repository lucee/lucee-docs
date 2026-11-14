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

// returns an array of all cache keys (uppercase)
ids = cacheGetAllIds();
dump( ids ); // ["FRUIT:APPLE", "FRUIT:BANANA", "VEHICLE:CAR"]

// use a wildcard filter to get a subset
fruitIds = cacheGetAllIds( "fruit:*" );
dump( fruitIds ); // ["FRUIT:APPLE", "FRUIT:BANANA"]
```
