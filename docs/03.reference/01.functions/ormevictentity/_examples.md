```luceescript
// Evict all cached Product instances
ORMEvictEntity( "Product" );

// Evict a specific instance
ORMEvictEntity( "Product", "abc-123" );
```
