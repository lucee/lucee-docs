
```luceescript+trycf
	strList = "lucee,core,dev";
	writeDump(strList.ListGetAt(2));
	writeOutput("<br>");
	writeDump("$2$3$41$5".ListGetAt(1,'$',true))
	writeOutput("<br>");
	strListdeli = "adobe@coldfusion@lucee@";
	writeDump(strListdeli.ListGetAt(1,"@"));
```