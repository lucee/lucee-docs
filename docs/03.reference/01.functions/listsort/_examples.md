### Simple example for listSort() with type numeric,text(case-sensitive) & textnocase(case-insensitive)

```luceescript+trycf

listNumeric="4,-16,2,15,-5,7,11";
writeOutput(listsort(listNumeric,"numeric","asc"));
writeOutput("<br><br>");
writeOutput(listsort("Adobe/coldfusion/Lucee/15/LAS","text","desc","/"));
writeOutput("<br><br>");
writeOutput(listsort("Adobe,coldfusion,lucee,15,LAS","textnocase","asc"));
writeOutput("<br><br>");

//Member function
strList="Lucee,ColdFusion,LAS,SUSI,AdoBe";
writeDump(strlist.listSort("textnocase","asc"));

```