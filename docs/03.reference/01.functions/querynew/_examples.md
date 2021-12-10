```luceescript+trycf
 	testQuery = queryNew( "name , age" , "varchar , numeric" , { name: [ "Susi" , "Urs" ] , age: [ 20 , 24 ] } );
 	dump(testQuery); 

	qry= queryNew( "name , age" , "varchar , numeric" , [ [ "Susi" , 20 ] , [ "Urs", 24 ] ]);
  	dump(qry);

 	qry= queryNew( "name , age" , "varchar , numeric" , [ { name: "Susi" , age: 20 }, { name: "Urs" , age: 24 } ] );
  	dump(qry);

```
```