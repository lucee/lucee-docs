```luceescript+trycf
list = '1,7,,7,10,6,7,8';
dump( listGetDuplicates( list ) ); // returns 7
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listGetDuplicates( "a::b::a", "::", false, false, true ) ); // a
```
