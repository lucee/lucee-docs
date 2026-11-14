A string specifying the algorithm used to encode the original
binary data into a string; must be one of the following:

- hex: characters 0-9 and A-F represent the hexadecimal value of each byte
- UU: data is encoded using the UNIX UUencode algorithm
- base64: data is encoded using the Base64 algorithm
- base64url: data is encoded using the URL and filename safe Base64 alphabet (- and _ instead of + and /), as specified by IETF RFC 4648 section 5, as used for example by JWT, OAuth and PKCE. The padding (=) is optional when decoding.