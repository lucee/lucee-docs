```luceescript+trycf
// Reduces names to a key or code based on their English pronunciation, such that similar sounding names share the same key; see also Metaphone()
name1 = soundex(str = "Smith");
name2 = soundex(str = "Smythe");
name3 = soundex(str = "Smithfield");
dump(name1); // S530
dump(name2); // S530
dump(name3); // S531
```
