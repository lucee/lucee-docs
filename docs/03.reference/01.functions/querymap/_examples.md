```luceescript+trycf
	people = QueryNew( "name,dob,age", "varchar,date,int", [
		[ "Susi", CreateDate( 1970, 1, 1 ), 0 ],
		[ "Urs" , CreateDate( 1995, 1, 1 ), 0 ],
		[ "Fred", CreateDate( 1960, 1, 1 ), 0 ],
		[ "Jim" , CreateDate( 1988, 1, 1 ), 0 ]
	]);
	res = queryMap(people, function( row, rowNumber, recordset ){
		    row['age'] = DateDiff( 'yyyy', row.dob, CreateDate( 2016, 6, 9 ) )+1;
		    return row;
		});
	writeDump(res);
```
