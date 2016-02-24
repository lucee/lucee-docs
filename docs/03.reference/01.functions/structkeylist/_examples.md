### Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow",
	bird: "chirp"
};

// animals.keyList()
animalList = animals.keyList();

echo(animalList);
```

### Non-Member Function

```luceescript+trycf
animals = {
	cow: "moo",
	pig: "oink",
	cat: "meow",
	bird: "chirp"
};

// StructKeyList(animals)
animalList = StructKeyList(animals);

echo(animalList);
```