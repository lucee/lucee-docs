<!--
{
  "title": "Lazy Queries",
  "id": "lazy_queries",
  "categories": [
    "query"
  ],
  "description": "How to use lazy queries",
  "keywords": [
    "Lazy Queries",
    "Regular Queries",
    "Performance",
    "Memory Optimization",
    "Lucee"
  ],
  "related": [
	"tag-query"
  ]
}
-->

# Lazy Queries

Regular queries load all data into memory upfront. Lazy queries keep a database pointer and load data on demand.

```luceescript
query name="qry" returntype="query" {
	echo("select * from lazyQuery");
}
dump(numberFormat(qry.getColumnCount()*qry.getRowCount()));
loop query=qry {
	dump(qry.val);
	if(qry.currentrow==10) break;
}
```

This loads all 200,000 records even though we only use 10.

## Lazy Query

```luceescript
query name="qry" returntype="query" lazy=true {
	echo("select * from lazyQuery");
}
loop query=qry {
	dump(qry.val);
	if(qry.currentrow==10) break;
}
```

With `lazy=true`, data loads as you iterate. Limitations:

- No record count until loop completes
- Cannot use query caching

Benefits: faster startup, lower memory usage.

## Performance

```luceescript
types=['regular':false,'lazy':true];
results=structNew("ordered");
loop struct=types index="type" item="lazy" {
	loop from=1 to=10 index="i" {
		start=getTickCount('nano');
		query name="qry" returntype="query" lazy=lazy {
			echo("select * from lazyQuery");
		}
		x=qry.val;
		time=getTickCount('nano')-start;

		if(isNull(results[type]) || results[type]>time)results[type]=time;
	}
}
// format results
results.regular=decimalFormat(results.regular/1000000)&"ms";
results.lazy=decimalFormat(results.lazy/1000000)&"ms";
dump(results);
```

Typical results: regular ~41ms, lazy ~27ms.

Video: [Lazy Query](https://youtu.be/X8_TB1py8n0)
