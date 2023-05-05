```luceescript+trycf
    qry= queryNew( "name , age" , "varchar , integer" , [ [ "Susi" , 24 ] , [ "Urs", 28 ] ]);

    writeOutput("Before changing the QueryColumn name : ");
    writeDump(qry);

    QueryRenameColumn( qry, "name", "employee" );

    writeOutput("After changing the QueryColumn name : ");
    writeDump(qry);
```