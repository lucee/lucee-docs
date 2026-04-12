```luceescript
// Convert a Java key object back to a PEM string
// Useful for storing or transmitting keys
keyPair = GenerateKeyPair( "RSA-2048" );

// Convert key objects to PEM strings
privateKey = PemToKey( keyPair.private );
pem = KeyToPem( privateKey );
// "-----BEGIN PRIVATE KEY-----\nMIIE..."

publicKey = PemToKey( keyPair.public );
pem = KeyToPem( publicKey );
// "-----BEGIN PUBLIC KEY-----\nMIIB..."
```
