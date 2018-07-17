```luceescript+trycf
writeOutput(listGetAt(",a,,b,c,",1,",",true));//Returns Empty value

//Member Function with @ delimeter
strList=",,a,,b,c,d";
writeDump(strList.listGetAt(5,",",true));//Expected output b
``` 