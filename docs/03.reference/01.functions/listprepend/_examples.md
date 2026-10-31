```luceescript+trycf
//Simple Example
writeoutput(listPrepend("Susi,LAS,,lucee,,,test","Inserted"));

//Member Function
strList=",I,,love,lucee,,";
writeDump(strList.listPrepend("First"));
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listPrepend( "2, 3", 1, ", ", true, true ) ); // 1, 2, 3
```
