```luceescript
// Evict all cached "items" collections on Category
ORMEvictCollection( "Category", "items" );

// Evict the collection for a specific Category instance
ORMEvictCollection( "Category", "items", "cat-123" );
```
