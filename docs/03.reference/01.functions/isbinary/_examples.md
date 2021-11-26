```luceescript+trycf
writeDump(label:"Boolean value", var:isBinary(true));
writeDump(label:"Numeric value", var:isBinary(1010));
writeDump(label:"String value", var:isBinary("binary"));
writeDump(label:"Array value", var:isBinary(arrayNew(1)));
writeDump(label:"Binary value", var:isBinary(ToBinary(toBase64("I am a string."))));
```
