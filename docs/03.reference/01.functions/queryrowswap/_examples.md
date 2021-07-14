```luceescript+trycf
    qry = queryNew("id,name", "integer,varchar",[
    [1, "a"],
    [2, "b"],
    [3, "c"]
    ]);

    swapped = QueryRowSwap(qry,2,3)
    dump(swapped);
    dump(qry);
```
