### Non-Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink"
};

// Show current animals
Dump(
	label: "Current animals",
	var: animals
);

// Insert cat into animals
StructInsert(animals, "cat", "meow");

// Show animals, now includes cat
Dump(
	label: "Animals with cat added",
	var: animals
);
```
