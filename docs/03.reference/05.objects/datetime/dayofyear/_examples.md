
```luceescript+trycf
	date = now();
	writeDump("The number of days of the current year is "& date.dayOfYear("HST"));
	writeDump("<br>The number of days of the current year is "& date.dayOfYear());
	datetime = createdate(1997,04,11);
	writeDump("<br>The number of days of the year is "& datetime.dayOfYear());
```