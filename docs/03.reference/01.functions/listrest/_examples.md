```luceescript+trycf

writeOutput(listRest("string,Lucee,susi,LAS")&"<br><br>");

//Member function
strList="0,1,2,3,4";
writeDump(strlist.listRest());

```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listRest( "a::b::c", "::", false, 1, true ) ); // b::c
```
