### Non-Member Function

```luceescript+trycf
animals = {
	cow: {
	    noise: "moo",
	    size: "large"
	},
	"bird.noise": "chirp",
	"bird.size": "small"
};

// Show all animals
Dump(
	label: "All animals",
	var: animals
);

// Call function
StructKeyTranslate(animals);

// Show all animals after keyTranslate
Dump(
	label: "All animals after keyTranslate",
	var: animals
);
```
