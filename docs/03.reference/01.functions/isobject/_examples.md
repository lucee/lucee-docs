```luceescript+trycf
writeDump(label:"String value", var:isObject("Susi"));
writeDump(label:"isObject() with array function", var:isObject(arrayNew(1)));
writeDump(label:"CreateObject in Java", var:isObject(createObject('java','java.util.HashMap')));
writeDump(label:"CreateObject in Java with init()", var:isObject(createObject('java',"java.lang.StringBuffer").init()));
```
