```luceescript
// Extract a key pair and its certificate from a PKCS#12 keystore
// Arguments: keystorePath, keystorePassword, keyPassword, alias
result = GetKeyPairFromKeystore(
	"/path/to/keystore.p12",
	"keystorePassword",
	"keyPassword",
	"mykey"
);

// result is a struct with three PEM-encoded strings:
result.private;     // "-----BEGIN PRIVATE KEY-----\n..."
result.public;      // "-----BEGIN PUBLIC KEY-----\n..."
result.certificate; // "-----BEGIN CERTIFICATE-----\n..."

// If the key password is the same as the keystore password,
// you can pass an empty string and it will default
result = GetKeyPairFromKeystore(
	"/path/to/keystore.p12",
	"keystorePassword",
	"",       // defaults to keystorePassword
	"mykey"
);

// Use the extracted keys for signing, JWT creation, etc.
token = JwtSign(
	claims = { sub: "user123" },
	key = result.private,
	algorithm = "RS256"
);
```
