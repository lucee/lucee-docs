```luceescript+trycf
mylist = "Save|Water|Plant|green";
filterResult = listFilter(mylist,
	function(element, idx){
		if(element != "water" ){
			return true;
		}
		return  false;
	}, "|"
);
writeDump(filterResult);


//Member Function
listVal="one,two,three,four,five";
res=listVal.listFilter(
	function(elem,ind){
		if(elem!="three"){
			return  true;
		}
		return  false;
	});
writeDump(res);
```