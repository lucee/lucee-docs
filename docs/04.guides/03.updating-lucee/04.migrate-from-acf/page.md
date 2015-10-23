---
title: Migrate from ACF
id: updating-lucee-migrate-from-acf
---

# Migrate from Adobe(R) ColdFusion(R) #

Lucee is highly compatible with ACF, and most of your cfml/cfscript code that runs on ACF will run on Lucee without any modifications.

There are, however, some known issues of compatibility that you should be aware of, and that might affect your application if your code utilizes the affected features:

### Arrays in ACF are passed by value ###
**What:**
In ACF arrays are passed to functions by value, meaning that if you call a function and the argument(s) passed to it are arrays, then the arrays are first copied into a new object, and the function then uses that new object.  In Lucee -- passing an array to a function is done by a pointer, like all other complex objects.

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
