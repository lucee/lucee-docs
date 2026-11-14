```luceescript+trycf
//Simple Example
writeoutput(listItemTrim("Susi , LAS  ,,lucee,,,test,,"));

//Member Function
strList=",I,      , love,lucee  ,,";
writeDump(strList.listItemTrim());

```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listItemTrim( "a :: b :: c", "::", false, true ) ); // a::b::c
```
