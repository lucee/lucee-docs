```luceescript+trycf
    testVar = "Hello World";
    // Returns false as it is not a query.
    dump(IsQuery(testVar));

    testQuery = QueryNew('col1');
    // Returns true as it is a query.
    dump(IsQuery(testQuery));
```
