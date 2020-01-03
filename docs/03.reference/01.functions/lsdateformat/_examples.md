```lucee+trycf
	list = "arabic (syria),croatian (croatia),french (belgium),spanish (panama)";
	loop list="#list#" index="locale" delimiters="," {
		oldlocale = setLocale(locale);
		writeOutput("<h3>#locale#</h3>");
		writeoutput(.lsdateformat(now()));writeOutput("<br>");
		writeoutput(now().lsdateformat(now(), 'full'));writeOutput("<br>");
		writeoutput(now().lsdateformat(now(), 'short'));writeOutput("<br>");
		writeoutput(now().lsdateformat(now(), 'hh:mm:sstt'));writeOutput("<br>");
		writeoutput(now().lsdateformat(now(), 'long'));
	}
```