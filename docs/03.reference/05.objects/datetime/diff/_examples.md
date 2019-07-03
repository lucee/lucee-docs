
```luceescript+trycf
	date = createDateTime(1997,04,11);
	echo( date.Diff("d", "1997-04-25") & "<br>"); // 1
	dateOne = createDate(1997,04,11);
	echo( dateOne.Diff("d", "1997-04-11") & "<br>"); // 0
	datetime = createDateTime(1992,12,11,01,00,00);
	echo( datetime.Diff("h", "1992-12-11 00:00:00") & "<br>"); // -1
```