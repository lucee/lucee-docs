```luceescript+trycf
writeDump(label:"Single numeric value", var:isNumericDate(1));
writeDump(label:"Integer value", var:isNumericDate(1000000000));
writeDump(label:"Now()", var:isNumericDate(now()));
writeDump(label:"Date value", var:isNumericDate("01/01/04"));
writeDump(label:"Minus value", var:isNumericDate("-1111111111"));
writeDump(label:"String value", var:isNumericDate("efsdf"));
```
