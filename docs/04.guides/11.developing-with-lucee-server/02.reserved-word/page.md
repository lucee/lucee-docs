---
title: Reserved Words
id: reserved-words
categories:
- core
- scopes
description: 'The only reserved words in Lucee are null, true and false. scope names '
---

The reserved words in the Lucee CFML templating language are

- null (since Lucee 4.1)
- true
- false

But there are a few that cannot be used all over the place.

Even words such as "application" and "function" can be used as they are not reserved, so code such as:

```lucee
<cfscript>
	application = 1; // but keep reading below
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

In Lucee Server [[scopes]] are always invoked first, which means all scope names, e.g. variables, url, form, session, application... are effectively reserved words. Lucee resolves scopes before a variable with the same name, so they can't be referenced/reached.

```luceescript+trycf
application = 1;
dump( application ); // returns the application struct (not 1)

// normal structs can use scope names
st = {};
st.application = 1;
dump( st.application ); // returns 1
```
