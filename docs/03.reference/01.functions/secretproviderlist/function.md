---
title: SecretProviderList
id: function-secretproviderlist
related:
- function-secretproviderlistnames
- function-secretproviderset
- function-secretproviderremove
categories:
- server
---

Returns a struct containing all secrets from a configured Secret Provider. Each key in the struct corresponds to a secret name, and each value is a reference object (similar to SecretProviderGet) that resolves to the actual secret value when used.
When no provider name is specified, the function aggregates secrets from all configured providers. If the same secret key exists in multiple providers, the first provider (in configuration order) takes precedence.