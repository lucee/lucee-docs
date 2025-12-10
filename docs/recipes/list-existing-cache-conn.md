<!--
{
  "title": "List existing Cache Connections",
  "id": "list-existing-cache-conn",
  "categories": [
    "cache"
  ],
  "description": "List existing Cache Connections available in Lucee.",
  "keywords": [
    "Cache",
    "Cache connections",
    "List cache",
    "hasCache",
    "cacheNames",
    "Lucee"
  ]
}
-->

# List existing Cache Connections

Lucee has a built-in function to list cache connections, but you can also do it manually:

```cfs
/**
* returns all available cache names as an array
*/
array function cacheNames() {
    return getPageContext().getConfig().getCacheConnections().keySet().toArray();
}
```

Returns an array of all cache connection names.

```cfs
/**
* checks if a cache with the given name is defined
* @cacheName name of the cache to look for
*/
boolean function hasCache(required string cacheName) {
    var it = getPageContext().getConfig().getCacheConnections().keySet().iterator();
    loop collection="#it#" item="local.name" {
        if (cacheName.trim() == name) return true;
    }
    return false;
}
```

Checks if a cache with the given name exists.
