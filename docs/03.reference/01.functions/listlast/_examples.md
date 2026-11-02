```luceescript+trycf
//Simple Example
writeoutput(listLast("Susi ,LAS,,lucee,,,test"));

//Member Function
strList=",I,,love,lucee,,";
writeDump(strList.listLast());
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listLast( "a::b::c", "::", false, 1, true ) ); // c
```
