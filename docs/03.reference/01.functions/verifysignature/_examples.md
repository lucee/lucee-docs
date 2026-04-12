```luceescript
// Verify that data hasn't been tampered with using the signer's public key
keyPair = GenerateKeyPair( "RSA-2048" );
data = "Important data";

signature = GenerateSignature( data, keyPair.private );

// Verify with the matching public key
isValid = VerifySignature( data, signature, keyPair.public ); // true

// Tampered data fails verification
isValid = VerifySignature( "Modified data", signature, keyPair.public ); // false

// Wrong public key fails verification
otherKeyPair = GenerateKeyPair( "RSA-2048" );
isValid = VerifySignature( data, signature, otherKeyPair.public ); // false
```
