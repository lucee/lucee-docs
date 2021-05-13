The algorithm to use to decrypt the string. Must be the same as the algorithm used to encrypt the string.

- CFMX_COMPAT(default): the CFML specific algorithm. This algorithm is the least secure option
- AES: the Advanced Encryption Standard specified by the National Institute of Standards and Technology (NIST) FIPS-197
- BLOWFISH: the Blowfish algorithm defined by Bruce Schneier
- DES: the Data Encryption Standard algorithm defined by NIST FIPS-46-3
- DESEDE: the "Triple DES" algorithm defined by NIST FIPS-46-3
You may also specify other algorithm names as well as the feedback mode and padding scheme where applicable (in the format algorithm/mode/padding) as documented in the Java Cryptography Architecture (JCA) Reference Guide.
