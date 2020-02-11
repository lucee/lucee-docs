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
	// Copy animals struct to farm
	farm = animals.copy();
	// Show farm, looks like animals
	Dump(
		label: "Farm after animals.copy()",
		var: farm
	);
	// Add another animal. Will not affect farm.
	animals.append({
		cat: "meow"
	});
	// Show animals, now includes cat
	Dump(
		label: "Animals with cat added",
		var: animals
	);
	// Show farm, does not have cat
	Dump(
		label: "Farm copied from animals before cat was added",
		var: farm
	);
```