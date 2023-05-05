```luceescript+trycf
    qry = queryNew( "name, age", "varchar, integer",
        [
            [ "Susi", 20 ],
            [ "Urs", 24 ],
            [ "Smith", 21 ],
            [ "John", 26 ]
        ]);
    writeOutput("Before QueryClear :");
    writeDump(qry);

    result = queryClear(qry);

    writeOutput("After QueryClear :");
    writeDump(qry);
```