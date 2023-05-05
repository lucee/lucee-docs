```luceescript+trycf
     qry1 = queryNew( "name, age", "varchar, integer",
        [
            [ "Susi", 20 ],
            [ "Urs", 24 ],
            [ "Smith", 21 ],
            [ "John", 26 ]
        ]);
    qry2 = queryNew( "name, age", "varchar, integer",
        [
            [ "Jeni", 19 ]
        ]);
    writeOutput("Before QueryInsert :");    
    writeDump(qry1);

    QueryInsertAt( qry1, qry2, 3 );

    writeOutput("After QueryInsert :");
    writeDump(qry1);
```