```luceescript+trycf
	writeOutput("The number of days of the current year is "&dayOfYear(now()));
	d1=CreateDateTime(2016, 11, 10, 6, 10, 1);//user defined date with member function
	writeOutput("<br>The number of days of the year is "&d1.dayOfYear());
```