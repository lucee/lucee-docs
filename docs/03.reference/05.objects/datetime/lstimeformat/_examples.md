```luceescript+trycf
	list = "arabic (syria),croatian (croatia),french (belgium),spanish (panama)";
	loop list="#list#" index="locale" delimiters="," {
		oldlocale = setLocale(locale);
		writeOutput("<h3>#locale#</h3>");
		writeoutput(now().lsTimeFormat());writeOutput("<br>");
		writeoutput(now().lsTimeFormat( 'hh:mm:ss'));writeOutput("<br>");
		writeoutput(now().lsTimeFormat( 'hh:mm:sst'));writeOutput("<br>");
		writeoutput(now().lsTimeFormat( 'hh:mm:sstt'));writeOutput("<br>");
		writeoutput(now().lsTimeFormat( 'HH:mm:ss'));
	}
```
