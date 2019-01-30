```luceescript+trycf
aNames = array("Marcus","Sarah","Josefine");

arrayEach(
    aNames,
    function(element){
        dump(var="#ucase(element)#",label="ucase element");
    }
);

//member function version
aNames.each(
    function(element){
        dump(var="#lcase(element)#",label="lcase element");
    }
);

writeOutput('Thread Example - process 3 at a time<br>');
start = getTickCount();
a = ["a","b","c","d","e","f","g","h","i"];
a.each(function(element,index,array){
    writeOutput("<code>#index#:#element# [#getTickCount()#]</code><br>"); 
    sleep(100);
},true,3);

writeOutput('Total Time: #(getTickCount()-start)# milliseconds<br>');
```
