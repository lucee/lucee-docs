```luceescript+trycf
    testQuery = queryNew( "name , age" , "varchar , numeric" , { name: [ "Susi" , "Urs" ] , age: [ 20 , 24 ] } );
    newTestQuery = queryNew( "name , age" , "varchar , numeric" , [ [ "Smith" , 20 ] , [ "John", 24 ] ]);
    queryAppend(testQuery, newTestQuery);
    writeDump(testQuery);
```
