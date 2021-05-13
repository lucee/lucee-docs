
```luceescript+trycf
	List = "lucee,ACF,luceeExt,lucee,lucee, ext,LUCEEEXT";
	writeDump(list.ListValueCount("lucee"));
	writeDump(ListValueCount(list, "luceeExt"));
	writeoutput("<br>");
	List2 = "lucee@ACF@luceeExt@lucee@ext@LUCEEEXT";
	writeDump(list2.ListValueCount("lucee", "@"));
```
