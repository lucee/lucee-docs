---
title: Migrating to Lucee from ColdFusion
id: updating-lucee-migrate-from-acf
related:
- language-syntax-differences
- scopes
- orm-migration-guide
- function-structnew
- java-regex-engine
categories:
- compat
description: Known differences when migrating or porting CFML from Adobe ColdFusion to Lucee
menuTitle: Migrating from ColdFusion
---

## Migrating from Adobe(R) ColdFusion(R) ##

This page may not cover every difference between Adobe ColdFusion and Lucee. If you encounter something that is not listed here, please report it on the [Lucee developer forum](https://dev.lucee.org/) or open an LDEV ticket so we can add it.

Lucee is highly compatible with ACF, and most of your CFML/CFScript code that runs on ACF will run on Lucee without any modifications.

There are, however, some known differences that you should be aware of, and that might affect your application if your code uses the affected features.

The function and tag reference at [docs.lucee.org](https://docs.lucee.org/) lists each one's arguments, so that is the quickest way to check any you are unsure about. A good first step is to run the application on Lucee with full error reporting and fix issues as they come up.

See also [[language-syntax-differences]] for more language and syntax detail, [[orm-migration-guide]] if you use ORM, and the [acf-compat](https://luceeserver.atlassian.net/issues/?jql=labels%20%3D%20%22acf-compat%22) label in the issue tracker for known differences.

### Built-in function arguments ###

**What:**
Lucee functions, with some exceptions, do not differ from the arguments ACF also has. Lucee may add additional arguments. Sometimes ACF later adds arguments or functions in a different way than Lucee already did.

[[function-structnew]] is a good example. Both engines accept `StructNew()` with no arguments, and both accept a `type` argument. Shared type values include `ordered` (Lucee also accepts `linked` as an alias), `casesensitive`, and `ordered-casesensitive`.

Lucee also has types that Adobe ColdFusion does not: `weak`, `soft`, `synchronized` (treated as a normal struct since Lucee 4.1), `max:N`, and `observable`.

The extra arguments after `type` are not the same:

* Lucee: `StructNew(type, onMissingKey, onChange)`. `onMissingKey` is a listener invoked when a requested key does not exist (since 6.0.0.107). `onChange` is only used with type `observable` (Lucee 9).
* Adobe ColdFusion (2016 Update 3 and later): `StructNew(type, sortType, sortOrder, localeSensitive)` or `StructNew(type, callback)` to create a sorted struct.

So `StructNew("ordered")` works on both. `StructNew("ordered", "text", "asc")` or `StructNew("ordered", callback)` does not mean the same thing: Adobe treats the extra arguments as sort settings or a sort callback, while Lucee treats a second argument as `onMissingKey`. Lucee also accepts at most three arguments.

### Arrays in ACF are passed by value ###

**What:**
In ACF [[object-array]]s are passed to functions by value, meaning that if you call a function and the argument(s) passed to it are arrays, then the arrays are first copied into a new object, and the function then uses that new object.

In Lucee, passing an array to a function is done by reference, like all other complex objects (structs, queries, and so on).

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

The example above will show `arr` with items `[ 1, 2, 3 ]` on ACF, but `[ 1, 2, 3, 4 ]` on Lucee.

**Why:**
ColdFusion 1 treated arrays as string lists. Later Adobe versions clone the array before passing it into a function so that older code still works. That copy is slow and inconsistent with how other complex types are passed.

From the start, Lucee (then Railo) decided not to follow that behaviour:

* Performance - copying the array for each function call adds a lot of unnecessary overhead
* Consistency - passing an array by value is inconsistent with all of the other _complex_ object types, which are passed by reference

If you need the old copy-by-value behaviour, add `passby="value"` on the argument:

```lucee
<cffunction name="test">
  <cfargument name="x" type="array" passby="value">
</cffunction>
```

### CreateTimeSpan returns a timespan, not a date ###

**What:**
In ACF, [[function-CreateTimeSpan]] returns a date type, meaning that if you have a function that returns a timespan value, or takes a timespan as an argument, it will throw an error in Lucee. This has two solutions: change the date to timespan, or use numeric, which works in both.

For example:

```luceescript
setSessionTimeout(CreateTimeSpan(0,0,20,0));
```

```lucee
<cffunction name="setSessionTimeout">
  <cfargument name="timeout" type="numeric" required="true">
  <cfset this.sessionTimeout = timeout>
</cffunction>
```

### Iterations argument for the Hash function is off by one ###

**What:**
The iterations value represents the total number of hashes on Lucee; in Adobe ColdFusion the value is the number of additional iterations.

For example:

```luceescript
Hash("somestring", "SHA-512", "utf-8", 100); // in ACF
Hash("somestring", "SHA-512", "utf-8", 101); // Lucee
```

### Date comparison ###

**What:**
The CFML standard determines that a string comparison in `if` clauses always has to check whether the two compared strings could be date values, for example:

```lucee
<cfif "01/01/2000" EQ "01.01.00">
```

Lucee only checks if both strings are dates if at least one side of a comparison is already a date value. This check is done at compile time. For example:

```lucee
<cfif query.lastAccess EQ "01.01.00">
```

Checking two arbitrary strings for date values is time consuming and only needed in rare cases. If you do want that check, use [[function-parseDateTime]]:

```lucee
<cfif parseDateTime(strDate) EQ parseDateTime("01.01.00")>
```

### Date parsing ###

**What:**
Lucee does not support implicit parsing of a date value in the locale format, for example:

```lucee
<cfif now() EQ "Wednesday, January 30, 2002 7:02:12 AM PST">
```

Use [[function-parseDateTime]] instead:

```lucee
<cfif now() EQ parseDateTime("Wednesday, January 30, 2002 7:02:12 AM PST")>
```

JDBC `DATE` columns may also come back as date/time values rather than date-only values. If your code depends on a date-only type, check the returned value and adjust it as needed.

### Boolean values converted into a string ###

**What:**
If you convert a boolean value into a string, Lucee generates `true` or `false`.

In the CFML standard a boolean is converted into those values only at compile time. At runtime Adobe ColdFusion converts them as follows:

* `true` into `"Yes"`
* `false` into `"No"`

```lucee
<cfoutput>#true#</cfoutput>
```

* Output Lucee and Adobe ColdFusion: `true`

```lucee
<cfoutput>#1 EQ 1#</cfoutput>
```

* Output Lucee: `true`
* Output Adobe ColdFusion: `Yes`

### Simple type literals and serializeJSON ###

**What:**
A literal is a final value which is not a variable, for example `b=true;` or `n=1234.5678;`.

Adobe ColdFusion internally stores these literals as strings. Lucee stores them as a boolean and as a number, which is how they were written in the code. That avoids extra conversions later and is faster for mathematical or boolean operations.

The format difference shows up when you serialize values:

```luceescript
serializeJSON(123); // outputs "123" in ACF, and 123 in Lucee
```

### Keys containing dots ###

**What:**
If a variable key has a dot, Adobe ColdFusion lets you address that variable as if you had nested keys:

```luceescript
variables["a.b.c"] = "Susi";
writeDump(variables["a.b.c"]); // works in ACF and Lucee
writeDump(variables.a.b.c); // works in ACF, fails in Lucee because there is no key "a"
```

This construct also works in ACF:

```luceescript
variables["request.susi"] = "Susi";
writeDump(request.susi); // works in ACF even though there is no key "susi" in the request scope
```

Lucee does not support implicit addressing of keys, because that code is easy to misread. [[function-structKeyTranslate]] can convert a dotted key name into cascading structures if you need that layout.

### Scope names cannot be overwritten ###

**What:**
In Adobe ColdFusion you can overwrite scope names inside a UDF. In Lucee, scope names are always resolved first; they are reserved words.

```luceescript
function test(string url){
	writeDump(arguments.url); // the string passed, in Lucee and ACF
	writeDump(url); // in ACF the string passed, in Lucee the url scope
}

test("https://lucee.org");
```

The ACF behaviour is inconsistent and can make it impossible to reach the real scope. Lucee does not follow it on purpose.

### Annotations in comments ###

**What:**
In CFScript, annotations in doc comments can decorate functions and their arguments. Unlike Adobe ColdFusion, Lucee never lets those comments change the behaviour of the function itself. Attributes such as `output`, `returntype`, and `returnformat` in a comment are ignored.

Lucee will not throw a compiler error because of a comment. The doc comments only provide extra data for `getMetadata()`.

### Dot notation vs bracket notation ###

**What:**
Adobe ColdFusion treats missing arguments differently depending on how you read them:

```luceescript
function test(argNotPassed){
	var x = arguments['argNotPassed']; // null in Lucee and ACF
	var x = arguments.argNotPassed; // null in Lucee, exception in ACF
}
test();
```

Lucee handles dot and bracket notation the same way.

### Query of Query (QoQ) ###

**What:**
There are several differences in Query of Query because of the underlying SQL engine. They show up more often in complex SQL, for example when using grouping functions. A small rewrite of the SQL usually fixes the issue.

### Searching CFCs in custom tag directories ###

**What:**
In Adobe ColdFusion, CFCs are also searched for inside all defined custom tag directories, including subdirectories.

By default, for performance reasons, Lucee does not do that. You can define individual directories where Lucee searches for CFCs, and you can enable a deep search, in the Lucee Administrator under the component settings.

### Administration, mappings, and paths ###

**What:**
Lucee has a server administrator for global defaults and a web administrator for each web context. Adobe ColdFusion has a single administrator, which is closer to Lucee's server administrator.

Lucee will not search auto-include files (`Application.cf*`, `onRequestEnd.cfm`, and so on) outside of the web root. Depending on a setting, Adobe ColdFusion can search up to the root of the drive.

In Lucee, relative paths in file operations start from the web root (or the expected current context). In Adobe ColdFusion a path like `"/"` can start at the drive root.

Lucee mappings can be made web-accessible. That is not possible in the same way in Adobe ColdFusion.

### Regular expressions ###

**What:**
Regular expression behaviour can differ between engines (for example whether `.` matches newlines). Lucee can use the Java regex engine or the legacy Perl/ORO engine. See [[java-regex-engine]] if your patterns do not match the same way they did on Adobe ColdFusion.

### ORM ###

**What:**
ORM configuration, events, and Hibernate versions differ from Adobe ColdFusion. See [[orm-migration-guide]].

### Features provided as extensions ###

**What:**
Some features that ship with Adobe ColdFusion are extensions in Lucee and need to be installed separately, including ORM, PDF, image handling, and Lucene search. Check the extension list in the Lucee Administrator or at [download.lucee.org](https://download.lucee.org/) if a tag or function is missing after you migrate.
