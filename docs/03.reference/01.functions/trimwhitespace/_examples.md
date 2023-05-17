```luceescript+trycf
	res = "   I love Lucee     ";

	writeDump(var=res, label="Original string");

	writeOutput("Before Trim the Whitespace <br />");
	writeDump(var=res.len(), label="string length");

	writeOutput("After Trim the Whitespace <br />");
	writeDump(var=TrimWhitespace(res).len(), label="string length");
```