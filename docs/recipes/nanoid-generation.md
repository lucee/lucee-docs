<!--
{
  "title": "NanoID Generation in Lucee 7",
  "id": "nanoid-generation-lucee7",
  "categories": ["java", "maven", "data-processing"],
  "since": "7.0",
  "description": "Simple recipe for generating short, URL-safe unique IDs (NanoID) in Lucee 7 using Maven integration and jnanoid, as an alternative to createUUID()",
  "keywords": [
    "NanoID",
    "jnanoid",
    "createUUID",
    "Unique ID",
    "Maven",
    "Java Integration"
  ],
  "related": [
    "maven",
    "createuuid",
    "yaml-processing-lucee7",
    "scrypt-password-hashing-lucee7"
  ]
}
-->

# NanoID Generation in Lucee 7

[NanoID](https://github.com/ai/nanoid) is a small, secure, URL-safe unique ID generator. It is a shorter alternative to [[function-createuuid]]: a default NanoID is 21 characters and uses only `A-Za-z0-9_-`, so it can be used as is in URLs, file names and HTML ids. `createUUID()` returns 35 characters.

```
createUUID():  C833E2CD-1A28-4DA4-BCC57D021393BDB1
NanoID:        V1StGXR8_Z5jdHi6B-myT
```

Lucee doesn't ship a NanoID function. Lucee 7's Maven integration makes it easy to load [jnanoid](https://github.com/aventrix/jnanoid), the Java implementation, and use it directly from CFML. No extension is needed.

## Maven Dependency

First, find the latest jnanoid version at [mvnrepository.com](https://mvnrepository.com/artifact/com.aventrix.jnanoid/jnanoid). Currently version 2.0.0 is available:

```gradle
implementation("com.aventrix.jnanoid:jnanoid:2.0.0")
```

## Simple Example

Create an ID with this simple inline component:

```cfml
generator = new component javasettings='{"maven":["com.aventrix.jnanoid:jnanoid:2.0.0"]}' {
    import com.aventrix.jnanoid.jnanoid.NanoIdUtils;

    function nanoId() {
        return NanoIdUtils::randomNanoId();
    }
};

// Usage
dump(generator.nanoId()); // for example "V1StGXR8_Z5jdHi6B-myT"
```

`NanoIdUtils` only has static methods, so it is called with the `::` operator, no instance and no `createObject()` needed. The `import` makes the class available by its short name, and the class is found because the component declares the dependency in `javasettings`.

## Custom Length and Alphabet

For production use, create a separate component `NanoIdGenerator.cfc`. It also lets you choose the length and the alphabet of the ID:

```cfml
import java.security.SecureRandom;
import com.aventrix.jnanoid.jnanoid.NanoIdUtils;

component javasettings='{"maven":["com.aventrix.jnanoid:jnanoid:2.0.0"]}' {

    // a single SecureRandom is thread safe and can be shared
    variables.random = new SecureRandom();

    // default: 21 characters from A-Za-z0-9_-
    function generate() {
        return NanoIdUtils::randomNanoId();
    }

    // custom length and/or alphabet
    function generateCustom(required numeric length, string alphabet = "") {
        if (!len(arguments.alphabet)) {
            return NanoIdUtils::randomNanoId(variables.random, NanoIdUtils::DEFAULT_ALPHABET, arguments.length);
        }
        // jnanoid expects the alphabet as a char array
        return NanoIdUtils::randomNanoId(variables.random, arguments.alphabet.toCharArray(), arguments.length);
    }
}
```

Usage:

```cfml
nano = new NanoIdGenerator();

dump(nano.generate());           // V1StGXR8_Z5jdHi6B-myT (21 characters)
dump(nano.generateCustom(10));   // wnT_R_blLR (shorter, 10 characters)
dump(nano.generateCustom(8, "0123456789abcdef"));                  // 4542f54e (hex only)
dump(nano.generateCustom(6, "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"));  // WDE7D3 (no confusing 0/O, 1/I)
```

## Using it in the whole application

If you need NanoIDs in many places, declare the dependency once in your `Application.cfc` instead of in every component, and call the class from any template or component of the application:

```cfml
component {
    this.name = "myapp";
    this.javasettings = { maven: ["com.aventrix.jnanoid:jnanoid:2.0.0"] };
}
```

```cfml
import com.aventrix.jnanoid.jnanoid.NanoIdUtils;

dump(NanoIdUtils::randomNanoId());
```

If you prefer not to use `import`, the fully qualified `java:` prefix works as well:

```cfml
dump(java:com.aventrix.jnanoid.jnanoid.NanoIdUtils::randomNanoId());
```

## Things to know

- **Secure**: the default generator uses `java.security.SecureRandom`, so the IDs are unpredictable, not only unique.
- **Collisions**: the shorter the ID or the smaller the alphabet, the higher the chance of two equal IDs. A 21 character NanoID has a collision probability comparable to a UUID v4. If you shorten the ID or the alphabet, check it with the [NanoID collision calculator](https://zelark.github.io/nano-id-cc/) and keep a unique constraint on the column in your database.
- **Errors**: a length below 1 throws a `java.lang.IllegalArgumentException`, don't catch and ignore it.

That's all you need to start generating NanoIDs in Lucee 7! Maven handles downloading the library automatically.
