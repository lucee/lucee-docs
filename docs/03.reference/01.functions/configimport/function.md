---
title: configimport
id: function-configimport
related:
categories:
---

Imports a configuration based on the "CFConfig" format. 

This configuration can be provided as a path (String) to a JSON based file or as a Struct.

The values inside the provided configuration can use placeholders following this pattern ${key:default}.

The function will check for the actual values for this placeholders in 3 places (in this order):

- function argument "params" (if provided)
- system properties
- environment variables