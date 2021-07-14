### uses a closure to determine if an item or expression exists

```luceescript+trycf
	newArray = ['a','b','c','b','d','b','e','f'];
	dump(newArray);

	hasSome1 = arraySome(newArray,function(item,idx,arr){
	    return item == 'b';
	});
	dump(hasSome1);

    // member function
	hasSome2 = newArray.some(function(item,idx,arr){
	    return item == 'k';
	});
	dump(hasSome2);

```
