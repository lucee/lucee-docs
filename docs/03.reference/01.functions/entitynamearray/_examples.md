```luceescript
entities = entityNameArray();
// [ "User", "Product", "Order" ]

for ( name in entities ) {
	systemOutput( "Mapped entity: #name#", true );
}
```
