```luceescript+trycf
    testQuery = queryNew( "name , age" , "varchar , numeric" , { name: [ "Susi" , "Urs" ] , age: [ 20 , 24 ] } );
    writeOutput("The query:<br />");
    writeDump(testQuery);
    writeOutput("The reversed query:<br />");
    writeDump(testQuery.reverse());
```
