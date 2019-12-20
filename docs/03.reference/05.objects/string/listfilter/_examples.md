```luceescript+trycf
	listVal = "one,two,three,four,five";
	res = listVal.listFilter(
	function(elem,ind){
		if(elem != "three"){
			return  true;
		}
		return  false;
	});
	writeDump(res);
```