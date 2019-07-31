
```luceescript+trycf
myquery = queryNew("id,name","int,varchar",[["1","jhon"],["2","mike"]]);
writeDump(myquery);

currentrow = myquery.currentrow();
cfloop(query=myquery) {
writeDump(currentrow);
}
```