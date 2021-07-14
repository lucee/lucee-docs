```luceescript+trycf
q = queryNew( "id,name","int,varchar");
q.addRow(4);
q.setCell("id", 1, 1);
q.setCell("id", 2, 2);
q.setCell("id", 3, 3);
q.setCell("id", 4, 4);
q.setCell("name", "one", 1);
q.setCell("name", "two", 2);
q.setCell("name", "three",3);
q.setCell("name", "four", 4);
dump(q);
dump(QueryRowData(q, 2));
```
