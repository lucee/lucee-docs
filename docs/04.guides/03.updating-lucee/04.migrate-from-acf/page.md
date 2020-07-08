---
title: Migrating to Lucee from ColdFusion
id: updating-lucee-migrate-from-acf
related:
- language-syntax-differences
description: How to migrate/port your code from Adobe ColdFusion to Lucee
menuTitle: Migrating from ColdFusion
---

## Migrating from Adobe(R) ColdFusion(R) ##

Lucee is highly compatible with ACF, and most of your cfml/cfscript code that runs on ACF will run on Lucee without any modifications.

There are, however, some known issues of compatibility that you should be aware of, and that might affect your application if your code utilizes the affected features:

### Arrays in ACF are passed by value ###

**What:**
In ACF [[object-array]]s are passed to functions by value, meaning that if you call a function and the argument(s) passed to it are arrays, then the arrays are first copied into a new object, and the function then uses that new object.  

In Lucee -- passing an array to a function is done by a pointer, like all other complex objects.

For example:

```luceescript
function writeArrayPlusOne(arr) {
  arr.append( arr.len() + 1 );
  for (var el in arr) writeOutput( el );
}
arr = [ 1, 2, 3 ];
writeArrayPlusOne( arr );
writeDump( arr );
```

The example above will show `arr` with items `[ 1, 2, 3 ]` on ACF, but `[ 1, 2, 3, 4 ]` on Lucee

**Why:**
We decided not to follow the ACF way for the following reasons:

* Performance - copying the array for each function call adds a lot of unnecessary overhead
* Consistency - Passing an array by value is inconsistent with all of the other _complex_ object types which are passed by pointer

### CreateTimeSpan returns a timespan, not a date ###

**What:**
In ACF, [[function-CreateTimeSpan]] returns a date type, meaning that if you have a function that returns a timespan value, or takes a timespan as an argument, it will thow an error in Lucee.  This has two solutions: change the date to timespan, or use numeric, which works in both.

For example:

```luceescript
<cfscript>
  setSessionTimeout(CreateTimeSpan(0,0,20,0));
</cfscript>
```

```lucee
<cffunction name="setSessionTimeout">
  <cfargument name="timeout" type="numeric" required="true">
  <cfset this.sessionTimeout = timeout>
</cffunction>

```

### Iterations argument for the Hash function is off by one ###

**What:**
The iterations value represents the total number of hashes on Lucee, in Adobe CF the value is the number of additional iterations.

For example:

```luceescript
Hash("somestring", "SHA-512", "utf-8", 100); // in ACF

Hash("somestring", "SHA-512", "utf-8", 101); // Lucee

```
