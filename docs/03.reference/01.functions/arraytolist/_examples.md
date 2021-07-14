### Convert an array to a list (optional delimiter)

```luceescript+trycf
	newArray = ['a','b','c','b','d','b','e','f'];
	dump(arrayToList(newArray));

    // member function, with custom separator
	dump(newArray.toList('--'));
```
