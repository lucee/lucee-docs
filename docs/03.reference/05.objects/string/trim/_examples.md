
```luceescript+trycf
	// create variable with a string of text that has leading and trailing spaces
	str = " I Love Lucee!  ";
	// output variable
	writeDump("-" & str & "-");
	// output variable without leading spaces
	writeDump("-" & str.Trim() & "-");
```