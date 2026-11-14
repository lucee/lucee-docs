### Create a collection

```luceescript
cfcollection(
	action="create",
	collection="myCollection",
	path=expandPath( "{lucee-config-dir}/collections/myCollection" ),
	language="english"
);
```

### Create a collection with category support

```luceescript
cfcollection(
	action="create",
	collection="myCollection",
	path=expandPath( "{lucee-config-dir}/collections/myCollection" ),
	language="english",
	categories="yes"
);
```

### List all collections

```luceescript
cfcollection( action="list", name="collections" );
dump( collections );
```

### Optimize a collection

```luceescript
cfcollection( action="optimize", collection="myCollection" );
```

### Delete a collection

```luceescript
cfcollection( action="delete", collection="myCollection" );
```
