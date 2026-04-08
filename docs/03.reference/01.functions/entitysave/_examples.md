```luceescript
// Save a new entity
product = entityNew( "Product", { name: "Widget", price: 9.99 } );
entitySave( product );
ormFlush();

// Save inside a transaction (recommended)
transaction {
	user = entityNew( "User", { name: "Susi" } );
	entitySave( user );
	// commit flushes automatically
}

// Force insert — always INSERT, never UPDATE
product = entityNew( "Product", { id: createUUID(), name: "Gadget" } );
entitySave( product, true );
ormFlush();
```
