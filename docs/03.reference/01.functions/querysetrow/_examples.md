```luceescript+trycf
    testQuery=queryNew("id,name", "integer,varchar",
        [
            {"id"=1,"name"="jenifer"},
            {"id"=2,"name"="ajay"},
            {"id"=3,"name"="john"},
            {"id"=4,"name"="smith"}
        ]);

    querySetRow(testQuery, 3, {"id"=5,"name"="alpha"});
    writeDump(testQuery);
```