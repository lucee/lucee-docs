```luceescript
// Decode CBOR bytes back into a CFML struct
cbor = CborEncode( { name: "Zac", age: 42 } );
data = CborDecode( cbor );
// data.name == "Zac", data.age == 42

// Works with all CFML types: arrays, strings, numbers, booleans, binary
cbor = CborEncode( [ 1, "two", true, 3.14 ] );
arr = CborDecode( cbor );
// arr[1] == 1, arr[2] == "two", arr[3] == true

// Binary data survives the roundtrip (unlike JSON which can't hold binary)
payload = charsetDecode( "binary payload", "UTF-8" );
decoded = CborDecode( CborEncode( payload ) );
// isBinary( decoded ) == true

// Tagged CBOR values (used by some protocols to mark types like timestamps)
// are returned as structs with "tag" and "value" keys by default
// Set preserveTags=false to just get the inner value without the tag wrapper
data = { key: "value" };
decoded = CborDecode( CborEncode( data ), { preserveTags: false } );
// decoded.key == "value"

// WebAuthn: decode the attestation object from a passkey registration
attestationObject = CborDecode( Base64UrlDecode( response.attestationObject ) );
// attestationObject.fmt, attestationObject.authData, attestationObject.attStmt
```
