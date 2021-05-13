```luceescript+trycf
qry=queryNew("aaa,bbb,ccc,ddd,eee");

QueryAddRow(qry);
QuerySetCell(qry,"aaa","sss");
QueryAddRow(qry,3);
QuerySetCell(qry,"aaa",(1));
QueryAddRow(qry,1);

writeDump(queryColumnCount(qry));
```
