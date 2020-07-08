```luceescript+trycf
	dateTime = now();
	writeDump(datetime.compare("11/04/1997"));
	dateTimeone = "11/04/1997";
	writeDump(dateTimeone.compare("11/04/1997"));
	dateTimetwo = "27/10/1996";
	writeDump(dateTimetwo.compare(now()));
	dateTimet1= createDateTime(1997,04,11,08,10,00);
	dateTimet2= createDateTime(1997,04,11,08,15,00);
	writeDump(dateTimet1.compare(dateTimet2));
```