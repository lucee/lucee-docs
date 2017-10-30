```luceescript+trycf
people = [ { name = "Alice", age = 32 }, { name = "Bob", age = 29 }, { name = "Eve", age = 41 }];

dump(CollectionSome(people, function(p) { return p.age > 40; })); // true

// member function
dump(people.some(function(p) { return p.age < 20; })); // false
```
