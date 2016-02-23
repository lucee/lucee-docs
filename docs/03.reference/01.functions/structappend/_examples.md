### Member Function

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

	// Create a new animal
	newAnimal = {
		cat: "meow"
	};

	// Append to animals the newAnimal
	animals.append(newAnimal);

	// Show animals, now includes cat
	Dump(
		label: "Animals with cat added",
		var: animals
	);
```

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

	// Create a new animal
	newAnimal = {
		cat: "meow"
	};

	// Append to animals the newAnimal
	StructAppend(animals, newAnimal);

	// Show animals, now includes cat
	Dump(
		label: "Animals with cat added",
		var: animals
	);
```
