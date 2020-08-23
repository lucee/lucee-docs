```luceescript+trycf
	list = "arabic (syria),croatian (croatia),french (belgium),spanish (panama)";
	loop list="#list#" index="locale" delimiters="," {
	    oldlocale = setLocale(locale);
	    writeOutput("<h3>#locale#</h3>");
	    writeoutput(lsdateformat(now()));writeOutput("<br>");
	    writeoutput(now().lsdateformat('full'));writeOutput("<br>");
	    writeoutput(now().lsdateformat('short'));writeOutput("<br>");
	    writeoutput(now().lsdateformat('hh:mm:sstt'));writeOutput("<br>");
	    writeoutput(now().lsdateformat('long'));
	}
```