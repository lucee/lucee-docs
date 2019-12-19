
```luceescript+trycf
q = queryNew( "id,name","int,varchar",[{"id":"1","name":"one"},{"id":"2","name":"two"}]);
dump(q);
writeDump(q.deletecolumn("id"));
writeDump(q);
```