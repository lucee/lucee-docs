```luceescript+trycf
myquery = query(
  columnName1: [1,2,3],
  columnName2: [4,5,6]
);
dump(myquery);

column = "size";
values = ["small","medium","large"];
myquery = query(
  "#column#": values,
  column: values
);
dump(myquery);

myquery = query(
  columnName: []
);
dump(var=myquery, label="empty query");

myquery = query();
dump(var=myquery, label="no-argument query");
```
