The binary encoding used to represent the data as a string. Must be the same as the algorithm used to encrypt the string.

- Base64: the Base64 algorithm, as specified by IETF RFC 2045.
- Base64URL: the URL and filename safe Base64 algorithm without padding, as specified by IETF RFC 4648 section 5.
- Hex: the characters A-F and 0-9 represent the hexadecimal byte values.
- UU(default): the UNIX standard UUEncode algorithm .