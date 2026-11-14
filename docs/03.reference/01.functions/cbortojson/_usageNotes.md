This converts directly from CBOR to JSON using the underlying library — it does not go through CFML types, avoiding the intermediate conversion step of `serializeJSON( CborDecode( cbor ) )`.

**Binary data:** CBOR byte strings are base64-encoded in the JSON output, since JSON has no native binary type.

**Integer keys:** CBOR integer keys (like those in COSE maps) are converted to JSON string keys, since JSON only supports string keys.
