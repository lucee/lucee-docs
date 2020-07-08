```luceescript+trycf
//Simple function
writeOutput(ListChangeDelims('Plant,green,save,earth',"@"));

//Member function with custom delimiter
strLst="1+2+3+4";
writeDump(strLst.listChangeDelims("/", "+"));
```