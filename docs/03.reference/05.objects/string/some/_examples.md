```luceescript+trycf
	myString="lucee";
	callback=(x)=>x >= 'a';
	writeDump(myString.some(callback));

	callback_1=(x)=>x >= 'z';
	writeDump( myString.some(callback_1));
```