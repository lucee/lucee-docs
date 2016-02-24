### Member Function

```luceescript+trycf
animals = {
	cow: {
		noise: "moo",
		size: "large"
	},
	pig: {
		noise: "oink",
		size: "medium"
	},
	cat: {
		noise: "meow",
		size: "small"
	}
};

// Show all animals
Dump(
	label: "All animals",
	var: animals
);

// Create map of noises
animalNoises = animals.map(function(key, value) {
	return value.noise;
});

// Show map of animalNoises
Dump(
	label: "Results animalNoises - animals.map(...)",
	var: animalNoises
);
```

### Non-Member Function

```luceescript+trycf
animals = {
	cow: {
		noise: "moo",
		size: "large"
	},
	pig: {
		noise: "oink",
		size: "medium"
	},
	cat: {
		noise: "meow",
		size: "small"
	}
};

// Show all animals
Dump(
	label: "All animals",
	var: animals
);

// Create map of noises
animalNoises = StructMap(animals, function(key, value) {
	return value.noise;
});

// Show map of animalNoises
Dump(
	label: "Results animalNoises - StructMap(animals,..)",
	var: animalNoises
);
```