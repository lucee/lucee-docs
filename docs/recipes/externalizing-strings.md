<!--
{
  "title": "Externalize strings",
  "id": "Externalizing_Strings",
  "description": "Externalize strings from generated class files to separate files. This method is used to reduce the memory of the static contents for templates.",
  "keywords": [
    "Externalize strings",
    "Memory reduction",
    "Class files",
    "Static contents",
    "Lucee"
  ],
  "categories": [
    "server"
  ]
}
-->

# Externalize Strings

When Lucee compiles a `.cfm` file, all the static HTML and strings get embedded directly in the Java class file. For pages with lots of static content (like email templates or HTML-heavy pages), this bloats the class files and wastes memory - those strings stay loaded even when not needed.

Externalizing strings moves this static content to separate text files. The class file shrinks, and strings only load on demand when the page actually runs.

```lucee
<!--- index.cfm - mostly static HTML with a bit of CFML --->
<cfset year = 1960>
<html>
    <body>
        <h1>....</h1>
        .......
        .......
        It was popular in the <cfoutput> #year# </cfoutput>
        .......
        <b>....</b>
    </body>
</html>
```

Without externalization, all that HTML lives in the class file. With it enabled, only the CFML logic stays in the class.

Configure via **Lucee Admin > Language/compiler > Externalize strings**:

- Strings are moved to separate text files
- Class file size decreases
- Strings load on demand instead of staying in memory

Video: [Externalize strings](https://youtu.be/AUcsHkVFXHE)
