<!--
{
  "title": "scrypt Password Hashing in Lucee 7",
  "id": "scrypt-password-hashing-lucee7",
  "categories": ["java", "maven", "crypto"],
  "since": "7.0",
  "description": "Simple recipe for hashing and verifying passwords with scrypt in Lucee 7 using Maven integration and Bouncy Castle",
  "keywords": [
    "scrypt",
    "GenerateSCryptHash",
    "VerifySCryptHash",
    "Password Hashing",
    "Bouncy Castle",
    "Maven",
    "Java Integration"
  ],
  "related": [
    "maven",
    "yaml-processing-lucee7",
    "excel-processing-lucee7"
  ]
}
-->

# scrypt Password Hashing in Lucee 7

Adobe ColdFusion 2021 has the functions `GenerateSCryptHash()` and `VerifySCryptHash()`. Lucee doesn't ship scrypt functions, because Lucee 7's Maven integration makes it easy to load a well-maintained Java library and use it directly from CFML. No extension is needed.

This recipe uses the scrypt implementation of [Bouncy Castle](https://www.bouncycastle.org/).

## Maven Dependency

First, find the latest Bouncy Castle version at [mvnrepository.com](https://mvnrepository.com/artifact/org.bouncycastle/bcprov-jdk18on). Currently version 1.86 is available:

```gradle
implementation("org.bouncycastle:bcprov-jdk18on:1.86")
```

## Simple Example

Create a component `ScryptHasher.cfc` that generates and verifies hashes:

```cfml
component javasettings='{"maven":["org.bouncycastle:bcprov-jdk18on:1.86"]}' {
    // cost parameters, see "Choosing parameters" below
    variables.N = 131072; // CPU/memory cost, must be a power of 2 (2^17)
    variables.r = 8;      // block size
    variables.p = 1;      // parallelization
    variables.keyLength = 32; // bytes

    // static class, loaded from the Maven dependency above
    variables.scrypt = createObject("java", "org.bouncycastle.crypto.generators.SCrypt");

    function generate(required string password) {
        // random 16 byte salt
        var salt = createObject("java", "java.security.SecureRandom").generateSeed(16);
        var hash = variables.scrypt.generate(
            charsetDecode(arguments.password, "utf-8"),
            salt, variables.N, variables.r, variables.p, variables.keyLength
        );
        // store the parameters and the salt together with the hash
        return "$scrypt$#variables.N#$#variables.r#$#variables.p#$#toBase64(salt)#$#toBase64(hash)#";
    }

    function verify(required string password, required string stored) {
        var parts = listToArray(arguments.stored, "$");
        if (arrayLen(parts) != 6 || parts[1] != "scrypt") return false;

        var salt     = toBinary(parts[5]);
        var expected = toBinary(parts[6]);
        var actual   = variables.scrypt.generate(
            charsetDecode(arguments.password, "utf-8"),
            salt, val(parts[2]), val(parts[3]), val(parts[4]), len(expected)
        );
        // constant-time comparison, avoids timing attacks
        return createObject("java", "java.security.MessageDigest").isEqual(actual, expected);
    }
}
```

Usage:

```cfml
scrypt = new ScryptHasher();

// when a user registers or changes their password
stored = scrypt.generate("my secret password");
dump(stored); // $scrypt$131072$8$1$<salt>$<hash>, store this string in your database

// when a user logs in
dump(scrypt.verify("my secret password", stored)); // true
dump(scrypt.verify("wrong password", stored));     // false
```

## How it works

- **Random salt**: every hash gets its own 16 byte salt from `java.security.SecureRandom`, so equal passwords produce different hashes.
- **Parameters are stored with the hash**: the string contains N, r, p, the salt and the hash. `verify()` reads the parameters from the stored value, so you can raise the cost later and old hashes still verify. You can compare them with the current parameters on login and re-hash the password if they are weaker.
- **Constant-time comparison**: `MessageDigest.isEqual()` takes the same time no matter where the two values differ. Don't compare the hashes with `==` or `compare()`.
- **Tunable**: the four scrypt parameters (N, r, p and the key length) are plain variables at the top of the component. Turn them into arguments of `generate()` if you need different values per call.

## Choosing parameters

The memory needed is about `128 * N * r` bytes. N=131072, r=8, p=1 (2^17) needs roughly 128 MB and takes a few hundred milliseconds, which is the [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html) recommendation for scrypt. Measure it on your own hardware and make sure your JVM has enough heap for your number of concurrent logins. If memory is tight, OWASP lists equivalent combinations with a lower N and a higher p, for example N=32768 (2^15), r=8, p=3.

That's all you need to start using scrypt in Lucee 7! Maven handles downloading the library automatically.
