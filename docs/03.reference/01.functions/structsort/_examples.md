### Member Function

```luceescript+trycf
animals = {
	cow: {
		total: 12
	},
	pig: {
		total: 5
	},
	cat: {
		total: 3
	}
};

// Show current animals
Dump(
	label: "Current animals",
	var: animals
);

// Show animals sorted by total
Dump(
	label: "Animals sorted by total",
	var: animals.sort("numeric", "asc", "total")
);
```

### Non-Member Function

```luceescript+trycf
animals = {
	cow: {
		total: 12
	},
	pig: {
		total: 5
	},
	cat: {
		total: 3
	}
};

// Show current animals
Dump(
	label: "Current animals",
	var: animals
);

// Show animals sorted by total
Dump(
	label: "Animals sorted by total",
	var: StructSort(animals, "numeric", "asc", "total")
);
```
