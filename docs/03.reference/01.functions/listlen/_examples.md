```luceescript+trycf
	writeDump(listLen("susi,sam,LAS,test"));//4
	writeDump(listLen("susi,,LAS,,"));//with empty values
	writeDump(listLen("susi,,LAS,,."));//3
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listLen( "a::b::c", "::", false, true ) ); // 3
```
