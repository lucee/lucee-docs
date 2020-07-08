```luceescript+trycf
	writeDump(REFind("a+c+", "abcaaccdd"));
	writeDump(REFind("a+c*", "Abcaaccdd"));
	writeDump(REFind("[[:upper:]]", "abcaacCDD"));
	writeDump(REFind("[\?&]rep = ", "report.cfm?rep = 1234&u = 5"));

	teststring1 = "The cat in the hat hat came back!";
	st1 = REFind("([[:alpha:]]+)[ ]+(\1)",teststring1,1,"TRUE");
	writeDump(st1['len'][3]);

	teststring2 = "AAAXAAAA";
	st2 = REFind("x",teststring2,1,"TRUE");
	writeDump(arrayLen(st2['pos']));
```