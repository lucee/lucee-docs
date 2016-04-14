The algorithm to use for hashing your input. The following values are supported:

* QUICK: Generates a 16-character, hexadecimal string. This algorithm provides fast hashing but offers no cryptographic security.
* MD5: Generates a 32-character string using the MD5 algorithm. This algorithm is considered cryptographically broken and unsuitable for further cryptographical use.
* CFMX_COMPAT: Deprecated. Lucee uses the MD5 algorithm instead.
* SHA: Generates a 40-character string using the Secure Hash Algorithm, SHA-1, specified by National Institute of Standards and Technology (NIST) in the FIPS-180-2 standard. Cryptographic weaknesses were discovered in SHA-1, and the standard is no longer approved for most cryptographic uses.
* SHA-256: Generates a 64-character string using the SHA-256 algorithm specified by the FIPS-180-2 standard.
* SHA-384: Generates a 96-character string using the SHA-384 algorithm specified by the FIPS-180-2 standard.
* SHA-512: Generates an 128-character string using the SHA-512 algorithm specified by the FIPS-180-2 standard.

The default value is MD5.
