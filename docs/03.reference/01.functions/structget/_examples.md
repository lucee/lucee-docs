```luceescript+trycf
animals = {
	cat: {
		activities: {
		    sleep: true,
		    eat: true,
		    drink: true
		}
	}
};

// Show all animals
Dump(
	label: "All animals",
	var: animals
);

// Get cat activities in animals
getCatActivities = StructGet("animals.cat.activities");

// Show results of getCatActivities
Dump(
	label: "Results of StructGet(""animals.cat.activities"")",
	var: getCatActivities
);

// If the path does not exist, result returns an empty structure.
findDog = StructGet("animals.dog");

// Show results of findDog
Dump(
	label: "Results of StructGet(""animals.dog"")",
	var: findDog
);
```
