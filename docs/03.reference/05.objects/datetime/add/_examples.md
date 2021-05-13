```luceescript+trycf
	datetime = now();
	// the below code increments 5 days in actual date
	dump(datetime.add("d", 5));
	// the below code increments 10 milliseconds in actual date
	dump(datetime.add("l", 10));
	// the below code increments 60 seconds in actual date
	dump(datetime.add("s", 60));
	// the below code increments 60 minutes in actual date
	dump(datetime.add("n", 60));
	// the below code increments 2 hours in actual date
	dump(datetime.add("h", 2));
	// the below code increments 1 day in actual date
	dump(datetime.add("d", 1));
	// the below code increments 1 month in actual date
	dump(datetime.add("m", 1));
	// the below code increments 1 year in actual date
	dump(datetime.add("yyyy", 1));
```
