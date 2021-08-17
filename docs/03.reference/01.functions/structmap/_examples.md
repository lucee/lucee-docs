### structmap examples

```luceescript+trycf

	sct=structNew("linked");
		sct.a=1;
		sct.b=2;
		sct.c=3;
	writedump(var=sct, label="original struct");

	// base test
	res=StructMap(sct, function(key, value ){
 						return key&":"&value;
                        },true);
	writedump(var=res, label="mapped struct");
```