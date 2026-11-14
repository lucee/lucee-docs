```luceescript
user = entityLoadByPK( "User", 42 );
user.setName( "Temporary change" );

// Discard in-memory change, reload from database
entityReload( user );
// user.getName() is back to the database value
```
