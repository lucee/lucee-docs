```luceescript+trycf
writeOutput(listFirst("lucee,dev,LAS"));//Expected output lucee

//Member Function with @ delimiter
strList="dev@LAS@lucee";
writeDump(strList.listFirst("@"));//Expected output dev
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listFirst( "a::b::c", "::", false, 1, true ) ); // a
```
