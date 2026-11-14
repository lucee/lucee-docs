```luceescript
// Encode a struct
cbor = CborEncode( { name: "Zac", age: 42 } );
// cbor is binary data

// Encode nested data
cbor = CborEncode( {
	users: [
		{ name: "Alice", scores: [ 10, 20, 30 ] },
		{ name: "Bob", scores: [ 40, 50 ] }
	],
	count: 2
} );

// Encode raw binary data (JSON can't do this — it would need base64)
payload = charsetDecode( "binary payload", "UTF-8" );
cbor = CborEncode( payload );

// Roundtrip: encode then decode gets you back the original data
original = { key: "value", numbers: [ 1, 2, 3 ] };
decoded = CborDecode( CborEncode( original ) );
// decoded.key == "value"

// Structs with numeric-looking keys are encoded as CBOR integer keys
// This makes COSE key roundtrips work automatically
coseKey = {};
coseKey[ "1" ] = 2;    // kty = EC
coseKey[ "-1" ] = 1;   // crv = P-256
cbor = CborEncode( coseKey );
// CBOR map has integer keys 1 and -1 (not string keys)
```
