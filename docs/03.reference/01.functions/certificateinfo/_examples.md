```luceescript
// Extract detailed information from a certificate (PEM string or certificate object)
keyPair = GenerateKeyPair( "RSA-2048" );
cert = GenerateSelfSignedCertificate(
	keyPair = keyPair,
	subject = "CN=localhost, O=My Org, C=AU"
);

info = CertificateInfo( cert );
// info is a struct containing:
//   subject           - e.g. "CN=localhost, O=My Org, C=AU"
//   issuer            - same as subject for self-signed certs
//   validFrom         - date the certificate becomes valid
//   validTo           - date the certificate expires
//   algorithm         - e.g. "SHA256withRSA"
//   publicKeyAlgorithm - e.g. "RSA" or "EC"
//   serialNumber      - unique serial number
//   selfSigned        - boolean, true for self-signed certs
//   fingerprint       - struct with sha1 and sha256 fingerprints

// Check if a certificate is still valid
if ( now() > info.validTo ) {
	// certificate has expired
}

// Get the SHA-256 fingerprint for pinning
info.fingerprint.sha256; // e.g. "AB:CD:EF:12:34:..."
```
