
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
findMediumAnimal = animals.findValue("medium");
// Show results in findMediumAnimal
Dump(
	label: "Results of animals.findValue(""medium"")",
	var: findMediumAnimal
);
```
