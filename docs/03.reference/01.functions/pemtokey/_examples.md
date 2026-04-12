```luceescript
// Convert a PEM-encoded key string into a Java key object
// Useful when you've stored keys as PEM strings and need to use them for signing, encryption, etc.
keyPair = GenerateKeyPair( "RSA-2048" );

// Parse private key PEM into a PrivateKey object
privateKey = PemToKey( keyPair.private );

// Parse public key PEM into a PublicKey object
publicKey = PemToKey( keyPair.public );

// Works with any key type: RSA, EC, Ed25519
ecKeyPair = GenerateKeyPair( "P-256" );
ecPrivate = PemToKey( ecKeyPair.private );
ecPublic = PemToKey( ecKeyPair.public );

// Roundtrip: PEM -> Key object -> PEM
key = PemToKey( keyPair.private );
pem = KeyToPem( key );
```
