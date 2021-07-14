```luceescript+trycf
writeOutput(listContains("I,love,lucee,testFile", "lucee"));//Expected output 3

//Member Function with @ delimiter
strList="I@am@lucee@dev";
writeDump(strList.listContains("dev","@"));//Expected output 4
```