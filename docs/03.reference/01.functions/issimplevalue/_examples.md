```luceescript+trycf
qry = QueryNew("name", "varchar", []);
writedump(label:"Query is empty", var:qry.isEmpty());

arr=[];
public boolean function isEmpty1() {
	return arr.isEmpty();
}
writeDump(label:"Array is empty", var:isEmpty1());
```
