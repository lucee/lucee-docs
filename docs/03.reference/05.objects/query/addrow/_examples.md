```luceescript+trycf
myQuery    = queryNew( "id,name");
addedRows  = myQuery.addRow( 3 ); // will return 3

myQuery.addRow([17,'added via array notation']);

anotherRow = myQuery.addRow();    // will return 4

myQuery.addRow({
    id:18,
    name:'added via struct notation'
});
dump(myQuery);
```