<!--
{
  "title": "Inline Components",
  "id": "inline-component",
  "since": "6.0",
  "description": "Learn how to create and use inline components in Lucee. This guide demonstrates how to define components directly within your CFML code, making it easier to create and use components without needing a separate .cfc file. Examples include creating an inline component and using it similarly to closures.",
  "keywords": [
    "CFML",
    "component",
    "inline-component",
    "Lucee"
  ],
  "categories": [
    "component"
  ],
  "related":[
    "sub-component",
    "tag-component"
  ]
}
-->

# Inline Components

Inline components let you define a component directly in your code without a separate `.cfc` file. Think of them like closures, but with full component capabilities - properties, methods, inheritance. Useful for quick one-off objects, callbacks, or when a full CFC feels like overkill.

```run
<cfscript>
inline = new component {
    function subTest() {
        return "inline<br>";
    }
};
dump("inline->" & inline.subTest());
dump(inline);
</cfscript>
```
