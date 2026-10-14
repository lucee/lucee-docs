```luceescript
// Generate a self-signed certificate for development/testing
keyPair = GenerateKeyPair( "RSA-2048" );

// Pass the key pair as a struct
cert = GenerateSelfSignedCertificate(
	keyPair = keyPair,
	subject = "CN=localhost, O=My Company, C=AU"
);
// cert is a PEM string starting with "-----BEGIN CERTIFICATE-----"

// Or pass private and public keys individually
cert = GenerateSelfSignedCertificate(
	privateKey = keyPair.private,
	publicKey = keyPair.public,
	subject = "CN=localhost, O=My Company, C=AU"
);

// Custom validity period (default is 365 days)
cert = GenerateSelfSignedCertificate(
	keyPair = keyPair,
	subject = "CN=localhost",
	validityDays = 730 // 2 years
);

// Works with EC keys too
ecKeyPair = GenerateKeyPair( "P-256" );
cert = GenerateSelfSignedCertificate(
	keyPair = ecKeyPair,
	subject = "CN=ec-test.example.com"
);

// Each certificate gets a unique serial number, even when generated rapidly
```
