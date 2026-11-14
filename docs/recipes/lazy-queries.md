<!--
{
  "title": "Lazy Queries",
  "id": "lazy_queries",
  "categories": [
    "query"
  ],
  "description": "How to stream large query result sets without loading everything into memory",
  "keywords": [
    "Lazy Queries",
    "Regular Queries",
    "Performance",
    "Memory Optimization",
    "Lucee"
  ],
  "related": [
	"function-querylazy",
	"function-queryclose",
	"tag-query"
  ]
}
-->

# Lazy Queries

Regular queries load all data into memory upfront. Lazy queries keep a database cursor open and stream rows on demand, which is useful for large report exports or any time the full result set is too big to materialise.

> **Note:** The `lazy=true` attribute on `cfquery` is **deprecated**. Use the [[function-querylazy]] function instead — it has the same streaming behaviour but a bounded connection lifecycle (the cursor is closed when the function returns) and a callback-based API that suits row-at-a-time processing.

## Recommended: queryLazy()

`queryLazy()` calls a listener function for each row (or each block of rows, if you set `blockfactor`). The listener can return `false` to stop iteration early.

```luceescript
queryLazy(
	sql: "select id, name, total from orders order by id"
	,listener: function( row ){
		systemOutput( row.id & " " & row.name & " " & row.total, true );
	}
);
```

### Block processing

Set `blockfactor` to receive rows in batches as a query, array, or struct. This is much more efficient than row-at-a-time when you're writing to a stream or sending to an external system.

```luceescript
queryLazy(
	sql: "select id, name, total from orders order by id"
	,listener: function( rows ){
		// rows is a query containing up to 500 rows
		loop query=rows {
			// write row to output
		}
	}
	,options: { blockfactor: 500 }
);
```

### Aborting early

```luceescript
var found = "";
queryLazy(
	sql: "select id, name from orders order by id"
	,listener: function( row ){
		if ( row.name contains "lucee" ) {
			found = row.id;
			return false; // stop iterating
		}
	}
);
```

## Deprecated: cfquery lazy=true

The `lazy` attribute on `cfquery` returns a query object backed by a live ResultSet. Iterating the query streams rows from the database, but the underlying connection is held until the request ends or [[function-queryclose]] is called.

```luceescript
query name="qry" returntype="query" lazy=true {
	echo("select * from lazyQuery");
}
loop query=qry {
	dump(qry.val);
	if(qry.currentrow==10) break;
}
queryClose( qry ); // release the connection
```

Limitations:

- No record count until iteration completes
- Cannot be combined with `cachewithin`, `cacheafter` or `result`
- Connection is held until the request ends unless `queryClose()` is called explicitly

Video: [Lazy Query](https://youtu.be/X8_TB1py8n0)
