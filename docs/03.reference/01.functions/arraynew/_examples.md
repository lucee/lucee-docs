```luceescript+trycf
### create a new array, set the dimension
  a = arrayNew(1);
    // Implicit array notation
    a.append([]);
    // with values
    a.append( [
        'a','b',
        3, 4,
        [],
        {complex: true},
        queryNew("id,date")
    ] );
    dump(a);
```