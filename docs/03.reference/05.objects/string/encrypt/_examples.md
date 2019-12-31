```luceescript+trycf
	key = generateSecretKey("AES");
	testEncrypt = encrypt("Luceeproject",key,"AES","base64");
	writeDump(testEncrypt);

	key = generateSecretKey("AES");
	testEncrypt = encrypt("Luceeproject",key,"AES","hex");
	writeDump(testEncrypt);
```