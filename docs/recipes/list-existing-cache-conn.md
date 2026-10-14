<!--
{
  "title": "List existing Cache Connections",
  "id": "list-existing-cache-conn",
  "related": [
    "caching-getting-started",
    "caches-defined-in-application-cfc",
    "function-getapplicationsettings"
  ],
  "categories": [
    "cache"
  ],
  "description": "How to list and check for cache connections at runtime in Lucee.",
  "keywords": [
    "Cache",
    "Cache connections",
    "List cache",
    "getApplicationSettings",
    "Lucee"
  ]
}
-->

# List existing Cache Connections

Sometimes you need to know what cache connections are available at runtime — to check if a cache exists before using it, or to list all connections for diagnostics.

## Application-level caches

[[function-getapplicationsettings]] returns the cache connections defined in `Application.cfc`:

```luceescript+trycf
application action="update" caches="#{
	myCache: {
		class: 'lucee.runtime.cache.ram.RamCache',
		custom: { timeToIdleSeconds: 3600, timeToLiveSeconds: 3600 },
		default: 'object'
	},
	apiCache: {
		class: 'lucee.runtime.cache.ram.RamCache',
		custom: { timeToIdleSeconds: 60, timeToLiveSeconds: 300 }
	}
}#";

settings = getApplicationSettings();

// all cache connection names
names = structKeyArray( settings.cache.connections );
dump( names );

// check if a specific cache exists
dump( structKeyExists( settings.cache.connections, "myCache" ) ); // true
dump( structKeyExists( settings.cache.connections, "nope" ) );    // false
```

## Admin-level caches

Caches defined in the Lucee Administrator (server or web level) aren't included in [[function-getapplicationsettings]]. Likewise, caches defined in `Application.cfc` don't appear in the Lucee Administrator — they're invisible to the admin UI. The two worlds don't see each other.

There are two ways to get admin-level caches programmatically:

### Using cfadmin

```lucee
<cfadmin
	action="getCacheConnections"
	type="web"
	password="#request.webadminpassword#"
	returnVariable="connections">

<cfdump var="#connections#">
```

Use `type="server"` for server-level connections or `type="web"` for web-level. The result is a query with the connection details.

### Using the config API

If you don't have the admin password available, you can use Lucee's internal config API directly:

```luceescript
adminCaches = getPageContext().getConfig().getCacheConnections();
dump( adminCaches.keySet().toArray() );
```

To get a complete picture of all available caches, check both application and admin levels.
