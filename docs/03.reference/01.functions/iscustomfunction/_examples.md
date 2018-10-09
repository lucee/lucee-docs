```luceescript+trycf
writeDump(isCustomFunction(realUDF));
writeDump(isCustomFunction(xxx));
testFun = realUDF;
X = 1;
writeDump(isCustomFunction(testFun));
writeDump(isCustomFunction(X))
function realUDF() {
	return 1;
}
function xxx(void) {}
```
