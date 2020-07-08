```luceescript+trycf
people = [ { name = "Alice", age = 32 }, { name = "Bob", age = 29 }, { name = "Eve", age = 41 }];

CollectionEach(people, function(p) { dump(p.name); });

// member function
people.each(function(p) {
  dump(p.name);
});
```
