---
title: SecretProviderGet
id: function-secretproviderget
related:
categories:
- server
---

Returns a reference to a secret value stored in a configured Secret Provider. The function doesn't immediately return the actual value, but rather a value object that can be handled by Lucee like a simple value.

This reference is automatically resolved to its actual value when:

- It's converted to a real simple value (string, boolean, number, date)
- It's used in operations requiring a simple value

When used, the function automatically validates that the secret exists and throws an exception if not found.