```luceescript+trycf
	writeOutput(dateCompare(now(), '11/10/1992')&" (Date1 is later than date2)<br>");
	writeOutput(dateCompare('11/10/1992', '11/10/1992')&" (Date1 is equal to date2)<br>");
	writeOutput(dateCompare('11/10/1992', now())&" Date1 is earlier than date2");
```

### Member function

```luceescript+trycf
	d=createDate(year(now()),month(now()),day(now()));
	d1='11/10/1992';
	writeOutput(d.Compare('11/10/1992')&" Date1 is later than date2<br>");0
	writeOutput(d.Compare(d)&" (Date1 is equal to date2)<br>");
	writeOutput(d1.Compare(d)&" Date1 is earlier than date2");
```
