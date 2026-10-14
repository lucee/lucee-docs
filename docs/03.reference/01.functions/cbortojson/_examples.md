```luceescript
// Convert CBOR binary data directly to a JSON string
// A more direct alternative to serializeJSON( CborDecode( cbor ) )

cbor = CborEncode( { name: "test", value: 42 } );
json = CborToJson( cbor );
// json is a valid JSON string: {"name":"test","value":42}

// Convert a CBOR array to JSON
cbor = CborEncode( [ 1, "two", 3 ] );
json = CborToJson( cbor );
// [1,"two",3]

// Practical use: log WebAuthn attestation data as JSON for debugging
attestationCbor = Base64UrlDecode( response.attestationObject );
echo( CborToJson( attestationCbor ) );
```
