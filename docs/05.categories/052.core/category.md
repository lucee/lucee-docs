---
title: Core CFML Language
id: category-core
---

The core elements of the CFML Language.

CFML started as a tag based language and then introduced [[tag-script]].

So keep in mind, all these tags, i.e [[tag-if]] can be also used in [[tag-script]], which is similar to JavaScript.

```lucee
// tag
<cfif redirect>
    <cflocation url="https://www.lucee.org">
</cfif>

// cfscript
if (redirect)
    location url="https://www.lucee.org";
    // or
    location(url="https://www.lucee.org");
}

// tags
<cfloop from=1 to=10 item="i">
  <cfoutput>#i#</cfoutput>
</cfloop>

// cfscript
loop from=1 to=10 item="i" {
  echo(i);
}
```
