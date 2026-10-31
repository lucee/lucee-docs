```luceescript+trycf
writeOutput(listInsertAt("a,,b,c,",1,"one"));

//Member Function with @ delimiter
strList="a@b@d";
writeDump(strList.listInsertAt(3,"c","@"));
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listInsertAt( "1, 3", 2, 2, ", ", false, true ) ); // 1, 2, 3
```
