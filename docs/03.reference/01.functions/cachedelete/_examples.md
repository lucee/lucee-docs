```luceescript+trycf
// define a RAM cache as the default object cache
application action="update" caches="#{ trycf: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

cacheClear();
cachePut( "user:1", "Alice" );
cachePut( "user:2", "Bob" );

dump( cacheCount() ); // 2

// delete a single entry by id
cacheDelete( "user:1" );
dump( cacheCount() ); // 1

// by default, deleting a non-existent key is silently ignored
cacheDelete( "doesNotExist" );

// pass throwOnError=true to throw when the key doesn't exist
try {
	cacheDelete( "doesNotExist", true );
} catch ( any e ) {
	dump( e.message );
}
```
