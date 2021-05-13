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

// Find animal containing value of 'medium'
findMediumAnimal = StructFindValue(animals, "medium");

// Show results in findMediumAnimal
Dump(
	label: "Results of StructFindValue(animals, ""medium"")",
	var: findMediumAnimal
);
```
