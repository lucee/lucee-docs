```luceescript+trycf
	Dump(lsweek("{ts '2020-12-27 0:0:0'}",'#getLocale()#','CET'));
	Dump(lsweek("{ts '2020-12-27 0:0:0'}",'#getLocale()#'));

	date = createDateTime(2022,01,17,12,0,0,0,"UTC"); 
	// in CH Monday is the first day of the week
	Dump(lsWeek(date, "DE_CH", "Europe/Zurich"));
	// in Bagdad Monday is the third day of the week
	Dump(lsWeek(date, "ar_IQ", "Asia/Baghdad"));
	// in the US Monday is the second day of the week
	Dump(lsWeek(date, "EN_US", "America/Los_Angeles"));
```