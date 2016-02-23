### Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow"
};

Dump(
	label: "All animals",
	var: animals
);

findCat = animals.find("cat");

Dump(
	label: "Results of animals.find(""cat"")",
	var: findCat
);

// If the key does not exist, we can set a default value. In this case a blank string.
findSnail = animals.find("snail", "");

Dump(
	label: "Results of animals.find(""snail"", """")",
	var: findSnail
);
```

### Non-Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow"
};

Dump(
	label: "All animals",
	var: animals
);

findCat = StructFind(animals, "cat");

Dump(
	label: "Results of StructFind(animals, ""cat"")",
	var: findCat
);

// If the key does not exist, we can set a default value. In this case a blank string.
findSnail = StructFind(animals, "snail", "");

Dump(
	label: "Results of StructFind(animals, ""snail"", """")",
	var: findSnail
);
```