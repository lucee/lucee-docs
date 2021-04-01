```luceescript+trycf
	//format the date parts as like as dateformat()
	//formant the date & time by user defined date
	dateandtime = createDateTime(2015,02,04,11,22,33);
	writeDump(dateTimeFormat(dateandtime, "GG-dddd, dd/mmm/yyyy,hh:nn:ss tt,zzzz"));

	//formant the date & time by server time
	dateandtime = createDateTime(year(now()),month(now()),day(now()),hour(now()),minute(now()),second(now()));
	writeDump(dateTimeFormat(dateandtime, "dddd, dd/mmm/yyyy,hh:nn:ss tt,zzzz"));
	writedump(dateTimeFormat(now(), "mm/dd/yyyy"));	
	writedump(dateTimeFormat(now(), "MM/DD/YYYY"));
	writeDump(dateTimeFormat(now(), "EEEE-dd,mm,yyyy"));
	writeDump(dateTimeFormat(dateandtime, "epoch"));
	writeDump(dateTimeFormat(dateandtime, "epochms"));

	//Member function
	dt=createDate(2015,04,14);
	writedump(dt.dateTimeFormat("full"));
	writedump(dt.dateTimeFormat("long"));
	writedump(dt.dateTimeFormat("medium"));
	writedump(dt.dateTimeFormat("short"));
	writeDump(dt.dateTimeFormat("GG-dddd, dd/mmm/yyyy,hh:nn:ss tt,zzzz"));
	writeDump(now().dateTimeFormat("ISO8601"));
	writeDump(dt.dateTimeFormat("epoch"));
	writeDump(now().dateTimeFormat("epoch"));
	writeDump(dt.dateTimeFormat("epochms"));
	writeDump(now().dateTimeFormat("epochms"));
```