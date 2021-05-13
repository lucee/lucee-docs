### Non-Member Function

```luceescript+trycf
animals = {
	cow: {
		noise: "moo",
		size: "large"
	},
	pig: {
		noise: "oink"
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

// Find "all" animal(s) containing key of 'size'
findAnimalsWithSize = StructFindKey(animals, "size", "all");

// Show results in findAnimalsWithSize
Dump(
	label: "Results of StructFindKey(animals, ""size"", ""all"")",
	var: findAnimalsWithSize
);
```
