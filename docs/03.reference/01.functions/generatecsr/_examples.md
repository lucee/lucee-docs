```luceescript
// Generate a Certificate Signing Request (CSR) to submit to a Certificate Authority
// This is the standard workflow: generate key pair -> create CSR -> submit to CA
keyPair = GenerateKeyPair( "RSA-2048" );
csr = GenerateCSR( keyPair, "CN=example.com, O=My Company, C=AU" );
// csr is a PEM string: "-----BEGIN CERTIFICATE REQUEST-----\n..."

// Include Subject Alternative Names (SANs) for multiple domains
csr = GenerateCSR( keyPair, "CN=example.com", {
	sans: [ "example.com", "www.example.com", "api.example.com" ]
});

// Works with EC keys
ecKeyPair = GenerateKeyPair( "P-256" );
csr = GenerateCSR( ecKeyPair, "CN=ec-test.example.com" );

// Works with Ed25519 keys
edKeyPair = GenerateKeyPair( "Ed25519" );
csr = GenerateCSR( edKeyPair, "CN=ed25519.example.com" );
```
