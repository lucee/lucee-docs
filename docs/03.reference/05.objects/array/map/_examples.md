```luceescript+trycf
	aNames = ["Marcus","Sarah","Josefine"];
	writedump(aNames);
	newNames2 = aNames.map(function(item,index,arr){
	    return {'name':item};
	});
	writedump(newNames2);
```