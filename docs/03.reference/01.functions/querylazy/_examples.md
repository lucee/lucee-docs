
# Row at a time

The simplest form: the listener is called once per row, with a struct of column values.

```luceescript
queryLazy(
	sql: "select id, name from users order by id"
	,listener: function( row ){
		systemOutput( row.id & " " & row.name, true );
	}
);
```

# Block processing with blockfactor

When `blockfactor` is greater than 1, the listener receives a query (or array/struct, see `returnType`) of up to `blockfactor` rows at a time. This is much faster than row-at-a-time when streaming output or batching writes.

```luceescript
queryLazy(
	sql: "select id, name from users order by id"
	,listener: function( rows ){
		// rows is a query containing up to 500 rows
		loop query=rows {
			// process each row
		}
	}
	,options: { blockfactor: 500 }
);
```

# Aborting iteration

The listener can return `false` to stop iteration. The connection and cursor are closed cleanly.

```luceescript
var found = "";
queryLazy(
	sql: "select id, name from users order by id"
	,listener: function( row ){
		if ( row.name == "lucee" ) {
			found = row.id;
			return false;
		}
	}
);
```

# returnType options

`options.returnType` can be `query` (default), `array`, or `struct`. With `struct`, you must also pass `columnKey` to specify which column is used as the struct key.

```luceescript
queryLazy(
	sql: "select id, name from users order by id"
	,listener: function( rows ){
		// rows is a struct keyed by id, e.g. { "1": { id: 1, name: "..." }, ... }
	}
	,options: {
		blockfactor: 100
		,returnType: "struct"
		,columnKey: "id"
	}
);
```

# Bound parameters

Pass parameters as an array (with `?` placeholders) or a struct (with `:name` placeholders), same as `queryExecute()`.

```luceescript
queryLazy(
	sql: "select id, name from users where status = :status order by id"
	,listener: function( row ){
		systemOutput( row.name, true );
	}
	,params: { status: { value: "active", type: "varchar" } }
);
```
