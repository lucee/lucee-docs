```luceescript+trycf
writeOutput(listFindNoCase("I,love,lucee,testFile", "LUCEE"));//Expected output 3

//Member Function with @ delimiter
strList="I@am@lucee@dev";
writeDump(strList.listFindNoCase("Dev","@"));//Expected output 4
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listFindNoCase( "a::b::c", "B", "::", false, true ) ); // 2
```
