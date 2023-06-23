```luceescript+trycf
	letters = "abbcdB";
	callbackFunction = function(input){return input=="b";}

	result = stringFilter(letters,callbackFunction);
	writeDump(result);

	result1 = stringFilter("bob",callbackFunction);
	writeDump(result1);
```
