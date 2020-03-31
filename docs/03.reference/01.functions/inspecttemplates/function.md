---
title: InspectTemplates
id: function-inspecttemplates
related:
- function-pagepoolclear
- function-pagepoollist
- function-systemcacheclear
categories:
- cache
- server
description: Flag all the cfml code (cfm, cfcs) in the cache of compiled code (aka the PagePool) to be checked once for any changes.
---

Flag all the cfml code (cfm, cfcs) in the cache of compiled code (aka the PagePool) to be checked once for any changes.

To be used when Inspect Templates is set to Never (Server/Web Administrator: Settings -> Performance/Caching)

This is more efficient than [[function-pagepoolclear]] which simply clears the entire cache

Since 5.3.6
