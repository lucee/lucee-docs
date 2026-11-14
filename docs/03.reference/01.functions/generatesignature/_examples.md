```luceescript
// Digital signatures prove that data came from the key holder and hasn't been tampered with
// Sign with the private key, verify with the public key

// RSA signature
keyPair = GenerateKeyPair( "RSA-2048" );
signature = GenerateSignature( "Data to sign", keyPair.private );
isValid = VerifySignature( "Data to sign", signature, keyPair.public ); // true

// EC signature (smaller and faster than RSA)
keyPair = GenerateKeyPair( "P-256" );
signature = GenerateSignature( "Data to sign", keyPair.private );
isValid = VerifySignature( "Data to sign", signature, keyPair.public ); // true

// Ed25519 signature (modern, fast, compact)
keyPair = GenerateKeyPair( "Ed25519" );
signature = GenerateSignature( "Data to sign", keyPair.private );
isValid = VerifySignature( "Data to sign", signature, keyPair.public ); // true

// Post-quantum signatures with Dilithium (quantum-computer resistant)
// Available variants: Dilithium2, Dilithium3, Dilithium5
keyPair = GenerateKeyPair( "Dilithium3" );
signature = GenerateSignature( "Quantum-safe data", keyPair.private );
isValid = VerifySignature( "Quantum-safe data", signature, keyPair.public ); // true
```
