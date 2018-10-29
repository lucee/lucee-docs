```luceescript+trycf
  fruits = "apple,pear,orange";
	ListEvery( fruits, function(value, index, list) {
	    writeDump(index);
	    writeDump(value);
	    writeDump(list);
	    return true;
	});
```
