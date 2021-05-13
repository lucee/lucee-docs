```luceescript+trycf
myQuery = QueryNew( '' );
names = [ 'xxxx','yyyy'];
queryAddColumn( myQuery,'name','varchar',names );
result = queryColumnData( myQuery,'name' );
writeDump(result);
```
