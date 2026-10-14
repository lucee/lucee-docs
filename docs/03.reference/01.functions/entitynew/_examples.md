```luceescript
// Create an empty entity and set properties
user = entityNew( "User" );
user.setName( "Susi Sorglos" );
user.setEmail( "susi@example.com" );
entitySave( user );
ormFlush();

// Create with properties struct
product = entityNew( "Product", { name: "Widget", price: 9.99 } );
entitySave( product );
ormFlush();
```
