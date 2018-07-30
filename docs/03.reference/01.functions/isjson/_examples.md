```luceescript+trycf
writeDump(label:"Array", var:isJson("[1,2,3]"));
writeDump(label:"Single number value", var:isJson(1));
writeDump(label:"String value", var:isJson('susi12345'));
writeDump(label:"String value with serializeJSON", var:isJson(serializeJSON('susi')));
writeDump(label:"Boolean value with serializeJSON", var:isJson(serializeJSON(true)));
writeDump(label:"CreateDateTime with serializeJSON", var:isJson(serializeJSON(CreateDateTime(2018,1,1,1,1,1))));
qry=queryNew('aaa,bbb', "varchar, varchar", [["a","b"],["c","d"]]);
writeDump(label:"Query", var: isJson(qry));
```