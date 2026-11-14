**COSE key format:** COSE keys use integer keys to identify fields (defined in RFC 9052):

- `1` = key type (2 for EC, 1 for OKP/EdDSA)
- `3` = algorithm (-7 for ES256, -35 for ES384, -36 for ES512, -8 for EdDSA)
- `-1` = curve (1 for P-256, 2 for P-384, 3 for P-521, 6 for Ed25519)
- `-2` = x coordinate (binary)
- `-3` = y coordinate (binary, EC only)
- `-4` = private key (binary, only if private material is present)

You don't need to construct these structs yourself — they come from [[function-cbordecode]] when decoding WebAuthn authenticator data, or from [[function-keytocose]] when converting existing keys.

**Return value:** Always returns a struct with a `public` key. If the COSE key contains private material (key `-4`), the struct also includes a `private` key.

**WebAuthn:** The vast majority of passkeys use EC P-256 (ES256), but Ed25519 support is growing. P-384 and P-521 are rare in practice but supported.
