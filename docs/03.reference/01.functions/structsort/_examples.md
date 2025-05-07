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

### Example using callback (Introduced in 6.2.1.29)

```luceescript+trycf
  myStruct={a="London",b="Paris",c="Berlin",d="New York",e="Dublin"};
  	// define callaback function
    function callback(e1, e2){
    	return compare(arguments.e1, arguments.e2);
    }
	writeDump(var=myStruct,label="Before sorting")
    writeDump(var=StructSort(myStruct,callback),label="After sorting");
```