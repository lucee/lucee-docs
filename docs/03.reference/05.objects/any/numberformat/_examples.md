```luceescript+trycf
	res = 123;
	writedump(res.numberFormat('__.00')); 
	writedump(res.numberFormat('99999'));
	writedump(res.numberFormat('99.99999'));
	writedump(res.numberFormat('_____'));
	writedump(res.numberFormat('+'));
	writedump(res.numberFormat('-'));
	writedump("1".numberFormat('C000'));
```
