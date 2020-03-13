```luceescript+trycf
	list = "arabic (united arab emirates),hindi(India),arabic (syria),spanish (panama)";
	loop list="#list#" index="locale" delimiters="," {
		oldlocale = setLocale(locale);
		writeOutput("<h3>#locale#</h3>");
		writeoutput(now().lsdateTimeFormat());writeOutput("<br>");
		writeoutput(now().lsdateTimeFormat( 'hh:mm:ss'));writeOutput("<br>");
		writeoutput(now().lsdateTimeFormat( 'hh:mm:sst'));writeOutput("<br>");
		writeoutput(now().lsdateTimeFormat( 'hh:mm:sstt'));writeOutput("<br>");
		writeoutput(now().lsdateTimeFormat( 'HH:mm:ss'));
	}
```
