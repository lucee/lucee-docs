```luceescript+trycf
List = "lucee,ACF,luceeExt,lucee, ext,LUCEEEXT";
writeDump(ListValueCount(list, "lucee")); // It return's 2
writeDump(ListValueCount(list, "luceeExt")); // It return's 1 because it case senstive
List2 = "lucee@ACF@luceeExt@lucee@ext@LUCEEEXT";
writeDump(ListValueCount(list2, "lucee", "@"));
```
