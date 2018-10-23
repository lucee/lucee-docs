```luceescript+trycf
person = { first = "Babe", last = "Ruth"};
dump(person); // Babe Ruth
clone = duplicate(person);
dump(clone); // Babe Ruth
person.last = "Smith";
dump(person); // Babe Smith
dump(clone); // Babe Ruth
```
