```luceescript
// Delete by loading first
user = entityLoadByPK( "User", 42 );
if ( !isNull( user ) )
	entityDelete( user );
ormFlush();

// Delete inside a transaction (recommended)
transaction {
	product = entityLoadByPK( "Product", "abc-123" );
	if ( !isNull( product ) )
		entityDelete( product );
}
```
