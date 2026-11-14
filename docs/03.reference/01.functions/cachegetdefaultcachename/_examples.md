```luceescript+trycf
// cacheGetDefaultCacheName returns the name of the default cache
// configured in the Lucee Administrator for a given type

// valid types: object, template, query, resource, function, include, http, file, webservice
// throws an exception if no default is configured for that type

try {
	name = cacheGetDefaultCacheName( "object" );
	dump( name );
} catch ( any e ) {
	dump( "no default object cache configured: " & e.message );
}
```
