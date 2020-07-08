---
title: Reserved Words
id: reserved-words
---

There are very few reserved words in the Lucee CFML templating language, but there are a few that cannot be used all over the place.

Those words are:

* null (since Lucee 4.1)
* true
* false

Even words such as "application" and "function" can be used as they are not reserved, so code such as:

```lucee
<cfscript>
	application = 1;
	function = 1;
</cfscript>
```

is still valid, but since the words above are NOT valid, the following is NOT allowed :

```lucee
<cfscript>
	true = 1;
	null = 1;
</cfscript>
```

In Lucee Server scope names are always invoked first, which therefore basically makes all scope names, e.g. variables, url, form, session, etc... reserved words.
