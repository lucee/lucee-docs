```luceescript+trycf
	writeDump(listLen("susi,sam,LAS,test"));//4
	writeDump(listLen("susi,,LAS,,"));//with empty values
	writeDump(listLen("susi,,LAS,,."));//3
```