```luceescript+trycf
	people = QueryNew( "name,dob,age", "varchar,date,int", [
		[ "Susi", CreateDate( 1970, 1, 1 ), 0 ],
		[ "Urs" , CreateDate( 1995, 1, 1 ), 0 ],
		[ "Fred", CreateDate( 1960, 1, 1 ), 0 ],
		[ "Jim" , CreateDate( 1988, 1, 1 ), 0 ]
	]);
	valid = querySome(people,function(row, rowNumber, qryData){
	    return ((DateDiff('yyyy', row.dob, Now()) > 0) && (DateDiff('yyyy', row.dob, Now()) <= 100))
	});
	writeDump(valid);
```
