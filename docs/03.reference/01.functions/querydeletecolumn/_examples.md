```luceescript+trycf
qry1=queryNew("a,b,c", "varchar,varchar,varchar", [["a1","b1","c1"], ["a2","b2","c2"], ["a3","b3","c3"]]);
queryDeleteColumn(qry1,"c");
writeOutput(qry1.columnlist);

qry2 = queryNew("x,y,z", "varchar,varchar,varchar", [["x1","y1","z1"], ["x2","y2","z2"], ["x3","y3","z3"]]);
cfloop( query="qry2"){
	queryDeleteColumn(qry2,listFirst(qry2.columnlist));
}
writeDump(qry2.columnlist);
```