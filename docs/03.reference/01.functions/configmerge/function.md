---
title: ConfigMerge
id: function-configmerge
related:
- function-getapplicationsettings
categories:
- server
---

Merges two Lucee configuration structs (as used in .CFConfig.json) into a new struct,
following Lucee's internal merge rules. The right-hand config takes precedence over the
left-hand config for scalar values, while certain collection types (such as extensions)
are appended rather than replaced. Neither input struct is modified; the result is
returned as a new struct.