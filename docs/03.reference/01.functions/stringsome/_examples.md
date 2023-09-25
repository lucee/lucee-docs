```luceescript+trycf
	myString="lucee";
	callback=(x)=>x >= 'a';
	writeDump(StringSome(myString, callback));

	callback_1=(x)=>x >= 'z';
	writeDump( StringSome(myString,callback_1));
```