---
title: Loop - times
id: lucee-5-times
related:
- tag-loop
---

## Loop times="1000"

**Lucee 5 also extends the popular [[tag-loop]] tag with a new way to do a very simple and fast loop.

If you have simply to loop something a certain number of times and you do not require an index, this is the fastest way to do it.**

Example:

```coldfusion
<cfloop times="5">
    Hi There
</cfloop>

<cfscript>
  loop times="5" {
     echo("Hi There");
  }
</cfscript>
```
