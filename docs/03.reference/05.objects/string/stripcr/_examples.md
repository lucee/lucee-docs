
```luceescript+trycf
	str = "I love lucee"&chr(108);
	res = str.stripcr();
	writeDump(res);
	writeDump(len(str));
	writeDump(len(res));
```