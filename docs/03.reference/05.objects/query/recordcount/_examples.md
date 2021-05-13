
```luceescript+trycf
q = queryNew( "id,name","int,varchar");
q.addRow(2);
q.setCell("id", 1, 1);
q.setCell("id", 2, 2);
q.setCell("name", "one", 1);
q.setCell("name", "two", 2);
dump(q);
writeDump(q.recordcount());
q.addRow(2);
writeDump(q.recordcount());
q.addRow(2);
writeDump(q.recordcount());
```
