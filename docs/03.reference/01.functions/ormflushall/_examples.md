```luceescript
// Save entities to different datasources, then flush all at once
entitySave( entityNew( "Auto", { id: createUUID(), make: "Toyota" } ) );
entitySave( entityNew( "Dealership", { id: createUUID(), name: "City Motors" } ) );
ORMFlushAll();
```
