```luceescript+trycf
// reduces names to a key or code based on their English pronunciation, such that similar sounding names share the same key.
name1 = metaphone(str = "Smith");
name2 = metaphone(str = "Smythe");
name3 = metaphone(str = "Smithfield");
dump(name1); // SM0
dump(name2); // SM0
dump(name3); // SM0F
```
