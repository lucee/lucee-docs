### Gets a sub section of an array and returns it
```luceescript+trycf
	newArray = ['a','b','c','b','d','b','e','f'];
	dump(newArray);
	
	hasSome1 = arraySlice(newArray,1,4);
	dump(hasSome1);
	
    // member function
	hasSome2 = newArray.slice(3,6);
	dump(hasSome2);
```
