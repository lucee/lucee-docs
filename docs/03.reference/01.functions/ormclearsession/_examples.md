```luceescript
// Flush first, then clear
ormFlush();
ormClearSession();

// Now entityLoadByPK will hit the database, not the session cache
freshUser = entityLoadByPK( "User", 42 );

// Clear a specific datasource session
ormClearSession( "inventoryDB" );
```
