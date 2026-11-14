```luceescript
// Outside any transaction
isWithinORMTransaction(); // false

transaction {
	isWithinORMTransaction(); // true
	entitySave( entityNew( "User", { name: "Susi" } ) );
}

isWithinORMTransaction(); // false
```
