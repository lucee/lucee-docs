```lucee+trycf
	list = "arabic (united arab emirates),arabic (jordan),hindi(India),arabic (syria),spanish (panama)";
	loop list="#list#" index="locale" delimiters="," {
		oldlocale = setLocale(locale);
		writeOutput("<h3>#locale#</h3>");
		writeoutput(lsTimeFormat(now()));writeOutput("<br>");
		writeoutput(lsTimeFormat(now(), 'hh:mm:ss'));writeOutput("<br>");
		writeoutput(lsTimeFormat(now(), 'hh:mm:sst'));writeOutput("<br>");
		writeoutput(lsTimeFormat(now(), 'hh:mm:sstt'));writeOutput("<br>");
		writeoutput(lsTimeFormat(now(), 'HH:mm:ss'));
	}
```
