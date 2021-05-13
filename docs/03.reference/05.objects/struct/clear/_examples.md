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
	// Clear struct
	animals.clear();
	// Show animals, now empty
	Dump(
		label: "Animals after calling struct.clear()",
		var: animals
	);
```
