```luceescript+trycf
	testQuery1 = QueryNew('col1');
	testQuery2 = queryNew( "name , age" , "varchar , numeric" , { name: [ "Susi" , "Urs" ] , age: [ 20 , 24 ] } );

	writedump(queryIsEmpty(testQuery1));
	writedump(queryIsEmpty(testQuery2));
```