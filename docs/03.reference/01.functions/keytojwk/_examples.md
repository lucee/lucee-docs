```luceescript
// Convert a key or key pair to JSON Web Key (JWK) format (RFC 7517)
// JWK is the standard way to represent cryptographic keys in JSON

// Convert a full key pair - includes private key material
kp = GenerateKeyPair( "RSA" );
jwk = KeyToJwk( kp );
// jwk.kty == "RSA", includes n, e (public) and d (private)

// Convert just the public key - safe to publish
jwk = KeyToJwk( kp.public );
// jwk.kty == "RSA", includes n, e but NOT d

// EC keys
ecKp = GenerateKeyPair( "P-256" );
jwk = KeyToJwk( ecKp );
// jwk.kty == "EC", jwk.crv == "P-256", includes x, y, d

jwk = KeyToJwk( ecKp.public );
// jwk.kty == "EC", includes x, y but NOT d

// Ed25519 keys use the OKP (Octet Key Pair) type
edKp = GenerateKeyPair( "Ed25519" );
jwk = KeyToJwk( edKp );
// jwk.kty == "OKP", jwk.crv == "Ed25519"

// Common workflow: publish your public key as a JWKS for JWT verification
jwk = KeyToJwk( kp.public );
jwksJson = '{"keys":[' & serializeJSON( jwk ) & ']}';
// Serve this JSON at /.well-known/jwks.json
```
