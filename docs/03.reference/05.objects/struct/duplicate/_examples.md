
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
writeDump(animals.duplicate(true));
writeDump(animals.duplicate());
```