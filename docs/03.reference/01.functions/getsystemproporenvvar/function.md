---
title: GetSystemPropOrEnvVar
id: function-getsystemproporenvvar
related:
- environment-variables-system-properties
categories:
    - server
---

Return the list of supported system properties or env vars Lucee supports.

Lucee treats the following config as identical, but System Properties take precedence.

- `lucee.admin.enabled` (Java System Property)
- `LUCEE_ADMIN_ENABLED` (Environment variables)