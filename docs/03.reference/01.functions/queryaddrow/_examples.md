```luceescript+trycf
myQuery    = queryNew( "id,name");
addedRows  = queryAddRow(myQuery, 3); // will return 3

queryAddRow(myQuery, [17,'added via array notation']);

anotherRow = queryAddRow(myQuery);    // will return 4

queryAddRow(myQuery, {
    id:18,
    name:'added via struct notation'
});
dump(myQuery);
```
