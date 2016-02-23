### Member Function

```luceescript+trycf
	animals = {
		cow: "moo",
		pig: "oink"
	};

	animalCount = animals.count();

	echo("There are " & animalCount & " animal(s) in the 'animals' struct");
```

### Non-Member Function

```luceescript+trycf
	animals = {
		cow: "moo",
		pig: "oink"
	};

	animalCount = StructCount(animals);

	echo("There are " & animalCount & " animal(s) in the 'animals' struct");
```
