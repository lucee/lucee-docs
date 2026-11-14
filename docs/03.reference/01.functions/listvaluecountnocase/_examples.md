```luceescript+trycf
List = "lucee,ACF,luceeExt,lucee, ext,LUCEEEXT";
writeDump(ListValueCount(list, "lucee")); // It return's 2
writeDump(ListValueCount(list, "luceeExt")); // It return's 2 because it case Insensitive
List2 = "lucee@ACF@luceeExt@lucee@ext@LUCEEEXT";
writeDump(ListValueCount(list2, "lucee", "@"));
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listValueCountNoCase( "a::b::A", "a", "::", false, true ) ); // 2
```
