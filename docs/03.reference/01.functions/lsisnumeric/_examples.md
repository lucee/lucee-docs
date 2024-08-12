```luceescript+trycf
	writeoutput(lsIsNumeric('123') & "<br>");
	writeoutput(lsIsNumeric('five') & "<br>");
	writeoutput(lsIsNumeric('3.21') & "<br>");
	writeoutput(lsIsNumeric('0012') & "<br>");
	writeoutput(lsIsNumeric('00.01'));
	writeoutput(lsIsNumeric('1.321,00') & "<br>"); // false
	writeoutput(lsIsNumeric('1.321,00', "german") & "<br>"); // true
```
