```luceescript+trycf
people = [ { name = "Alice", age = 32 }, { name = "Bob", age = 29 }, { name = "Eve", age = 41 }];

dump(CollectionEvery(people, function(p) { return p.age > 20; })); // true

// member function
dump(people.every(function(p) { return p.age > 30; })); // false
```
