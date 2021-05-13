```luceescript+trycf
	animals = {
	    cow: "moo",
	    pig: "oink",
	    cat: "meow"
 	 };
	// Show current animals
	Dump(
		label: "Current animals",
		var: animals
	);
	// Delete the key 'cat' from struct
	animals.delete("cat");
	// Show animals, cat has been deleted
	Dump(
		label: "Animals with cat deleted",
		var: animals
	);
```
