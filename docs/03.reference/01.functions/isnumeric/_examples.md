```luceescript+trycf
writeDump(label:"Single numeric value", var:isNumeric(1));
writeDump(label:"Decimal value", var:isNumeric(1.3));
writeDump(label:"Numeric value with quotes", var:isNumeric("1"));
writeDump(label:"String value", var:isNumeric("susi"));
writeDump(label:"Boolean value", var:isNumeric(true));
writeDump(label:"Date value", var:isNumeric("6/2017"));
writeDump(label:"isNumeric() with another function", var:isNumeric(arrayNew(1)));
str = "Susi";
writeDump(label:"String length", var:isNumeric(str.length()));
writeDump(label:"Numbers with space", var:isNumeric(' 123 '));
```
