### Non-Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow",
	bird: "chirp"
};

// Check to see if key exists in struct
if (
	StructKeyExists(animals, "snail")
) {
	echo("There is a snail in 'animals'");
} else {
	echo("No snail exists in 'animals'");
}
```