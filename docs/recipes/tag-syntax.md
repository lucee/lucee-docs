
<!--
{
  "title": "Tag Syntax",
  "id": "tag-syntax",
  "categories": [
    "scopes",
    "thread",
    "core"
  ],
  "description": "How to use tags in script",
  "keywords": [
    "Syntax",
    "tag",
    "function",
    "Script",
    "throw",
    "abort",
    "return",
    "unquoted",
    "attribute"
  ],
  "related": [
    "developing-with-lucee-server",
    "tag-script",
    "tags",
    "lucee-5-unquoted-arguments"
  ]
}
-->

# How to Use Tags in Script

Lucee is a versatile platform that supports two programming languages: a tag-based language that integrates seamlessly into HTML and a script-based language.

Lucee (or CFML in general) initially started as a purely tag-based language, but over time, support for scripting has grown.

More and more functionality from the tag environment has been brought into the script environment, including support for using tags directly in script syntax.

This guide explains how you can use tags in scripts or migrate tag.

## History of Tags in Script

Lucee supports two different tag syntaxes within scripts. 

The reason for this is rooted in a decision made by the "CFML Advisory Committee," which included members from Railo (now Lucee), Adobe, and BlueDragon.

The committee agreed on one syntax for tag use in scripts, but later Adobe chose to implement a different syntax. 

Since Lucee had already implemented the committee's original syntax,
it now supports both: the "Function Syntax" and the "Migration Syntax."

### Function Syntax and Migration Syntax

#### Function Syntax (recommended)

The **Function Syntax** in Lucee looks similar to regular function calls but does not support return values (yet). Here's an example:

**Tag-based syntax:**

```html
<cfsetting requestTimeout="10">
<cfloop from="1" to="#max#" index="i">
    <cf_myCustomTag var="#i#">
</cfloop>
```

**Function syntax in script:**

```javascript
cfsetting(requestTimeout="10");
cfloop(from=1, to=max, index="i") {
    cf_myCustomTag(var=i);
}
```

As you can see, the function syntax closely resembles typical function calls with named arguments, especially when there is no body for the tag.

#### Migration Syntax

The **Migration Syntax** is designed to look less like function calls, making it easier to migrate tag-based code into scripts. Here's how the same example would look using the migration syntax:

```javascript
setting requestTimeout="10";
loop from=1 to=max index="i" {
    _myCustomTag var=i;
}
```

The migration syntax is more distinct from functions, which can make the migration of existing tag-based code easier and less confusing.

## Differences Between Tag and Script

One of the key differences between tag-based code and script-based code is how **unquoted attribute values** are interpreted.

The examples below use [[tag-invokeargument]], which normally sits inside a [[tag-invoke]] call; only the argument line is shown.

### Tags: unquoted values are always strings

In tag syntax, an unquoted attribute value is always a literal string, exactly as if it was quoted. It is never evaluated as a number or a variable. This is the same in Lucee and Adobe ColdFusion (ACF).

```html
<cfset susi = 42>

<cfinvokeargument name="tNum" value=1234>      <!--- string "1234" --->
<cfinvokeargument name="tNum" value="1234">    <!--- string "1234" --->
<cfinvokeargument name="tNum" value=susi>      <!--- string "susi", NOT the variable susi --->
```

To pass a variable or any other expression in a tag, wrap it in `#`:

```html
<cfinvokeargument name="tNum" value="#susi#">  <!--- the variable susi (the number 42) --->
<cfinvokeargument name="tNum" value="#1234#">  <!--- the number 1234 --->
```

This also explains a common error. In this example:

```html
<cfset max=10>
<cfloop from="1" to=max index="i">
    ...
</cfloop>
```

`max` is the string `"max"`, not the variable, which leads to an error like "can't cast [max] string to a number value". Use `to="#max#"` instead.

### Script: unquoted values are expressions

In script, attribute values are expressions, just like function arguments. An unquoted number is a number, an unquoted name refers to a variable, and a quoted value is a string. The function syntax behaves the same in Lucee and ACF; Lucee's migration syntax (tags in script) follows the same rule.

```javascript
susi = 42;

// function syntax
cfinvokeargument( name="tNum", value="1234" ); // string "1234"
cfinvokeargument( name="tNum", value=1234 );   // number 1234
cfinvokeargument( name="tNum", value=susi );   // the variable susi (42)

// migration syntax (Lucee's tags in script; ACF doesn't support invokeargument in this form)
invokeargument name="tNum" value="1234";       // string "1234"
invokeargument name="tNum" value=1234;         // number 1234
invokeargument name="tNum" value=susi;         // the variable susi (42)
```

So the loop example from above works in script without `#`:

```javascript
max = 10;
loop from="1" to=max index="i" {
    ...
}
```

### Summary

| Code | Tag syntax | Script syntax |
|---|---|---|
| `value="1234"` | string `"1234"` | string `"1234"` |
| `value=1234` | string `"1234"` | number `1234` |
| `value=susi` | string `"susi"` | variable `susi` |
| `value="#susi#"` | variable `susi` | variable `susi` |

When you migrate tag code to script, check unquoted attribute values: `value=1234` and `value=susi` will mean something different in script.

> **Note:** This describes the default. The Administrator's compiler settings have a "Tag attribute values" option ("Handle unquoted tag attribute values as strings"), which is enabled by default. If you disable it, unquoted tag attribute values are handled as variables instead. See [[lucee-5-unquoted-arguments]].

## Exceptions to the rules

Because some keywords already existed in script, before support for script tags was added to Lucee, this tags could not be added with migration syntax, because they would conflict with the existing keywords.

This includes the following keywords

- throw
- return
- abort

So for example this code

```html
<cfabort showError="Upsi Dupsi!">
<cfabort>
<cfthrow message="Upsi Dupsi!">
<cfreturn "Upsi Dupsi!">
```

translates to migration syntax like this (this are not tags)

```javascript
abort "Upsi Dupsi!";
abort;
throw "Upsi Dupsi!";
return "Upsi Dupsi!";
```

so you can for example not translate this

```html
<cfthrow message="Upsi Dupsi!" detail="Upsi dasy!">
```

to migration syntax, but you can to function syntax like this

```javascript
cfthrow (message="Upsi Dupsi!", detail="Upsi dasy!");
```

## Exceptions to Tag-to-Script Migration

Certain tags cannot be directly translated into migration syntax due to conflicts with existing keywords in Lucee’s script language. This applies to tags that use keywords already reserved in script, such as throw, return, and abort. These keywords function differently in script and don’t support direct migration syntax translation.

### Unsupported Migration Syntax for Specific Tags

For example, the following tags in tag syntax:

```html
<cfabort showError="Oops!">
<cfabort>
<cfthrow message="Oops!">
<cfreturn "Oops!">
```

translate to the following in script syntax (note: these are not actual tags in script but standalone statements):

```javascript
abort "Oops!";
abort;
throw "Oops!";
return "Oops!";
```

### Example of Syntax Limitation

Since the throw tag uses additional attributes like message and detail, it cannot be fully expressed in migration syntax. Instead, you’ll need to use function syntax for more complex cases. For example:

```html
<cfthrow message="Oops!" detail="More details here.">
```

would translate to function syntax as follows:

```javascript
cfthrow(message="Oops!", detail="More details here.");
```

Using function syntax here allows you to specify multiple attributes, overcoming the limitations of migration syntax. This flexibility makes function syntax ideal when using tags with additional parameters or complex functionality.
