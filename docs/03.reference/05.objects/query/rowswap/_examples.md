```luceescript+trycf
    qry = queryNew("id,name", "integer,varchar",
    [
        [1, "a"],
        [2, "b"],
        [3, "c"]
    ]);

    dump(qry);
    swapped = qry.rowSwap(2,3)
    dump(swapped);
```