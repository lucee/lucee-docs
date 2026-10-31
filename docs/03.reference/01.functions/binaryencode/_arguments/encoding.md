A string that specifies the encoding method to use to represent the data; one of the following:

- Hex: use the characters 0-9 and A-F to represent the hexadecimal value of each byte.
- UU: use the UNIX UUencode algorithm to convert the data
- Base64: use the Base64 algorithm to convert the data, as specified by IETF RFC 2045, at www.ietf.org/rfc/rfc2045.txt.
- Base64URL: use the URL and filename safe Base64 alphabet (- and _ instead of + and /) without padding, as specified by IETF RFC 4648 section 5, at www.ietf.org/rfc/rfc4648.txt. This is the encoding used by JWT, OAuth and PKCE.