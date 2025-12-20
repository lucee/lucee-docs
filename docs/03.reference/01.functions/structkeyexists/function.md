---
title: StructKeyExists
id: function-structkeyexists
related:
- function-sessionexists
- null_support
categories:
- struct
- decision
---

Determines whether a specific key is present in a structure.

In CFML, by default, this will return `false` for any keys with a `null` value, however, if Full Null Support is enabled, it will return `true`.

[[null_support]]

## See Also: Elvis and Safe Navigation Operators

For many common use cases, consider using these more concise alternatives:

- **Elvis operator (`?:`)** - Returns a default value if the left side is null or undefined:

  ```lucee
  // Instead of:
  if ( structKeyExists( args, "name" ) ) {
      result = args.name;
  } else {
      result = "default";
  }
  // Use:
  result = args.name ?: "default";
  ```

- **Safe navigation operator (`?.`)** - Safely traverse nested properties, combine with elvis for a default value:

  ```lucee
  // Instead of:
  if ( structKeyExists( user, "address" ) && structKeyExists( user.address, "city" ) ) {
      city = user.address.city;
  } else {
      city = "Unknown";
  }
  // Use:
  city = user?.address?.city ?: "Unknown";
  ```

  [[operators]]