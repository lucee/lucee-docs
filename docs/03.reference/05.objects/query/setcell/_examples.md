```luceescript+trycf
q = queryNew( "id,name");
q.addRow();

q.setCell("id", 1, 1);
q.setCell("name", "one", 1);

dump(q);
```
