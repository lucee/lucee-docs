```luceescript+trycf
	people = QueryNew(
	"name,dob,age", "varchar,date,int",
	[
		[ "Susi", CreateDate( 1970, 1, 1 ), 0 ],
		[ "Urs" , CreateDate( 1995, 1, 1 ), 0 ],
		[ "Fred", CreateDate( 1960, 1, 1 ), 0 ],
		[ "Jim" , CreateDate( 1988, 1, 1 ), 0 ]
	]
	);
	dump( var=people, label="people - original query" );
	/* Output:
	| name | dob                 | age |
	------------------------------------
	| Susi | 1970-01-01 00:00:00 | 0   |
	| Urs  | 1995-01-01 00:00:00 | 0   |
	| Fred | 1960-01-01 00:00:00 | 0   |
	| Jim  | 1988-01-01 00:00:00 | 0   |
	*/

	// intitialise age as a second argument
	totalAge = people.reduce( function(age, row, rowNumber, recordset ){
	    return age +  DateDiff( 'yyyy', recordset.dob, Now() );
	},0);
	Dump( var=totalAge, label='people - total age' );

	/* Output:
	    totalAge = 167
	*/

	// intitialise age in closure
	totalAge = people.reduce( function(age=0, row, rowNumber, recordset ){
	    return age +  DateDiff( 'yyyy', recordset.dob, Now() );
	});

	// Here you can get NULL value if there is no recordset
	if( isNull(totalAge) ) {
	    totalAge = 0;
	}
	dump( var=totalAge, label='people - total age' );

	/* Output: if recordset exists else 0
	      totalAge = 167
	*/
```
