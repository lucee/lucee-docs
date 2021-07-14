```luceescript+trycf
  testQuery = queryNew( "name , age" , "varchar , numeric" , { name: [ "Susi" , "Urs" ] , age: [ 20 , 24 ] } );
  dump(testQuery);
```