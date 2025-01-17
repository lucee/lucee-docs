<!--
{
  "title": "Sub Components (CFCs)",
  "id": "sub-component",
  "since": "6.0",
  "description": "Learn how to create and use sub components in Lucee. This guide demonstrates how to define additional components within a .cfc file, making it easier to organize related components. Examples include creating a main component with sub components, and how to address/load these sub components.",
  "categories": [
    "component"
  ],
  "keywords": [
    "CFML",
    "component",
    "sub-component",
    "Lucee"
  ],
  "related":[
    "inline-component",
    "tag-component",
  ]
}
-->

# Sub Components

Since Lucee 6.0, Lucee allows you to create Sub Components.

These are additional components created in a `.cfc` after the main component.

Before this was introduced, CFML was limited to requiring every component to be placed in a separate CFC file.

After the main component, simply add as many additional components as you like with the attribute "name" like this:

```lucee
component {
    function mainTest() {
        return "main";
    }
}
component name="Sub" {
    function subTest() {
        return "sub";
    }
}
```

This is useful when a component needs sub components, like an Address component could have a Person component inside.

Here is an example of how you can address/load these sub components:

```lucee
cfc = new MyCFC();
echo("main->" & cfc.mainTest());
echo("<br>");
cfc = new MyCFC$Sub();
echo("sub->" & cfc.subTest());
echo("<br>");
```
