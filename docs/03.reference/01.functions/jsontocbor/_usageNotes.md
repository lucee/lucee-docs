This converts directly from JSON to CBOR using the underlying library — it does not go through CFML types, avoiding the intermediate conversion step of `CborEncode( deserializeJSON( json ) )`.

**Key types:** JSON keys are always strings, so `JsonToCbor` produces CBOR text-string keys. If you need CBOR integer keys (e.g. for COSE), use [[function-cborencode]] with a CFML struct instead — it converts numeric-looking string keys to CBOR integers automatically.
