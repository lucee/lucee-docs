```luceescript+trycf
qry=queryNew("aaa,bbb");

QueryAddRow(qry);
	QuerySetCell(qry,"aaa","1.1");
	QuerySetCell(qry,"bbb","1.2");
QueryAddRow(qry);
	QuerySetCell(qry,"aaa","2.1");
	QuerySetCell(qry,"bbb","2.2");

QueryAddColumn(qry,"ccc",listToArray("3.1,3.2"));
QueryAddColumn(qry,"ddd","integer",listToArray("4.1,4.2"));

writeDump(qry.columnList);
```
