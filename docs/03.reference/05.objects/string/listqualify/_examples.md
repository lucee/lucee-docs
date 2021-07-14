```luceescript+trycf
	strList="Lucee,ColdFusion,LAS,SUSI";
	writeDump(strlist.listQualify('|'));

	strList="Lucee\ColdFusion\LAS\SUSI";
	writeDump(strlist.listQualify('|',"\"));
```