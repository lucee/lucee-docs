---
title: Enhanced functions
id: lucee-enhanced-functions
---

Sometimes it makes sense to enhance functions with additional parameters in order to make it more flexible.

**createDateTime**

createDateTime(years, months, days, hours, minutes, seconds, milliseconds)

The createDateTime() function supports the argument milliseconds in order to create more accurate datetime values.

Example:

```lucee
<cfoutput>#createDateTime(2008,9,15,18,45,17,345)#</cfoutput>
```

**getFileInfo**

getFileInfo(sFile)

This function retrieves additional data about a file, like:

* isArchive
* isSystem
* scheme
* isCaseSensitive
* isAttributesSupported
* isModeSupported

**fileExists**

fileExists(fileObject)

The function fileExists also supports files created by the function FileOpen().

**getMetaData**

This function has been improved by a very interesting functionality. You are able to find out where (meaning which scope) a certain variable is defined. Just check out the following example:

```lucee
<cfset test()>
<cffunction name="test" output="Yes">
   <cfset variables.myVar = "test">
   <cfset url.myVar = "urlTest">
   <cfset form.myVar = "formTest">
   <cfset cookie.myVar = "cookieTest">
   <cfset client.myVar = "clientTest">
   <cfset var myVar = "localTest">
   <cfdump var="#getMetaData("myVar", true)#">
</cffunction>
```

The result looks like this: Struct local string localTest variables string test url string urlTest form string formTest cookie string cookieTest client string clientTest

One thing to mention is, that if you turn off scope cascading in the Lucee administrator you might obtain different results. Lucee only displays the variables that can be reached by using the variable unscoped.

**getTemplatePath**

When you call this function Lucee returns a simple value array. Simple value means that you can either use it as a single value represented by the first element or as an array. The array contains all files from the current one up to the original caller template. So if you dump the result of the function you might get the following: getTemplatePath Screenshot

Please note that when you hover with your cursor over the title of the dump, you can see the template where the dump was called (including the line number).

**numberFormat**

numberFormat(number [,]):String

Number Format supports next to the other known functions to allow numbers following a certain pattern but it also offers the possibility to change them into Roman numbers.

Example:

```lucee
<cfdump var="#numberFormat(1973,roman)#"></cfdump>
```

output: MCMLXXIII

**structNew()**

structNew([string]):Struct

The function structNew can make use of an initializing parameter which influences the type of struct.

The following values are allowed:

**structNew("normal")**

Basic type, same as if no type is defined.

**structNew("linked")**

The order of the keys in the struct is guaranteed.

**structNew("weak")**

The content of the might be flushed by the garbage collector. Weak structures can perfectly be used as caches. In case of a memory emergency the JRE garbage collector removes elements of weak structures with a higher priority.
