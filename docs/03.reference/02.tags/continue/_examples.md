```luceescript+trycf
count = 0;
count2 = 0;

for (x = 1; x <= 10; x++) {
	
	count2++;

	if (x is 5) {
		continue;
	}

	count++;

}

dump(var=count, label="Count variable is");
dump(var=count2, label="Count2 variable is");
```
