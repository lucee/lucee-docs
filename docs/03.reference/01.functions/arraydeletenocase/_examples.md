```luceescript+trycf
	arr=['lucee','SUSI'];
	writeDump(var=arr,label="Before");
	arr.DeleteNoCase('suSi');
	writeDump(var=arr,label="After");//lucee
//Member Function with scope
	arrNew=['a','Ab','c','A','a'];
	writeDump(var=arrNew,label="Before");
	arrNew.DeleteNoCase('a',"all");
	writeDump(var=arrNew,label="After");
```
