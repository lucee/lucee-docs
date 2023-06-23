```luceescript+trycf
	letters = "I love lucee";
	callbackFunction = function(input){return input=="e";}

	result = letters.every(callbackFunction);
	writeDump(result);
	result1 = "Eee".every(callbackFunction);
	writeDump(result1);
```
