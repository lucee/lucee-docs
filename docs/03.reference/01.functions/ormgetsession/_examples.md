```luceescript
// Get the native Hibernate session
ormSess = ORMGetSession();

// Check for pending changes
if ( ormSess.isDirty() )
	systemOutput( "Session has unflushed changes", true );

// Check if a loaded entity is still in the session
user = entityLoadByPK( "User", 42 );
systemOutput( ormSess.contains( user ), true ); // true

// Get session statistics
stats = ormSess.getStatistics();
systemOutput( "Entities in session: #stats.getEntityCount()#", true );

// Get an entity's primary key dynamically
pk = ormSess.getIdentifier( user );
```
