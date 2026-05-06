Originally provided by the [Argon2 Extension](https://github.com/lucee/extension-argon2) on Lucee 5.3.8.18+ and 6.x, and now also by the Crypto Extension on Lucee 7+ (which replaces it). 

It uses legacy defaults (argon2i, 8 KB memory, 1 iteration) which are weaker than current OWASP recommendations.

For new code, prefer [[function-argon2hash]] which defaults to argon2id with 19 MB memory and 2 iterations. Existing code using GenerateArgon2Hash will continue to work — hashes created with either function can be verified by [[function-argon2verify]].
