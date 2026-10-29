<!--
{
  "title": "bcrypt Password Hashing in Lucee 7",
  "id": "bcrypt-password-hashing-lucee7",
  "categories": ["java", "maven", "crypto"],
  "since": "7.0",
  "description": "Simple recipe for hashing and verifying passwords with bcrypt in Lucee 7 using Maven integration and the at.favre.lib bcrypt library",
  "keywords": [
    "bcrypt",
    "GenerateBCryptHash",
    "VerifyBCryptHash",
    "Password Hashing",
    "Maven",
    "Java Integration"
  ],
  "related": [
    "maven",
    "yaml-processing-lucee7"
  ]
}
-->

# bcrypt Password Hashing in Lucee 7

Adobe ColdFusion 2021 has the functions `GenerateBCryptHash()` and `VerifyBCryptHash()`. Lucee doesn't ship bcrypt functions, because Lucee 7's Maven integration makes it easy to load a well-maintained Java library and use it directly from CFML. No extension is needed.

This recipe uses the [bcrypt](https://github.com/patrickfav/bcrypt) library by Patrick Favre-Bulle (`at.favre.lib:bcrypt`).

## Maven Dependency

First, find the latest version at [mvnrepository.com](https://mvnrepository.com/artifact/at.favre.lib/bcrypt). Currently version 0.10.2 is available:

```gradle
implementation("at.favre.lib:bcrypt:0.10.2")
```

## Simple Example

Create a component `BcryptHasher.cfc` that generates and verifies hashes:

```cfml
component javasettings='{"maven":["at.favre.lib:bcrypt:0.10.2"]}' {

    variables.cost = 12; // work factor, each +1 doubles the time

    function generate(required string password) {
        // returns a 60 character string like $2a$12$<22 char salt><31 char hash>
        return java:at.favre.lib.crypto.bcrypt.BCrypt::withDefaults()
            .hashToString(variables.cost, arguments.password.toCharArray());
    }

    function verify(required string password, required string stored) {
        // the library compares the hashes in constant time
        var result = java:at.favre.lib.crypto.bcrypt.BCrypt::verifyer()
            .verify(arguments.password.toCharArray(), arguments.stored);
        return result.verified;
    }

    function needsRehash(required string stored) {
        // the cost is stored in the hash: $2a$12$...
        return val(listGetAt(arguments.stored, 2, "$")) < variables.cost;
    }
}
```

`BCrypt` only has static methods, so there is nothing to instantiate. The `java:` prefix with `::` calls a static method of a class loaded from the Maven dependency, no `createObject()` needed.

Usage:

```cfml
bcrypt = new BcryptHasher();

// when a user registers or changes their password
stored = bcrypt.generate("my secret password");
dump(stored); // $2a$12$<salt and hash>, store this string in your database

// when a user logs in
dump(bcrypt.verify("my secret password", stored)); // true
dump(bcrypt.verify("wrong password", stored));     // false

// optionally re-hash after a successful login if the stored cost is lower than today's
if (bcrypt.needsRehash(stored)) {
    stored = bcrypt.generate("my secret password");
}
```

## How it works

- **Random salt**: every hash gets its own random 16 byte salt, so equal passwords produce different hashes.
- **Everything is stored in the hash string**: the version (`$2a$`), the cost (`12`), the salt and the hash. `verify()` reads all of that from the stored value, so you can raise the cost later and old hashes still verify. `needsRehash()` shows how to detect weaker hashes at login.
- **Constant-time comparison**: the library compares the hashes in constant time. Don't compare hashes with `==` or `compare()`.
- **Compatible**: the result is a standard bcrypt string, so hashes created by other bcrypt implementations (`$2a$`, `$2b$` and `$2y$` prefixes) verify as well, and the other way round. This is also what you need to move users over from ACF's `GenerateBCryptHash()`.

## Choosing the cost

The cost factor is the base 2 logarithm of the number of rounds, so every +1 doubles the time. A cost of 12 takes a few hundred milliseconds on current hardware, which is a good starting point. The [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html) recommends at least 10. Measure it on your own hardware and pick the highest value your login times can afford.

## The 72 byte limit

bcrypt only uses the first 72 bytes of a password (in UTF-8, so non-ASCII characters count for more than one byte). This library throws a `java.lang.IllegalArgumentException` for longer passwords instead of silently ignoring the rest, so catch it or check the length before calling `generate()`:

```cfml
if (len(charsetDecode(password, "utf-8")) > 72) {
    throw type="application" message="Password is too long, 72 bytes is the maximum";
}
```

Don't truncate the password quietly. If you need to support longer passwords, pre-hash them with SHA-256 and Base64 encode the result before passing it to bcrypt, so the input stays well below 72 bytes and contains no null bytes. Do that for every password, not only the long ones, so `generate()` and `verify()` always treat them the same way.

That's all you need to start using bcrypt in Lucee 7! Maven handles downloading the library automatically.
