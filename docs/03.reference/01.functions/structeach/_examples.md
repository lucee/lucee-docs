### Non-Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow"
};

StructEach(animals, function(key) {
	// Show key 'arguments.key'
	Dump(
		label: "Key",
		var: arguments.key
	);

	// Show key's value 'animals[arguments.key]'
	Dump(
		label: arguments.key & "'s value",
		var: animals[arguments.key]
	);
});
```