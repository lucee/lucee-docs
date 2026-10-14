---
title: SecretProviderSet
id: function-secretproviderset
related:
- function-secretproviderlist
- function-secretproviderlistnames
- function-secretproviderremove
categories:
- server
---

Sets a secret value in a configured Secret Provider. The value type is automatically detected and stored appropriately as a string, boolean, or integer.
Note: Not all Secret Providers support writing. Providers that are read-only (such as environment variables) will throw an exception when attempting to set a value.