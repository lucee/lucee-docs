```luceescript+trycf
	qry = queryNew( "id, name","cf_sql_integer, cf_sql_varchar", [ [ 1, "Tricia" ],[ 2, "Sarah" ],[ 3, "Joanna" ]] );
	writeDump(qry);
	testQueryEach='';
	qry.Each(function(struct row,numeric rowNumber,query query){
		testQueryEach&=row.id&":"&row.name&":"&rowNumber&';';
	});
	writeDump(testQueryEach);
```
