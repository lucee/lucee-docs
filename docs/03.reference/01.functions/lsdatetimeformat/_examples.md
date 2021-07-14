```luceescript+trycf
	list = "arabic (united arab emirates),arabic (jordan),croatian (croatia),french (belgium),spanish (panama)";
	loop list="#list#" index="locale" delimiters="," {
		oldlocale = setLocale(locale);
		writeOutput("<h3>#locale#</h3>");
		writeoutput(lsdateTimeFormat(now()));writeOutput("<br>");
		writeoutput(lsdateTimeFormat(now(), 'hh:mm:ss'));writeOutput("<br>");
		writeoutput(lsdateTimeFormat(now(), 'hh:mm:sst'));writeOutput("<br>");
		writeoutput(lsdateTimeFormat(now(), 'hh:mm:sstt'));writeOutput("<br>");
		writeoutput(lsdateTimeFormat(now(), 'HH:mm:ss'));
	}
```
