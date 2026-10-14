**Struct key handling:** CFML struct keys are always strings, but CBOR distinguishes between string keys and integer keys. `CborEncode` automatically converts numeric-looking string keys (like `"1"`, `"-7"`) to CBOR integer keys. This means COSE key structs roundtrip correctly without any extra work.

The tradeoff: if you genuinely need a CBOR text key `"1"` (the string, not the integer), it will be encoded as integer `1` instead. This is fine for COSE/WebAuthn use cases but worth knowing if you're working with general-purpose CBOR maps that mix text and integer keys.

**Binary data:** CFML binary values are encoded as CBOR byte strings. This is more efficient than JSON's approach of base64-encoding binary data inside a string.
