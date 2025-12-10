<!--
{
  "title": "Script Templates (.cfs)",
  "id": "script-templates",
  "since": "6.0",
  "description": "Learn about script templates in Lucee. This guide explains how Lucee supports templates with the `.cfs` extension, allowing you to write direct script code without the need for the `<cfscript>` tag.",
  "keywords": [
    "CFML",
    "script",
    "templates",
    "Lucee",
    "cfs"
  ],
  "related": [
    "tag-script"
  ]
}
-->

# Script Templates

`.cfs` files contain pure script code without needing `<cfscript>` tags.

Traditional `.cfm` file:

```cfml
<cfscript>
	name = "Lucee";
	echo( "Hello #name#!" );
</cfscript>
```

Same code as `.cfs` file:

```cfs
name = "Lucee";
echo( "Hello #name#!" );
```
