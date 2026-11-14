```luceescript
// Generate a PKCS#12 keystore containing a key pair and self-signed certificate
// Useful for Java/Lucee SSL configuration, code signing, etc.

// Create a keystore with an RSA key pair
GenerateKeystore(
	"/path/to/keystore.p12",
	"keystorePassword",
	"mykey",          // alias to identify this key
	"RSA-2048",
	"CN=localhost, O=My Company, C=AU"
);

// Create a keystore with an EC key pair
GenerateKeystore(
	"/path/to/ec-keystore.p12",
	"keystorePassword",
	"eckey",
	"P-256",
	"CN=ec-example.com, O=My Company, C=AU"
);

// List the aliases in the keystore
aliases = KeystoreList( "/path/to/keystore.p12", "keystorePassword" );
// [ "mykey" ]

// Extract the key pair and certificate from the keystore
result = GetKeyPairFromKeystore(
	"/path/to/keystore.p12",
	"keystorePassword",
	"keystorePassword", // key password (defaults to keystore password if empty)
	"mykey"
);
// result.private     - PEM-encoded private key
// result.public      - PEM-encoded public key
// result.certificate - PEM-encoded certificate
```
