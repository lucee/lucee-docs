---
title: SecretProviderListNames
id: function-secretproviderlistnames
related:
- function-secretproviderlist
- function-secretproviderset
- function-secretproviderremove
categories:
- server
---

Returns an array containing the names (keys) of all secrets available in a configured Secret Provider. This function only returns the secret names, not the actual secret values.
When no provider name is specified, the function aggregates secret names from all configured providers, returning a deduplicated and sorted list.