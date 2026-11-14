```luceescript+trycf
lst = "cat,mouse,dog,cat,cow,goat,sheep,cat,dog";
writeoutput(lst);
writeoutput("<hr>");
// new list with duplicates removed
lst = ListRemoveDuplicates(lst);
writeoutput(lst);
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listRemoveDuplicates( "a::b::a", "::", false, true ) ); // a::b
```
