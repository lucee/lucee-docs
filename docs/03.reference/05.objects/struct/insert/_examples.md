
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
animals.insert("cat", "meow");
// Show animals, now includes cat
Dump(
	label: "Animals with cat added",
	var: animals
);
```