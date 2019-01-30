```luceescript+trycf
myQry=QueryNew("id,name","Integer,VarChar",[[99,'sm'],[55,'mk']]);
cfloop( query="myQry"){
	writeDump(querygetrow(myQry,2));
}
```