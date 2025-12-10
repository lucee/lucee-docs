<!--
{
  "title": "Import",
  "id": "import",
  "description": "Guide on using import to import components, Java classes, and custom tags in Lucee",
  "keywords": [
    "cfimport",
    "import",
    "Lucee",
    "components",
    "java classes",
    "custom tags",
    "taglib"
  ],
  "categories": [
    "java"
  ],
  "related":[
    "function-createobject",
    "tag-import",
    "developing-with-lucee-server"
  ]
}
-->

# Import

Import components, Java classes (6.2+), or custom tags.

## Components

### Tag Syntax

```cfml
<cfimport path="org.lucee.example.MyCFC">

<cfscript>
    // Create an instance of the imported component
    myInstance = new MyCFC();
</cfscript>
```

### Script Syntax

Using the `import` keyword:

```cfml
<cfscript>
    import org.lucee.example.MyCFC;

    // Create an instance of the imported component
    myInstance = new MyCFC();
</cfscript>
```

Quotes also work:

```cfml
<cfscript>
    import "org.lucee.example.MyCFC";
</cfscript>
```

Or the `cfimport` function:

```cfml
<cfscript>
    cfimport( path="org.lucee.example.MyCFC" );
    myInstance = new MyCFC();
</cfscript>
```

### Wildcard Import

```cfml
<cfscript>
    import "org.lucee.example.*";

    // Create an instance of a component from the imported package
    myInstance = new MyCFC();
</cfscript>
```

## Java Classes (6.2+)

```cfml
import java.util.HashMap;
```

To resolve naming conflicts with CFML components:

```cfml
import java:java.util.HashMap;
import cfml:org.lucee.cfml.Query;
```

Imports only affect the current template.

## Custom Tags

```cfml
<cfimport prefix="my" taglib="/path/to/tags/">

<!-- Use a custom tag from the imported tag library -->
<my:customTag attribute="value">
```

Script: `cfimport(prefix="my", taglib="/path/to/tags/")` (the `import` keyword doesn't work for custom tags).
