<!--
{
  "title": "Import",
  "id": "import",
  "description": "Guide on using import to import components and custom tags in Lucee",
  "keywords": [
    "cfimport",
    "import",
    "Lucee",
    "components",
    "custom tags",
    "taglib"
  ]
}
-->

# Import

The `<cfimport>` tag in Lucee has a dual purpose. It can be used to import components using the `path` attribute or CFML/JSP custom tags using the `prefix` and `taglib` attributes.

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

Using `cfimport` function:

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

### Scope of Import

An import only affects the current template and not the entire request.

## Import Custom Tags

You can also import CFML or Java custom tags using the `prefix` and `taglib` attributes.

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

For importing custom tags, the `import` keyword cannot be used.

## Supported Custom Tags

Lucee supports CFML-based custom tags written as CFML templates or as components. You can also define a TLD file that points to JSP tags.

## Conclusion

The `<cfimport>` tag is a versatile tool in Lucee for importing both components and custom tags, allowing for modular and organized code. By using the appropriate attributes and syntax, you can effectively manage dependencies and custom functionalities within your Lucee applications.
