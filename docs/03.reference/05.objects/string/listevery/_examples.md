
```luceescript+trycf
	fruits = "apple,pear,orange";
	fruits.ListEvery(function(value, index, list) {
		writeDump(index);
		writeDump(value);
		writeDump(list);
		return true;
	});
```