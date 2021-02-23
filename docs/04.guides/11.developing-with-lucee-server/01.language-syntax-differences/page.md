---
title: Lucee Language and Syntax Differences
id: language-syntax-differences
menuTitle: Language and Syntax
related:
- lucee-5-unquoted-arguments
---

## Architecture ##

Adobe ColdFusion (ACF) is configured in a way that only one single web context is available for a server instance. This means that if you do not secure your single applications they might become vulnerable, you will have to use sandbox security, single instances, etc... This and the fact that you do not have the ability to configure individual CF settings for each virtual host are the major disadvantages of this setup. A big advantage however is the fact that a virtual host only needs to be defined in the web server configuration in order to properly be picked up by ACF.

When setting up Lucee Server in an older configuration the definition of the virtual host always had to be done in two places, the web server and application server configuration. The biggest downside was that specific application servers always had to be restarted (like Tomcat or JBoss) in order for the changes to be initiated. Other application servers like Jetty and Resin accepted the new virtual host without requiring a restart. This simply depends on the application server implementation.

With the introduction of [mod_cfml](http://www.modcfml.org/) for Tomcat these changes in the server.xml configuration file do not have to be made anymore, therefore restarting Tomcat is no longer necessary. The changes will be picked up automatically when the web server sends an unknown host to Tomcat with the corresponding root directory.

[View bugs and issues relating to Lucee's compatibility with ACF](https://luceeserver.atlassian.net/issues/?filter=-4&jql=labels%20in%20%28acf-compat%2C%20compat%29%20order%20by%20created%20DESC)

## Administration ##

In terms of administration, the biggest difference between Lucee Server and ACF is that Lucee Server has an individual administrator for each virtual host definition and a server administrator for global definition or defaults. ACF only has one, which approximately correlates to the server administrator in Lucee Server.

### Auto include files ###

Lucee Server will not search auto include files (Application.cf*, onRequestEnd.cfm, etc...) outside of the web root. Depending on a setting in the administrator, ACF can search for auto include files up to the root of the drive the requested file is located on. If there is a virtual mapping that points to a different drive than the drive the web root lies on, ACF will crawl up the entire directory tree in order to find any auto include files.

### Relative paths ###

In Lucee Server relative paths can be used in any file related operation. With ACF it can end up starting at the directory root. Have a look at the following example:

We assume that the web root is located in the folder D:\project\myWebRoot\.
<cfdirectory action="list" directory="/" name="get"> <cfdump var="#get#">

The result will contain all files in the directory D:\project\myWebRoot\ in Lucee Server and in ACF all

### Mappings ###

In Lucee Server mappings can be made web accessible. This is necessary since the Lucee administrator is delivered from a compiled archive (Lucee archive) which is not really physically accessible to the application server or even the web server. This is not possible in ACF. Therefore if you define a mapping in Lucee and you want to have it available through the web server, just tick the checkbox in the corresponding detail page of the respective mapping.

### Web Services ###

Since ACF is running on [AXIS2](http://axis.apache.org/axis2/java/core/) there could be some incompatibilities in a small number of cases with complex web services. Lucee is currently changing it's underlying web service model to [CFX](http://cxf.apache.org/) which is a new project for web services to replace AXIS2 as the AXIS2 project is more or less discontinued. This web service implementation will be completely compatible to the functionality that AXIS2 implements.

## Language & syntax differences ##

Below all deviations from CFML standard syntax as well as the different runtime behaviours are described.

### Date comparison ###

The CFML Standard determines, that a string comparison in "if" clauses always has to be checked, whether the two compared strings could be date values, for example:

```lucee
	<cfif "01/01/2000" EQ "01.01.00">
```

Lucee only checks if both strings are dates if on at least one side of a comparison there is a date value. This checking is done at compile time. For example:

```lucee
	<cfif query.lastAccess EQ "01.01.00">
```

The reason for this is that only in rare cases the two strings contain date values. To check these strings for date values is very time consuming and only done if desired.

If you nevertheless want to check whether the two strings contain date values, you should use the function parseDateTime to translate a variable or a string into a date value. For example

```lucee
	<cfif parseDateTime(strDate) EQ parseDateTime("01.01.00")>
```

### cfproperty ###

Lucee does not support 'lazy' attribute in cfproperty:

```lucee
<cfscript>
    property name="Foo" fieldtype="id" fkcolumn="fooid" lazy="true" cfc="foo";
</cfscript>
```

### Date parsing ###

Lucee does not support implicit parsing of a date value in the locale format, for example:

```lucee
	<cfif now() EQ "Wednesday, January 30, 2002 7:02:12 AM PST">
```

In order to achieve this you have to use the function parseDateTime, for example:

```lucee
	<cfif now() EQ parseDateTime("Wednesday, January 30, 2002 7:02:12 AM PST")>
```

Again the reason for this is, that implicit parsing of strings to locale date formats is very time consuming.

### Boolean values converted into a string ###

If you convert a boolean value into a string Lucee generates the following values:

* true into "true"
* false into "false"

In the CFML standard a boolean will be converted into the above values only in compile time. At runtime boolean values are converted as follows:

* true into "Yes"
* false into "No"

#### Example ####

```lucee
	<cfoutput>#true#</cfoutput>
```

* Output Lucee and CFML Standard: true

```lucee
	<cfoutput>#1 EQ 1#</cfoutput>
```

* Output Lucee: true
* Output CFML Standard: Yes

### Switch/case in cfscript ###

ACF allows the omitting of spaces between the case statement and the value in parenthesis. So the following code will break in Lucee Server:

```lucee
<cfscript>
	switch(arguments.action) {
		case("caseA"): {
			doSomething;
			break;
		}
		case("caseB"): {
			doSomethingElse;
			break;
		}
		default: {
		//no action
		}
	}
</cfscript>
```

Lucee assumes case() is a function and therefore generates a syntax error message. This behaviour has changed in Lucee 4.2 since with the new tag notation in cfscript, the above example will now work.

## Searching CFCs & in the Custom Tag directory ##

In ACF CFC's are searched for inside all the defined custom tag directories as well. In addition they are searched for recursively in the sub directories of all the custom tag directories.

By default and for performance reasons, this is not supported by Lucee Server, however you can define individual directories where Lucee Server searches for CFCs, as well as being able to enable deep search, including sub directories. To do this simply add the custom tag directories under the setting component in the Lucee Server administrator.

### Keys containing dots ###

If a variable key has a dot in ACF it allows you to address this variable as if you had 2 keys, for example:

```luceescript
variables["a.b.c"]="Susi";
writedump(variables["a.b.c"]); // This works in ACF and Lucee Server
writedump(variables.a.b.c); // This works in ACF but fails in Lucee Server, because there is no key "a" in the variables scope!
```

The following construct also works in ACF:

```luceescript
1: variables["request.susi"]="Susi";
2: writedump(request.susi); // This works in ACF even though there is no key "susi" in the request scope!
```

Lucee Server does not support implicit addressing of keys. The reason for this is the fact that the above code can be completely misread and that programmers might have the, absolutely legitimate, impression that there should be a key called "susi" in the request scope, if they only looked at line 2.

To make handling these issues easier, Lucee Server has a built-in-function called structKeyTranslate() that converts a variable which contains dots in its name into cascading structures, for example:

```luceescript
variables["a.b.c"]="Susi";
structKeyTranslate(variables, true, true);
dump(variables);
```

The above will generate a structure like this:

```luceescript
{a:{b:{c:"Susi"}}, "a.b.c":"Susi"}
```

### Annotations ###

In cfscript annotations can be used in order to "decorate" functions and their arguments. Unlike ACF, Lucee Server never overwrites attributes that change the behaviour of the function itself. So attributes like output, returntype, returnformat can not be set using annotations. These annotations will be ignored in Lucee Server.

Example:

```luceescript
/**
* my Hint
* @prop1 Property 1
* the rest of the hint
*/ function test(arg1){ }
```

Now if you call getMetaData(test) you will get a struct that contains additional keys (in this case prop1). Other implementations allow you to define each possible argument of a function in annotation style, just like this:

```luceescript
/**
*
* @returntype string
*/
function test(arg1) { }
```

This notation and thus the functionality behind it means, that comments are affecting the code's behaviour, which Lucee Server does NOT support. The following example will throw a compiler error:

```luceescript
/**
* @returntype string
*/

public int function test(arg1) {
}
```

ACF throws the following error:

Attribute validation error. A duplicate attribute RETURNTYPE has been encountered. Attributes with the same name cannot be provided more than once.

Lucee will simply ignore the parts of the comment if it affects the code execution at runtime. In our opinion you should never receive a compiler error because of a comment you have made in your code. In ACF even the following would throw an error, which is wrong since it IS just a comment:

```luceescript
/**
* please never ever use the comment
@returntype since this might crash
something in the compiler.
*/
public int function test(arg1) {
}
```

Lucee Server always ignores definitions which contain doc comments that might interfere with allowed arguments of a function definition (like output, returntype etc.).

Lucee Server will also never throw an exception if something is wrong in the doc comment or meta data for a param which is defined inside the comment and also within the statement.

In short, the doc comments will only provide data for the return of the function getMetadata() and nothing else.

### Scope names cannot be overwritten ###

In ACF you can overwrite scope names as follows (this will only work inside UDF's):

```luceescript
function test(string url){
    writeDump(arguments.url);// outputs the string passed in Lucee Server and ACF
    writeDump(url);// in ACF outputs the string passed, in Lucee Server the url scope
}

test("https://lucee.org");
url="https://lucee.org"; // same as variables.url="https://lucee.org"; in Lucee Server and ACF

qry=querynew('url');
queryAddrow...
querySetCell...
```

```lucee
<cfloop query="qry">
   <cfset _url=qry.url> <!--- in Lucee Server and ACF qry.url is invoked --->
   <cfset _url=url> <!--- in ACF qry.url is invoked in Lucee Server the url scope --->
```

In Lucee Server scope names are always invoked first. This means they are basically reserved words. Lucee Server intentionally does not follow ACF here because the ACF behaviour is inconsistent and makes it impossible to access the underlying scopes in the function example above.

### Passing array arguments to UDF's "by value" ###

In ACF arrays are duplicated before they are passed to a UDF, this is referred to as "pass by value". This is the only complex datatype that is passed by value instead of by reference. This is inconsistent as to built-in-function's ACF always passes the arguments by reference, otherwise functions like arrayAppend() would not work, so why not follow the same rule with UDF’s as well?

Passing by value is not only inconsistent, it is also slower, so Lucee Server does not follow ACF here on purpose.

Example:

```luceescript
function test(arr){
		arr[1]="Two";
}
arr=["One"];
test(arr); // in ACF the passed array is not touched and still contains the value "One" at position 1.
```

If you need Lucee to behave like ACF, you can use the cfargument attribute "passby" in order to pass a copy of the array to the function.

Example:

```lucee
<cffunction name="test">
<cfargument name="x" type="array" passby="value">
```

### Query of Query (QoQ) ###

There are several differences in using QoQ due to the underlying SQL engine used in the different CFML engines. These differences occur more often in complex SQL statements, for example when using grouping functions, etc. A small rewrite of the SQL code used should fix any issues you find.

### Indifference between the dot and bracket notation ###

ACF makes a difference when it comes to accessing variables either through bracket or dot notation. In order to make this difference between ACF and Lucee Server a little clearer, have a look at this example:

```luceescript
function test(argNotPassed){
    var x=arguments['argNotPassed']; // assigns null to x in Lucee Server and ACF
    var x=arguments.argNotPassed; // assigns null to x in Lucee Server and throws an exception in ACF
}
test();
```

From our perspective it makes absolutely no sense to handle dot and bracket notations in a different way. Therefore this is a deliberate incompatibility between ACF and Lucee Server.

### Simple type literals are not stored as strings internally ###

A literal is a final value which does not change at runtime or is not a variable. So literals can be:

```luceescript
b=true;
n=1234.5678;
```

ACF internally stores these two literals as strings, Lucee Server stores them as a Boolean and as a double. Lucee Server tries to store variables always in the format the user has defined them in the code, for the following reasons:

### logic ###

The user expects it to be stored in this format in most cases

### Performance ###

The chances are high that the same value type is used for mathematical or Boolean operations later. If converted to a string, it needs to be converted back to the appropriate type at runtime as necessary which has a negative effect on performance.

Example:

```luceescript
max=1000000;
for(1=0;i<max;i++); // ACF makes 1000000 string to number conversions in this case, Lucee Server not a single one.
```

### Format ###

If you convert these values into something else where the format is important, you get the wrong result, for example:

```luceescript
	serializeJSON(123); // outputs "123" in ACF, and not 123 like in Lucee Server
```
