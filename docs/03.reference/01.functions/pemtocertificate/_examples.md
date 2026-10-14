```luceescript
// Convert a PEM-encoded certificate string into a Java X509Certificate object
// Useful when you need to pass the certificate to Java APIs
keyPair = GenerateKeyPair( "RSA-2048" );
certPem = GenerateSelfSignedCertificate(
	keyPair = keyPair,
	subject = "CN=localhost"
);

certObj = PemToCertificate( certPem );
// certObj is a java.security.cert.X509Certificate

// Convert back to PEM with CertificateToPem()
pem = CertificateToPem( certObj );
// pem starts with "-----BEGIN CERTIFICATE-----"
```
