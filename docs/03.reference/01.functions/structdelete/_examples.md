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

// Delete the key 'cat' from struct
StructDelete(animals, "cat");

// Show animals, cat has been deleted
Dump(
	label: "Animals with cat deleted",
	var: animals
);
```