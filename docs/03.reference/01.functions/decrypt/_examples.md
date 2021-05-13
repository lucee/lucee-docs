```luceescript+trycf
key=generateSecretKey("BLOWFISH");
testEncrypt = encrypt("safe_our_tree",key,"BLOWFISH","base64");
testDecrypt = decrypt(testEncrypt,key,"BLOWFISH","base64");
writeDump(testDecrypt);
```
