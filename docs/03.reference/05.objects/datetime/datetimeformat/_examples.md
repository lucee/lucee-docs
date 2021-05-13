```luceescript+trycf
	// the below code formats the date & show all the parts as two digits
	dateTime = now();
	writedump(dateTime.dateFormat('yy-mm-dd'));
	//Day of the week as a three-letter abbreviation.
	writedump(dateTime.dateFormat('ddd,dd/mm/yyyy'));
	//Day of the week as its full name.
	writedump(dateTime.dateFormat('dddd,dd/mm/yyyy'));
	// the below code formats the month as short string notation
	writedump(dateTime.dateFormat('yyyy/mmm/dd'));
	// the below code formats the date & separate date parts with dot
	writedump(dateTime.dateFormat('yyyy.mmm.dd'));
	// the below code formats the date & show the full month in string
	writedump(dateTime.dateFormat('yyyy-mmmm-dd'));
	// the below code returns the date with the format of full, long, medium, short
	dt=createDate(1997,04,11);
	writedump(dt.dateFormat("full"));
	writedump(dt.dateFormat("long"));
	writedump(dt.dateFormat("medium"));
	writedump(dt.dateFormat("short"));
	//Member function, able to format the date as normal function with all possibilities
	d1=createDate(1996,10,27)
	writeDump(d1.dateFormat("MM/DD/YYYY"));
	writeDump(d1.dateFormat("dddd,MM/DD/YYYY"));
```
