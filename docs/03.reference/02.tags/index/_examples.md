### Index files from a directory

```luceescript
cfindex(
	action="update",
	collection="myCollection",
	type="path",
	key=expandPath( "/docs" ),
	urlpath="/docs",
	extensions=".html,.htm,.pdf,.txt",
	recurse="yes"
);
```

### Index a single file

```luceescript
cfindex(
	action="update",
	collection="myCollection",
	type="file",
	key=expandPath( "/docs/getting-started.html" ),
	urlpath="/docs"
);
```

### Index query results

```luceescript
cfindex(
	action="update",
	collection="myCollection",
	type="custom",
	query="articles",
	key="id",
	title="headline",
	body="content",
	custom1="author"
);
```

### Refresh the entire index

Clears the existing index before re-adding — unlike `update`, which adds or overwrites individual entries.

```luceescript
cfindex(
	action="refresh",
	collection="myCollection",
	type="path",
	key=expandPath( "/docs" ),
	urlpath="/docs",
	extensions=".html,.htm",
	recurse="yes"
);
```

### Purge all documents

```luceescript
cfindex( action="purge", collection="myCollection" );
```

### List indexes in a collection

```luceescript
cfindex( action="list", collection="myCollection", name="indexes" );
dump( indexes );
```
