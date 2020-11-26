### Unordered Structs (default)

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow",
	bird: "chirp"
};
dump(animals.keyArray());
```

### Ordered Structs

```luceescript+trycf
animals = [
	cow: "moo",
	pig: "oink",
	cat: "meow",
	bird: "chirp"
];
dump(animals.keyArray());
```