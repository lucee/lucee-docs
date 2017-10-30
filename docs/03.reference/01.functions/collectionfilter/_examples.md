```luceescript+trycf
people = [ { name = "Alice", age = 32 }, { name = "Bob", age = 29 }, { name = "Eve", age = 41 }];

dump(CollectionFilter(people, function(p) { return p.age > 30; }));

// member function
dump(people.filter(function(p) { return p.age > 30; }));
```
