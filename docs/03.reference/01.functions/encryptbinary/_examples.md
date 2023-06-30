```luceescript+trycf
	// binary data
	data = toBinary("abcd");

	// generate the key
	key = generateSecretKey("AES");

	// encrypt string
	binaryValue = encryptBinary(data, key);
	writeDump(binaryValue);
```