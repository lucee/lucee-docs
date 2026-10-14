```luceescript
// Convert a Java X509Certificate object back to a PEM string
// Useful for storing or transmitting certificates
keyPair = GenerateKeyPair( "RSA-2048" );
certPem = GenerateSelfSignedCertificate(
	keyPair = keyPair,
	subject = "CN=localhost"
);

// Roundtrip: PEM -> Certificate object -> PEM
certObj = PemToCertificate( certPem );
newPem = CertificateToPem( certObj );
// newPem starts with "-----BEGIN CERTIFICATE-----"

// The certificate info is preserved through the roundtrip
info = CertificateInfo( newPem );
```
