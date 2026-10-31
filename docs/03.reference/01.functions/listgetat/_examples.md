```luceescript+trycf
writeOutput(listGetAt("a,,b,c,",3,",",true));//Returns b

//Member Function with '/' delimiter
strList="/a//b/c//d";
writeDump(strList.listGetAt(5,"/",true));//Expected output c
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listGetAt( "a::b::c", 2, "::", false, true ) ); // b
```
