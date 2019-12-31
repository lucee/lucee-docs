```luceescript+trycf
	myquery = querynew("id,name");
	myquery.addrow();
	myquery.setcell("id","1");
	myquery.setcell("name","item1");
	myquery.addRow();
	myquery.setcell("id","2");
	myquery.setcell("name","item2");
	myquery.addColumn("age",listtoarray("20,21"));
	myquery.addColumn("class",listtoarray("A,B"));
	writeDump(myquery);
```