```luceescript+trycf
	// the below code formats the date & show all the parts as two digits
	writedump(dateFormat(now(), 'yy-mm-dd'));

	//Day of the week as a three-letter abbreviation.
	writedump(dateFormat(now(), 'ddd,dd/mm/yyyy'));

	//Day of the week as its full name.
	writedump(dateFormat(now(), 'dddd,dd/mm/yyyy'));

	// the below code formats the month as short string notation
	writedump(dateFormat(now(), 'yyyy/mmm/dd'));

	// the below code formats the date & separate date parts with dot
	writedump(dateFormat(now(), 'yyyy.mmm.dd'));

	// the below code formats the date & show the full month in string
	writedump(dateFormat(now(), 'yyyy-mmmm-dd'));

	// the below code returns the date with the format of full, long, medium, short
	dt=createDate(2018);
	writedump(dateFormat(dt,"full"));
	writedump(dateFormat(dt,"long"));
	writedump(dateFormat(dt,"medium"));
	writedump(dateFormat(dt,"short"));

	//Member function, able to format the date as normal function with all possibilities
	d1=createDate(2018,07,25)
	writeDump(d1.dateFormat("MM/DD/YYYY"));
	writeDump(d1.dateFormat("dddd,MM/DD/YYYY"));
```
