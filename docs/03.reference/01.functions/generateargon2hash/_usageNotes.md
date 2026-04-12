This function is provided by the bundled argon2 extension and also by the crypto extension (which replaces it). It uses legacy defaults (argon2i, 8 KB memory, 1 iteration) which are weaker than current OWASP recommendations.

For new code, prefer [[function-argon2hash]] which defaults to argon2id with 19 MB memory and 2 iterations. Existing code using GenerateArgon2Hash will continue to work — hashes created with either function can be verified by [[function-argon2verify]].
