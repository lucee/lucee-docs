### Non-Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow"
};

// Show all animals
Dump(
	label: "All animals",
	var: animals
);

// Find cat in animals
findCat = StructFind(animals, "cat");

// Show results of findCat
Dump(
	label: "Results of StructFind(animals, ""cat"")",
	var: findCat
);

// If the key does not exist, we can set a default value. In this case a blank string.
findSnail = StructFind(animals, "snail", "");

// Show results of findSnail
Dump(
	label: "Results of StructFind(animals, ""snail"", """")",
	var: findSnail
);
```
