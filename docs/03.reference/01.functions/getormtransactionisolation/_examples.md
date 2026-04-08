```luceescript
transaction isolation="serializable" {
	level = GetORMTransactionIsolation();
	systemOutput( "Isolation: #level#", true ); // "serializable"
	entitySave( entityNew( "User", { name: "Susi" } ) );
}
```
