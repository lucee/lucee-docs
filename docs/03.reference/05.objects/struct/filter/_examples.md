
```luceescript+trycf
	animals = {
		cow: "moo",
		pig: "oink",
		snail: ""
	};
	// Show all animals
	Dump(
		label: "All animals",
		var: animals
	);
	// Get animals that make noise
	noisyAnimals = animals.filter(function(key) {
		// If the key has a value return true (noisy animal)
		if (animals[arguments.key].len()) {
			return true;
		}
		return false;
	});
	Dump(
		label: "Noisy Animals",
		var: noisyAnimals
	);
	// Get animals that are quiet
	quietAnimals = animals.filter(function(key) {
		// If the key has a value return true (quiet animal)
		if (! animals[arguments.key].len()) {
			return true;
		}
		return false;
	});
	Dump(
		label: "Quiet Animals",
		var: quietAnimals
	);
```
