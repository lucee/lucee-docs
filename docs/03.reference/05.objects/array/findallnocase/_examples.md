```luceescript+trycf
	myarray = ["one","two","three","TWO","five","Two"];
	writeDump(myarray);
	res = myarray.findallnocase("TWO");
	writeDump(res);
	res = myarray.findallnocase("one");
	writeDump(res);
```
