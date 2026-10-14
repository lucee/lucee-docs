```luceescript
// Detach all entities, then reattach one
user = entityLoadByPK( "User", 42 );
ormClearSession();

// user is now detached — merge it back
merged = entityMerge( user );
// use 'merged', not 'user' — merged is the persistent instance
merged.setName( "Updated" );
ormFlush();
```
