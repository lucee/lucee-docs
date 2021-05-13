```luceescript+trycf
	//Below code returns the month from the given date
	dateandtime = createDate(2015,02,04);
	writeDump(month(dateandtime));

	//Below code returns the month from local server time
	writeDump(month(now(),"Asia/Calcutta"));

	//Member function
	dt = createDate(2015,04,14);
	writedump(dt.month());
	writedump(now().month("Asia/Calcutta"));
```
