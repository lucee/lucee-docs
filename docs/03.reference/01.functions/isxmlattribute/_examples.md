```luceescript+trycf
	myPath='<note><from body="sample">Bob</from></note>';
	lastnames = XmlSearch(myPath, '//@body');
	writeDump(lastnames);
	writeOutput(isXMLAttribute(lastnames[1]));
```