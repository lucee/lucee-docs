---
title: PagePoolClear
id: function-pagepoolclear
related:
- function-pagepoollist
categories:
- cache
- server
description: Clear out all the cfml code (cfm, cfcs) in the cache of compiled code (aka the Page Pool)
---

Purges the cfml code (cfm, cfcs) from the cache of compiled bytecode (aka the Page Pool)

**This function no longer recommended**.

Please use [[function-inspecttemplates]] instead, which only marks this cache as being dirty, thus triggering a check on use, to see if the underlying cfml file has changed, which is extremely efficient both in terms of memory usage and CPU. 
