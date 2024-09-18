
<!--
{
  "title": "Tag Syntax",
  "id": "tag-syntax",
  "categories": [
    "scopes",
    "thread"
  ],
  "description": "How to use tags in script",
  "keywords": [
    "Syntax",
    "tag",
    "function",
    "Script"
  ]
}
-->

# How to Use Tags in Script

Lucee is a versatile platform that supports two programming languages: a tag-based language that integrates seamlessly into HTML and a script-based language. 
Lucee (or CFML in general) initially started as a purely tag-based language, but over time, support for scripting has grown. 
More and more functionality from the tag environment has been brought into the script environment, including support for using tags directly in script syntax. 
This guide explains how you can use tags in scripts or migrate tag.

## History of Tags in Script

Lucee supports two different tag syntaxes within scripts. The reason for this is rooted in a decision made by the "CFML Advisory Committee," which included members from Railo (now Lucee), Adobe, and BlueDragon. 
The committee agreed on one syntax for tag use in scripts, but later Adobe chose to implement a different syntax. Since Lucee had already implemented the committee's original syntax, 
it now supports both: the "Function Syntax" and the "Migration Syntax."

### Function Syntax and Migration Syntax

#### Function Syntax

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

One of the key differences between tag-based code and script-based code in Lucee is how variables are interpreted. For example, in tag-based code:

```html
<cfset max=10>
<cfloop from="1" to=max index="i">
    ...
</cfloop>
```

The variable `max` will be interpreted as the string `"max"`, which can lead to an error like "string [max] cannot be converted to a number."

In contrast, when the same code is written in script (either migration or function syntax), the variable `max` is correctly interpreted as a variable, not a string:

```javascript
max = 10;
loop from="1" to=max index="i" {
    ...
}
```

In this case, the `max` variable is evaluated properly, and the code runs without errors.
