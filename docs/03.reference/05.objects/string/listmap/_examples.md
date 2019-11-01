
```luceescript+trycf
	language = "java,Lucee,javascript,jquery";
	externalList = "";
	reverselanguage = listMap( language, function(v,i,l) {
		var newValue = "#i#:#v.right(5)#";
		externalList = listappend(externalList,newValue);
		return newValue;
	});
	writeDump([{language=language},{reverselanguage=reverselanguage},{externalList=externalList}]);
```