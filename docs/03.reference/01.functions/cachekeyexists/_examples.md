```luceescript+trycf
// define a RAM cache as the default object cache
application action="update" caches="#{ trycf: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();
cachePut( "myKey", "hello" );

// NOTE: cacheKeyExists is deprecated — use cacheIdExists() instead
dump( cacheKeyExists( "myKey" ) );    // true
dump( cacheKeyExists( "noSuchKey" ) ); // false

// same thing with the recommended function
dump( cacheIdExists( "myKey" ) );      // true
```
