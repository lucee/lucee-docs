```luceescript+trycf
// array
people = [ { name = "Alice", age = 32 }, { name = "Bob", age = 29 }, { name = "Eve", age = 41 }];

dump(CollectionMap(people, function(p) { return p.name; }));

// member function
dump(people.map(function(p) { return p.name; }));

// struct
person = { name = "Alice", age = 32, email = "alice@example.com" };

dump(CollectionMap(person, function(key,value) { return isnumeric(value); }));

// member function
dump(person.map(function(key,value) { return isnumeric(value); }));
```
