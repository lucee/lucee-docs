```luceescript+trycf

//Simple Example
writeoutput(listIndexExists("Susi,LAS,,lucee,,,test",3));

//Member Function
strList=",I,,love,lucee,,";
writeDump(strList.listIndexExists(6));//Not exists, returns false

```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listIndexExists( "a::b::c", 3, "::", false, true ) ); // true
```
