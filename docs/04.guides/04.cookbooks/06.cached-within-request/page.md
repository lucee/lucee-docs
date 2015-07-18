---
title: Cache a query for the current request
id: cookbook-cached-within-request
---

# Cache a Query for the current request #
maybe you are familiar with the "cachedwithin" attribute of the tag <cfquery>, that is normally used as follows:


```
#!html

<cfquery cachedWithin="#createTimeSpan(0,0,0,1)#">
select * from whatever where whatsoever='#whatsoever#'
</cfquery>
```

in that case the query is cached for ALL users for a single second. This is sometime used to cache a query for the current request, because most request are done in under a second.
Problem is that this cache is for all request and because of that more complicated to handle for Lucee what means unnecessary overhead on the system.

What you can do in this particular case is very simple, replace the timespan defined in the "cachedWithin" attribute with the value "request":

```
#!html

<cfquery cachedWithin="request">
select * from whatever where whatsoever='#whatsoever#'
</cfquery>
```

this way the query is cache only for the current request, independent how long this request takes!
