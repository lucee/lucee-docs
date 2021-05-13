```luceescript+trycf
writeDump(replaceNoCase("xxabcxxabcxx","ABC","def"));
writeDump(replaceNoCase("xxabcxxabcxx","abc","def","All"));
writeDump(replaceNoCase("xxabcxxabcxx","AbC","def","hans"));
writeDump(replaceNoCase("a.b.c.d",".","-","all"));
test = "camelcase CaMeLcAsE CAMELCASE";
test2 = replaceNoCase(test, "camelcase", "CamelCase", "all");
writeDump(test2);

writeDump(var=
    replaceNoCase("One string, two strings, Three strings",
    	{"one": 1, "Two": 2, "three": 3, "string": "txt", "text": "string"}),
	label="replaceNoCase via a struct"
); // struct keys need to be quoted
```
