```luceescript+trycf
    qry= queryNew( "name , age" , "varchar , integer" , [ [ "Susi" , 20 ] , [ "Urs", 24 ] ]);

    writeOutput("Before changing the QueryColumn name : ");
    writeDump(qry);

    qry.renameColumn( "name", "employee" );

    writeOutput("After changing the QueryColumn name : ");
    writeDump(qry);
```