```luceescript+trycf
	letters = "abbcdB";
	callbackFunction = function(input){return input=="b";}

	result = letters.filter(callbackFunction);
	writeDump(result);

	result1 = "bob".filter(callbackFunction);
	writeDump(result1);
```
