### Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow"
};

// Use every() to iterate over keys in struct. Closure returns true/false.
allAnimalsAreNoisy = animals.every(function(key) {
	// If the key has a value return true (noisy animal)
	if (animals[arguments.key].len()) {
		return true;
	}

	return false;
});

Dump(
	label: "allAnimalsAreNoisy",
	var: allAnimalsAreNoisy
);

// Use every() to iterate over keys in struct. Closure returns true/false.
allAnimalsAreQuiet = animals.every(function(key) {
	// If the key is blank return true (quiet animal)
	if (! animals[arguments.key].len()) {
		return true;
	}

	return false;
});

Dump(
	label: "allAnimalsAreQuiet",
	var: allAnimalsAreQuiet
);
```

### Non-Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow"
};

// Use StructEvery() to iterate over keys in struct. Closure returns true/false.
allAnimalsAreNoisy = StructEvery(animals, function(key) {
	// If the key has a value return true (noisy animal)
	if (Len(animals[arguments.key])) {
		return true;
	}

	return false;
});

Dump(
	label: "allAnimalsAreNoisy",
	var: allAnimalsAreNoisy
);

// Use StructEvery() to iterate over keys in struct. Closure returns true/false.
allAnimalsAreQuiet = StructEvery(animals, function(key) {
	// If the key is blank return true (quiet animal)
	if (! Len(animals[arguments.key])) {
		return true;
	}

	return false;
});

Dump(
	label: "allAnimalsAreQuiet",
	var: allAnimalsAreQuiet
);
```
