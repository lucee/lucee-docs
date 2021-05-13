### Non-Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow"
};

// Show current animals
Dump(
	label: "Current animals",
	var: animals
);

// Update cat in animals
StructUpdate(animals, "cat", "purr");

// Show animals with updated cat in animals
Dump(
	label: "Animals with cat updated",
	var: animals
);
```
