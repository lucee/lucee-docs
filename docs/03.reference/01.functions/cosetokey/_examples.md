```luceescript
// Roundtrip: generate a key pair, convert to COSE and back
keyPair = GenerateKeyPair( "P-256" );
cose = KeyToCose( keyPair );
keys = CoseToKey( cose );

// The roundtripped key works for signature verification
sig = GenerateSignature( "test data", keyPair.private );
isValid = VerifySignature( "test data", sig, keys.public ); // true

// CoseToKey also accepts raw CBOR bytes — it decodes them internally
cborBytes = CborEncode( cose );
keys = CoseToKey( cborBytes );
// Same result as CoseToKey( CborDecode( cborBytes ) )

// Ed25519 keys work too
edKp = GenerateKeyPair( "Ed25519" );
edCose = KeyToCose( edKp );
edKeys = CoseToKey( edCose );
sig = GenerateSignature( "test data", edKp.private );
isValid = VerifySignature( "test data", sig, edKeys.public ); // true

// WebAuthn registration: extract the public key from authenticator data
attestationObject = CborDecode( Base64UrlDecode( response.attestationObject ) );
authData = attestationObject.authData;
// Parse authData to extract the COSE key bytes (after rpIdHash, flags, counter, credId)
coseKeyStruct = CborDecode( coseKeyBytes );
keys = CoseToKey( coseKeyStruct );
publicKey = keys.public;
// Store KeyToPem( publicKey ) alongside the credential ID

// WebAuthn authentication: verify a passkey signature
isValid = VerifySignature(
	data = signedData,
	signature = Base64UrlDecode( response.signature ),
	publicKey = storedPublicKeyPem,
	algorithm = "SHA256withECDSA"
);
```
