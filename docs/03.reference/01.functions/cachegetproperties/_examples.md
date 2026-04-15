```luceescript+trycf
// define a RAM cache as the default object cache
application action="update" caches="#{ trycf: {
	class: 'lucee.runtime.cache.ram.RamCache',
	custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
	default: 'object'
}}#";

// returns an array of structs describing the default cache connections
props = cacheGetProperties();
dump( props );

// pass a type to get properties for a specific default cache
objectProps = cacheGetProperties( "object" );
dump( objectProps );

// or pass a cache name directly
namedProps = cacheGetProperties( "trycf" );
dump( namedProps );
```
