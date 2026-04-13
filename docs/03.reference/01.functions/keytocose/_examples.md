```luceescript
// Convert an EC key pair to COSE (includes private key material)
keyPair = GenerateKeyPair( "P-256" );
cose = KeyToCose( keyPair );
// cose["1"] == 2 (kty: EC), cose["3"] == -7 (alg: ES256)
// cose["-1"] == 1 (crv: P-256), cose["-2"] and cose["-3"] are binary coords
// cose["-4"] is the private key (binary)

// Convert just the public key (no private material)
cose = KeyToCose( keyPair.public );
// Same as above but without cose["-4"]

// Ed25519 keys
edKp = GenerateKeyPair( "Ed25519" );
cose = KeyToCose( edKp );
// cose["1"] == 1 (kty: OKP), cose["3"] == -8 (alg: EdDSA)
// cose["-1"] == 6 (crv: Ed25519), cose["-2"] is the x coordinate

// Encode the COSE struct to CBOR binary (for sending over the wire)
cborBytes = CborEncode( cose );

// Useful for testing: generate a fake authenticator response
cose = KeyToCose( keyPair );
coseBytes = CborEncode( cose );
// Use coseBytes as the credential public key in test authenticator data

// Roundtrip: KeyToCose then CoseToKey gets you back a working key
keys = CoseToKey( cose );
sig = GenerateSignature( "test", keyPair.private );
isValid = VerifySignature( "test", sig, keys.public ); // true
```
