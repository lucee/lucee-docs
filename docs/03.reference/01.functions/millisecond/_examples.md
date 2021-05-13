```luceescript+trycf
	//Below code returns the millisecond
	dateandtime = createDateTime(2015,02,04,11,22,33,86);
	writeDump(millisecond(dateandtime));

	//Below code returns the millisecond from local server time
	writeDump(millisecond(now()));

	//Member function
	dt = createDateTime(2015,02,04,11,22,33,86);
	writedump(dt.millisecond());
	writedump(now().millisecond("Asia/Calcutta"));
```
