<!--
{
  "title": "File Extensions",
  "id": "file-extensions",
  "description": "Learn about the different file extensions supported by Lucee, including .cfm, .cfc, .cfml, and .cfs. This guide provides examples for each type of file.",
  "keywords": [
    "CFML",
    "cfm",
    "cfc",
    "cfml",
    "cfs",
    "file extensions"
  ],
  "categories": [
    "server"
  ]
}
-->

# File Extensions

Lucee processes several file types, each serving a different purpose in CFML development. Knowing when to use each helps keep your code organized.

## .cfm

The standard CFML template extension. These files mix CFML tags and HTML to generate dynamic web pages - the workhorse of most CFML applications.

### Example

```cfm
<!DOCTYPE html>
<html>
<head>
    <title>CFM Example</title>
</head>
<body>
    <cfset greeting = "Hello, World!">
    <cfoutput>
        <p>#greeting#</p>
    </cfoutput>
</body>
</html>
```

## .cfc

CFML Components define reusable objects that encapsulate data and behavior - similar to classes in other languages. Use these for your business logic, models, and services.

### Example

```cfc
component {
    public string function greet(string name) {
        return "Hello, " & name & "!";
    }
}
```

## .cfml

Alternative extension for CFML templates - functionally identical to `.cfm`. Some developers prefer the explicit `.cfml` extension, but `.cfm` is far more common.

## .cfs

Script-only templates introduced in Lucee 6.0. Like `.js` files in the JavaScript world, these contain pure script code without needing `<cfscript>` tags. Great for scripts, utilities, and developers who prefer script syntax over tags.

### Example

```cfs
writeOutput("Hello from a .cfs file!");
```
