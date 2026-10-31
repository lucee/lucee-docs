```luceescript+trycf
writeOutput(listFind("I,love,lucee,testFile", "lucee"));//Expected output 3

//Member Function with @ delimiter
strList="I@am@lucee@dev";
writeDump(strList.listFind("dev","@"));//Expected output 4
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listFind( "a::b::c", "b", "::", false, true ) ); // 2
```
