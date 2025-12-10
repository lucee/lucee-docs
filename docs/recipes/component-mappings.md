<!--
{
  "title": "Component Mappings",
  "id": "mappings-component-mappings",
  "related": [
    "mappings-how-to-define-a-reg-mapping",
    "mappings-custom-tag-mappings",
    "tag-application",
    "function-expandpath"
  ],
  "categories": [
    "application",
    "components",
    "server"
  ],
  "description": "How to define and use component mappings in Lucee.",
  "keywords": [
    "Component Mapping",
    "Classpath",
    "CFCs",
    "Application.cfc",
    "Lucee archive"
  ]
}
-->

# Component Mappings

A mapping in Lucee is an alias that points to a directory - instead of using full filesystem paths, you use a short name. Lucee has three types: regular mappings (for templates/includes), custom tag mappings (for custom tags), and component mappings (for CFCs).

Component mappings define where Lucee looks for CFCs when using `createObject()` or `new`. This lets you organize and access components without specifying full paths - useful in larger applications with multiple component packages.

Mappings point to the root of package paths, not individual components. 

For example, if you have a mapping pointing to:

```
/path/to/lucee-server/context/components/
```

And a component at:

```
/path/to/lucee-server/context/components/org/lucee/extension/quartz/ComponentJob.cfc
```

You can reference it in your code using:

```coldfusion
// Using fully qualified path with the new operator
new org.lucee.extension.quartz.ComponentJob()

// Or using import and then the short name
import org.lucee.extension.quartz.ComponentJob;
new ComponentJob();
```

Like other mapping types in Lucee (regular mappings and custom tag mappings), component mappings consist of several parts:

* **physical**: Physical directory for the root of the mapping (packages start inside that directory)
* **archive**: A Lucee archive (.lar file) that contains the components; a .lar file is the same as a .jar file in Java, containing the compiled component (and optionally the source)
* **primary**: When both "physical" and "archive" are defined, this setting determines where to look first for a component; by default, it looks first in "physical"; possible values are "physical" and "archive"
* **readonly**: Determines if the mapping can be configured in the Lucee admin or not (not needed for mappings defined in Application.cfc)
* **hidden**: Controls visibility in the Lucee admin (not needed for mappings defined in Application.cfc)
* **inspectTemplate**: Controls Lucee's behavior when checking for changes

## Defining Component Mappings

### In the Lucee Administrator

Component mappings can be defined in the Lucee Server or Web Administrator. Go to the "Archives & Resources/Component" page.

Mappings defined in the Server Administrator are visible to all web contexts, while mappings defined in the Web Administrator are only visible to the current web context.

### Using CFConfig

Component mappings can be defined in a CFConfig JSON file:

```json
{
  "componentMappings": [
    {
      "physical": "{lucee-config}/components/",
      "archive": "",
      "primary": "physical",
      "inspectTemplate": "always"
    }
  ]
}
```

This is the default component mapping that Lucee always creates, but you can define as many mappings as needed.

### In Application.cfc

Component mappings can also be defined in the Application.cfc file, making them specific to the current application:

```cfs
// Application.cfc
component {
   this.componentPaths = [
      {
         "physical": "{lucee-config}/components/",
         "archive": "",
         "primary": "physical",
         "inspectTemplate": "always"
      }
   ];
}
```

## Using Component Mappings

Once you've defined your component mappings, you can create components without specifying the full path:

```coldfusion
// If you have a component mapping that includes a "models" directory
component = createObject("component", "models.User");

// Or using the new operator
component = new models.User();
```

## Advanced Usage

### Using Archives

You can package your components into a Lucee Archive (.lar) file and reference it in your component mapping:

```cfs
// Application.cfc
component {
   this.componentPaths = [
      {
         physical: getDirectoryFromPath(getCurrentTemplatePath()) & 'components',
         archive: getDirectoryFromPath(getCurrentTemplatePath()) & 'components.lar',
         primary: 'archive'
      }
   ];
}
```

With `primary` set to "archive", Lucee first checks the .lar file for components. If not found there, it looks in the physical path.

### InspectTemplate Options

The `inspectTemplate` attribute controls how Lucee checks for changes to your components:

* **never**: Never checks for changes (best for production)
* **once**: Checks once per request (default)
* **always**: Always checks for changes (best for development, can impact performance)

By default, mappings inherit the server-level `inspectTemplate` setting. You can override this per mapping if needed.

```cfs
// Application.cfc
component {
   this.componentPaths = [
      {
         physical: getDirectoryFromPath(getCurrentTemplatePath()) & 'components',
         inspectTemplate: 'once'
      }
   ];
}
```
