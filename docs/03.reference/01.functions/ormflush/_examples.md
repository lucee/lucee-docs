```luceescript
// Explicit flush
product = entityNew( "Product", { name: "Widget", price: 9.99 } );
entitySave( product );
ormFlush();

// Flush a specific datasource
ormFlush( "inventoryDB" );

// Preferred: use a transaction instead
transaction {
	entitySave( entityNew( "Product", { name: "Gadget", price: 19.99 } ) );
	// commit flushes automatically
}
```
