---
title: SecretProviderRemove
id: function-secretproviderremove
related:
- function-secretproviderlist
- function-secretproviderlistnames
- function-secretproviderset
categories:
- server
---

Removes a secret from a configured Secret Provider.
When no provider name is specified, the function searches all configured providers and removes the secret from the first provider that contains it.
Note: Not all Secret Providers support removal. Providers that are read-only (such as environment variables) will throw an exception when attempting to remove a value.