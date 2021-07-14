```luceescript+trycf
	people = QueryNew( "name,dob,age", "varchar,date,int", [
	    [ "Susi", CreateDate( 1970, 1, 1 ), 0 ],
	    [ "Urs" , CreateDate( 1995, 1, 1 ), 0 ],
	    [ "Fred", CreateDate( 1960, 1, 1 ), 0 ],
	    [ "Jim" , CreateDate( 1988, 1, 1 ), 0 ]
	]);
	date=createDateTime(2016,3,13,17,0,0);
	totalAge = queryreduce( people,function(age=0, row, rowNumber, recordset ){
	    return age + DateDiff( 'yyyy', recordset.dob, date );
	});
	writeDump(totalAge);
```
