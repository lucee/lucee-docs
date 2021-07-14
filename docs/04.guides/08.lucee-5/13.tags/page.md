---
title: New and modified tags
id: lucee-5-tags
---

# Loop - times #

Lucee 5 also extends the popular `cfloop` tag with a new way to do a very simple and fast loop. If you have simply to loop something a certain number of times and you do not require an index, this is the fastest way to do it.

Example:

```lucee
<cfloop times="5">
    Hi There
</cfloop>

<cfscript>
  loop times="5" {
     echo("Hi There");
  }
</cfscript>
```

# Cachedwithin #

The attribute cachedWithin that you will already know from tags like `cffunction` or `cfquery` is now also supported for the following tags:

* cffile
* cfhttp

For more, see [[lucee-5-cached-within]].
