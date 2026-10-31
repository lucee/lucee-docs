```luceescript+trycf
writeOutput(listDeleteAt("I,love,lucee,testFile", 4));//Expected output I,love,lucee

//Member Function
strList="This,is,a,the,test,file";
writeDump(strList.listDeleteAt(3));//Expected output This,is,the,test,file
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listDeleteAt( "a::b::c", 2, "::", false, true ) ); // a::c
```
