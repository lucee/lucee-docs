```luceescript
// Evict all cached queries in the default region
ORMEvictQueries();

// Evict a named cache region
ORMEvictQueries( "activeProducts" );

// Evict queries for a specific datasource
ORMEvictQueries( cacheName="", datasource="inventoryDB" );
```
