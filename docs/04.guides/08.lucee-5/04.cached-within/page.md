---
title: Cached Within
id: lucee-5-cached-within
---

## CachedWithin ##

The attribute `cachedWithin` has been added to the tags `cffile` and `cfhttp` and it has also been added as an interface to Lucee so you can make your own `cachedwithin` implementation.

## Supported with cffile and cfhttp ##

The possibility to cache the result of the tags `cffile` and `cfhttp` has been added in Lucee 5 using the attribute `cachedWithin` for these tags.

```lucee
<cffile action="read" file="test.txt" variable="content" cachedWithin="request"/>
<cfhttp url="https://lucee.org" name="http" cachedWithin="#createTimespan(0,0,0,10)#"/>
```

## Interface for cachedWithin ##

Lucee 5 extends with an interface making it possible to make an extension for the `cachedWithin` attribute in Java.

Lucee's built-in `cachedWithin` attributes supports two types, `request` and `timespan`.
