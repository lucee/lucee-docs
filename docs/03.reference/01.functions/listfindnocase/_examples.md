```luceescript+trycf
writeOutput(listFindNoCase("I,love,lucee,testFile", "LUCEE"));//Expected output 3

//Member Function with @ delimiter
strList="I@am@lucee@dev";
writeDump(strList.listFindNoCase("Dev","@"));//Expected output 4
```