```luceescript+trycf
	list=",,a,,b,c,,e,f";
	res=list.ListSome( function(value ){return value !='a';},',',false,true, true);
	writeDump(res);
	res=list.ListSome( function(value ){return value =='z';},',',false,true,false);
	writeDump(res);
```