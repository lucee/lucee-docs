CBOR maps can have integer keys (e.g. COSE keys use `1`, `3`, `-1`), but CFML struct keys are always strings. Integer keys are converted to their string representation — so CBOR key `1` becomes struct key `"1"`. See [[function-cborencode]] for how this is handled on re-encoding.

**Tagged values:** Some CBOR protocols use tags to mark the meaning of a value (e.g. tag 1 = epoch timestamp). By default, tagged values are returned as `{ tag: N, value: ... }`. Pass `{ preserveTags: false }` to unwrap them and get just the inner value.

**Binary data:** Unlike JSON, CBOR natively supports binary (byte strings). These are returned as CFML binary values, not base64-encoded strings.
