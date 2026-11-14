**JwtDecode does NOT verify the signature.** It reads the header and payload without checking whether the token was tampered with. Never trust the claims from JwtDecode alone — always use [[function-jwtverify]] before acting on token contents.

Valid uses for JwtDecode:

- Inspecting the `kid` (key ID) header to look up the correct verification key
- Debugging token contents during development
- Checking the `alg` header before choosing a verification strategy
