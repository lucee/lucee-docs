```luceescript+trycf 
    list = "Plant,green,save,earth";
    listEach(list, function(element,index,list) {
        writeOutput("#index#:#element#;<br>");
    });
    
    //Member function with custom delimiter
    writeOutput("<br>Member Function<br>");
    strLst="one+two+three";
    strLst.listEach(function(element,index,list) {
        writeOutput("#index#:#element#;<br>");
    },"+");
```
