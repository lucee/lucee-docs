##### Basic Example

```luceescript+trycf
aNames = array("Marcus", "Sarah", "Josefine");

aNames.each(
    function(element) {
        dump(element);
    }
);
```

##### Parallel Example with 3 Threads

```luceescript+trycf
start = getTickCount();
a = ["a","b","c","d","e","f","g","h","i"];
a.each(function(element, index, array) {
    writeOutput("<code>#index#:#element# [#getTickCount()#]</code><br>");
    sleep(100);
}, true, 3);

writeOutput('Total Time: #(getTickCount()-start)# milliseconds<br>');
```
