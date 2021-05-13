```luceescript+trycf
	newArray = ['a','b','c','b','d','b','e','f'];
	writedump(newArray);
	testOne = newArray.some(function(item,idx,arr){
	    return item == 'c';
	});
	writedump(testOne);
	testTwo = newArray.some(function(item,idx,arr){
	    return item == 'k';
	});
	writedump(testTwo);
```
