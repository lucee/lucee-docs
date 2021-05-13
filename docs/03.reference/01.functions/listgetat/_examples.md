```luceescript+trycf
writeOutput(listGetAt("a,,b,c,",3,",",true));//Returns b

//Member Function with '/' delimiter
strList="/a//b/c//d";
writeDump(strList.listGetAt(5,"/",true));//Expected output c
```
