```luceescript+trycf
	fruits = "apple,pear,orange";
	writedump(fruits);
	fruitsPlural = listMap( fruits, function(value, index, list) {
	    return value & "s";
	});
	writedump(fruitsPlural);
```
