```luceescript+trycf

//Simple function with different delimiter(/)
writeOutput(listQualify("string/Lucee/susi/LAS","^","/")&"<br><br>");

//Member function
strList="Lucee,ColdFusion,LAS,SUSI";
writeDump(strlist.listQualify('|'));

```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listQualify( "a::b::c", "'", "::", "all", false, true ) ); // 'a'::'b'::'c'
```
