<!--
{
  "title": "Sub Components",
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
    "tag-component"
  ]
}
-->

# Sub Components

Since Lucee 6.0, you can create sub components - additional components defined in a `.cfc` file after the main component. Before this, CFML required every component to be in a separate file.

This is useful when a component needs closely-related sub components, like an Address component with a Person sub component inside.

Add components after the main one with the `name` attribute:

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

Access sub components using `$` notation:

```lucee
cfc = new MyCFC();
echo("main->" & cfc.mainTest());
echo("<br>");
cfc = new MyCFC$Sub();
echo("sub->" & cfc.subTest());
echo("<br>");
```
