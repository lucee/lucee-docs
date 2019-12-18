
```luceescript+trycf
	numericList = "-1,-9,-6,5,0,2,8";
	writedump(numericList.listsort("numeric","asc"));
	writeoutput("<br>");
	strList = "Adobe,coldfusion,lucee,15,LAS";
	writedump(strList.listsort("text","asc"));
	writeoutput("<br>");
	strListOne = "Adobe@coldfusion@lucee@15@LAS";
	writedump(strListOne.listsort("textnocase","asc","@"));
```