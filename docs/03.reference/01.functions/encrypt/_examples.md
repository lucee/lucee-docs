```luceescript+trycf
key=generateSecretKey("AES");
testEncrypt = encrypt("safeourtree",key,"AES","base64");
writeDump(testEncrypt);
```

### Simple Example(6.2.2.58-SNAPSHOT)

```luceescript+trycf
// Supported from Lucee 6.2.2.58-SNAPSHOT
encryptData = encrypt("lucee","abc","AES","Hex",3);
writeDump(encryptData);
```
