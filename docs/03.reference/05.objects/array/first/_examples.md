```luceescript+trycf
	myarray = ["one","two","three","TWO","five","Two"];
	res = myarray.first();
	writedump(res);
	myarray = [{"one":1},"two","three","TWO","five","Two"];
	res = myarray.first();
	writedump(res);
```