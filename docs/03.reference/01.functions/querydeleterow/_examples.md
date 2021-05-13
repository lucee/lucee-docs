```luceescript+trycf
qry1=queryNew("a,b,c", "varchar,varchar,varchar", [["a1","b1","c1"], ["a2","b2","c2"], ["a3","b3","c3"]]);
queryDeleteRow(qry1, 2);
writeDump(valueList(qry1.a));

qry2=queryNew("a,b,c", "varchar,varchar,varchar", [["a1","b1","c1"], ["a2","b2","c2"], ["a3","b3","c3"]]);
for(i=3; i>=1; i--){
	queryDeleteRow(qry2, i);
}
writeDump(qry2.RecordCount);
```
