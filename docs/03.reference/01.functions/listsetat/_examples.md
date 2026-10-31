```luceescript+trycf
list1 = ",a,b,c,d,e"
Dump(listSetAt(list1,"2", "Z"));
list2 = ",a||b||c||d||e"
Dump(listSetAt(list2,"2", "Z", "||"));
list3 = ",a,b,c,d,e"
Dump(listSetAt(list3,"2", "Z", ",",true)); //Because it includes empty field value ,Z,b,c,d,e
// MemberFunction

dump(list1.listSetAt("4", "Y")); //,a,b,c,Y,e
```

### Multi-character delimiter

By default every character of `delimiters` is a delimiter. With `multiCharacterDelimiter=true` the whole string is one delimiter.

```luceescript
writeOutput( listSetAt( "1, 2, 3", 2, "x", ", ", false, true ) ); // 1, x, 3
```
