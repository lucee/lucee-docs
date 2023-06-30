```luceescript+trycf
	// binary data
	data = toBinary("abcd");

	// generate the key
	key = generateSecretKey("AES");

	// encrypt string
	encryptValue = encryptBinary(data, key);
	writeDump(encryptValue);

	// decrypt string
	decryptValue = decryptBinary(encryptValue, key);
	writeDump(decryptValue);

```