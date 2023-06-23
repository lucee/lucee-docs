```luceescript+trycf
	letters = "I love lucee";
	callbackFunction = function(input){return input=="e";}

	result = stringEvery(letters, callbackFunction);
	writeDump(result);
	result1 = stringEvery("Eee", callbackFunction);
	writeDump(result1);
```