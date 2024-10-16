
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
  ]
}
-->

# Import

The `<cfimport>` tag in Lucee has multiple purposes. It can be used to import components, Java classes (Lucee 6.2 and above), or custom tags using the `prefix` and `taglib` attributes.

## Import Components

To import a component, you can use the `path` attribute. This can be done in both tag syntax and script syntax.

### Tag Syntax

To import a component in tag syntax:

```cfml
<cfimport path="org.lucee.example.MyCFC">

<cfscript>
    // Create an instance of the imported component
    myInstance = new MyCFC();
</cfscript>
```

### Script Syntax

To import a component in script syntax, you have two options:

Using the `cfimport` function:

```cfml
<cfscript>
    cfimport(path="org.lucee.example.MyCFC");

    // Create an instance of the imported component
    myInstance = new MyCFC();
</cfscript>
```

Using the `import` keyword:

```cfml
<cfscript>
    import org.lucee.example.MyCFC;

    // Create an instance of the imported component
    myInstance = new MyCFC();
</cfscript>
```

You can also use quotes with the `import` keyword:

```cfml
<cfscript>
    import "org.lucee.example.MyCFC";

    // Create an instance of the imported component
    myInstance = new MyCFC();
</cfscript>
```

### Import Multiple Components

To import all components in a package, use the asterisk (`*`):

```cfml
<cfscript>
    import "org.lucee.example.*";

    // Create an instance of a component from the imported package
    myInstance = new MyCFC();
</cfscript>
```

## Import Java Classes (Lucee 6.2 and above)

Starting with Lucee 6.2, you can also use the `import` keyword to import Java classes. This functionality is only supported in script syntax, not tag syntax.

```cfml
import java.util.HashMap;
```

If there is a naming conflict between a CFML component and a Java class (i.e., both have the same name and package structure), the CFML component will take precedence. You can explicitly specify whether you're importing a Java class or a CFML component by using the type prefix:

```cfml
import java:java.util.HashMap;
import cfml:org.lucee.cfml.Query;
```

### Scope of Import

An import only affects the current template and not the entire request, meaning it applies only to the file where the import is declared.

## Import Custom Tags

You can also import CFML or JSP custom tags using the `prefix` and `taglib` attributes.

### Tag Syntax

To import custom tags in tag syntax:

```cfml
<cfimport prefix="my" taglib="/path/to/tags/">

<!-- Use a custom tag from the imported tag library -->
<my:customTag attribute="value">
```

### Script Syntax

To import custom tags in script syntax:

```cfml
<cfscript>
    cfimport(prefix="my", taglib="/path/to/tags/");
</cfscript>

<!-- Use a custom tag from the imported tag library -->
<my:customTag attribute="value">
```

Note that the `import` keyword cannot be used for custom tags—use `cfimport` instead.

## Supported Custom Tags

Lucee supports CFML-based custom tags written as CFML templates or components. You can also define a TLD (Tag Library Descriptor) file to integrate JSP tags.

## Conclusion

The `<cfimport>` tag and `import` keyword are versatile tools in Lucee for importing both components and Java classes (Lucee 6.2 and above), along with custom tags. These allow you to modularize and manage dependencies within your Lucee applications efficiently. By using the appropriate attributes and syntax, you can organize and extend your Lucee code seamlessly.
