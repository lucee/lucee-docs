```luceescript+trycf
	writeOutput("Date for the current date is"&datePart("d",now()));
	d1=CreateDate(2016, 11, 10);//user defined date with member function
	writeOutput("<br>Month of the given date is "&d1.Part('m','Asia/Calcutta'));
```
