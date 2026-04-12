```luceescript
// Check whether a private key and public key belong to the same key pair
// Accepts PEM strings or Java key objects
keyPair = GenerateKeyPair( "RSA-2048" );
isValid = ValidateKeyPair( keyPair.private, keyPair.public ); // true

// Mismatched keys return false
keyPair1 = GenerateKeyPair( "RSA-2048" );
keyPair2 = GenerateKeyPair( "RSA-2048" );
isValid = ValidateKeyPair( keyPair1.private, keyPair2.public ); // false

// Works with EC keys too
ecPair = GenerateKeyPair( "P-256" );
isValid = ValidateKeyPair( ecPair.private, ecPair.public ); // true
```
