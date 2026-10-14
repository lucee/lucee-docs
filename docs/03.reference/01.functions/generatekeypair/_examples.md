```luceescript
// Generate an RSA key pair - default is 2048-bit, PKCS#8 PEM format
keyPair = GenerateKeyPair( "RSA" );
// keyPair.private starts with "-----BEGIN PRIVATE KEY-----"
// keyPair.public starts with "-----BEGIN PUBLIC KEY-----"

// Specify key size explicitly
keyPair = GenerateKeyPair( "RSA-4096" );

// Elliptic curve key pairs - smaller and faster than RSA
keyPair = GenerateKeyPair( "P-256" );  // NIST P-256 (secp256r1)
keyPair = GenerateKeyPair( "P-384" );  // NIST P-384
keyPair = GenerateKeyPair( "P-521" );  // NIST P-521

// Ed25519 - modern, fast, compact signatures
keyPair = GenerateKeyPair( "Ed25519" );

// Output format options
keyPair = GenerateKeyPair( "RSA", { format: "PEM" } );         // PKCS#8 (default)
keyPair = GenerateKeyPair( "RSA", { format: "traditional" } );  // OpenSSL traditional format
// private starts with "-----BEGIN RSA PRIVATE KEY-----"

keyPair = GenerateKeyPair( "P-256", { format: "traditional" } ); // EC traditional
// private starts with "-----BEGIN EC PRIVATE KEY-----"

keyPair = GenerateKeyPair( "RSA", { format: "Base64" } );  // raw Base64 (no PEM headers)
keyPair = GenerateKeyPair( "RSA", { format: "DER" } );     // binary DER format

// Format aliases: PKCS8 = PEM, OPENSSL = traditional
// Note: Ed25519 only supports PKCS8/PEM format (no traditional)
```
