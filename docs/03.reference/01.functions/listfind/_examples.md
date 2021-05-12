```luceescript+trycf
writeOutput(listFind("I,love,lucee,testFile", "lucee"));//Expected output 3

//Member Function with @ delimiter
strList="I@am@lucee@dev";
writeDump(strList.listFind("dev","@"));//Expected output 4
```