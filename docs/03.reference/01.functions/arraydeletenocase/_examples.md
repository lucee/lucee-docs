```luceescript+trycf
	arr=['lucee','SUSI'];
	writeDump(var=arr,label="Before");
	arrayDeleteNoCase(arr, 'suSi');
	writeDump(var=arr,label="After");//lucee
	arrNew=['a','Ab','c','A','a'];
	writeDump(var=arrNew,label="Before");
	arrayDeleteNoCase(arrNew, 'a',"all");
	writeDump(var=arrNew,label="After");
```