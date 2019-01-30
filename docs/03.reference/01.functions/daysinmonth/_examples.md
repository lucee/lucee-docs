```luceescript+trycf
	writeOutput("Total number of days for the current month is"&daysInMonth(now()));
	d1=CreateDateTime(2016, 11, 10, 6, 10, 1);//user defined date with member function
	writeOutput("<br>Total number of days for the given month is "&d1.daysInMonth());
```
