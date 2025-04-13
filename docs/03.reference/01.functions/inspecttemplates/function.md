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
description: Flag all the cfml code (cfm, cfcs) in the cache of compiled code (aka the Page Pool) to be checked once for any changes.
---

Flag all the cfml code (cfm, cfcs) in the cache of compiled code (aka the Page Pool) to be checked once for any changes.

This can used for example, when Inspect Templates is set to Never (Server/Web Administrator: Settings -> Performance/Caching)

This is way more efficient than [[function-pagepoolclear]] which simply clears the entire cache, which is expensive.

Since 5.3.6
