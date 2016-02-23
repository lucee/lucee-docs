### Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow"
};

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