```luceescript
// List all key aliases in a PKCS#12 keystore
// Auto-detects the keystore type from the .p12 file extension
aliases = KeystoreList( "/path/to/keystore.p12", "keystorePassword" );
// e.g. [ "mykey", "secondkey" ]

// Use this to check what's in a keystore before extracting keys
for ( alias in aliases ) {
	result = GetKeyPairFromKeystore(
		"/path/to/keystore.p12",
		"keystorePassword",
		"keystorePassword",
		alias
	);
	// process each key pair...
}
```
