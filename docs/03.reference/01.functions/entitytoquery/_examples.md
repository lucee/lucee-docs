```luceescript
// Convert an array of entities to a query
users = entityLoad( "User" );
qUsers = entityToQuery( users );
writeDump( qUsers );

// Convert a single entity
user = entityLoadByPK( "User", 42 );
qUser = entityToQuery( user );
```
