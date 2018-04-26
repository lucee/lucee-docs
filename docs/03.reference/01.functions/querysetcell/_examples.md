```luceescript+trycf
q = queryNew( "id,name");
QueryAddRow(q);

QuerySetCell(q, "id", 1, 1);
QuerySetCell(q, "name", "one", 1);

dump(q);
```