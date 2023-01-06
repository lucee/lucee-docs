---
title: configImport
id: function-configimport
related:
categories:
- server
description: Imports configuration using the "CFConfig.json" format.
---

Imports server configuration defineď based on the [CFConfig](https://cfconfig.ortusbooks.com/the-basics/config-items) schema. 

This configuration can be provided as a path (String) to a JSON based file or as a `Struct`.

The values inside the provided configuration can use placeholders, following this pattern ${key:default}.

The function will check for the actual values for this placeholders in 3 places (in this order):

- Function arguments "params" (if provided)
- System properties
- Environment variables

[[directory-placeholders]] will be passed thru and dynamically evaluated when used.
