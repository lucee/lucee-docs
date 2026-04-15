```luceescript+trycf
// define a RAM cache as the default object cache
application action="update" caches="#{ trycf: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();

// empty cache
dump( cacheCount() ); // 0

cachePut( "key1", "value1" );
cachePut( "key2", "value2" );
cachePut( "key3", "value3" );

dump( cacheCount() ); // 3

// you can also count entries in a specific named cache
dump( cacheCount( "trycf" ) ); // 3
```
