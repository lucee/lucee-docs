```luceescript+trycf
// Measuring size of application variables and dumping the content to screen
qSize = queryNew("key,size");
for (key in application) {
	qSize.addRow();
	qSize.setCell("key", key, qSize.recordCount);
	qSize.setCell("size", sizeOf(application[key]), qSize.recordCount);
}
qSize.sort("size", "desc");
dump(var=qSize, label="Size of all keys in application scope");
```
