<!--
{
  "title": "Custom Tag Mappings",
  "id": "mappings-custom-tag-mappings",
  "related": [
    "mappings-component-mappings",
    "mappings-how-to-define-a-reg-mapping",
    "tag-application",
    "tag-import",
    "import"
  ],
  "categories": [
    "application",
    "tags",
    "server"
  ],
  "description": "How to define and use custom tag mappings in Lucee.",
  "keywords": [
    "Custom Tag Mapping",
    "Custom Tags",
    "cfimport",
    "Application.cfc",
    "Lucee archive",
    "taglib"
  ]
}
-->

# Custom Tag Mappings

Custom tags are reusable CFML templates (`.cfm` files) that you can call like built-in tags. Custom tag mappings tell Lucee where to find these files, so you don't have to specify full paths or use [[tag-import]] repeatedly.

For example, if you have a custom tag file at:

```
/path/to/your/app/customtags/myTag.cfm
```

With a custom tag mapping pointing to `/path/to/your/app/customtags/`, you can use the tag in your code like:

```coldfusion
<cf_myTag attribute="value">
```

Like other mapping types in Lucee (regular mappings and component mappings), custom tag mappings consist of several parts:

- **physical**: Physical directory where custom tag files are stored
- **archive**: A Lucee archive (.lar file) that contains the custom tags; a .lar file is the same as a .jar file in Java, containing the compiled templates (and optionally the source)
- **primary**: When both "physical" and "archive" are defined, this setting determines where to look first for a custom tag; by default, it looks first in "physical"; possible values are "physical" and "archive"
- **readonly**: Determines if the mapping can be configured in the Lucee admin or not (not needed for mappings defined in Application.cfc)
- **hidden**: Controls visibility in the Lucee admin (not needed for mappings defined in Application.cfc)
- **inspectTemplate**: Controls Lucee's behavior when checking for changes

## Defining Custom Tag Mappings

### In the Lucee Administrator

Custom tag mappings can be defined in the Lucee Server or Web Administrator. Go to the **Archives & Resources / Custom Tag** page.

Mappings defined in the Server Administrator are visible to all web contexts, while mappings defined in the Web Administrator are only visible to the current web context.

The default mapping for custom tags is under `{lucee-config}/customtags/`, where the `{lucee-config}` is a [[configuration-directory-placeholders]] which resolves to your `lucee-server\context` directory.

```cfml
dump( expandPath( "{lucee-config}" ) );
```

### Using CFConfig

Custom tag mappings can be defined in a CFConfig JSON file:

```json
{
  "customTagMappings": [
    {
      "physical": "/path/to/customtags/",
      "archive": "",
      "primary": "physical",
      "inspectTemplate": "always"
    }
  ]
}
```

Remember, the Lucee Admin is a GUI for `.CFConfig.json`.

### In Application.cfc

Custom tag mappings can also be defined in the `Application.cfc` file, making them specific to the current application:

```cfs
// Application.cfc
component {
   this.customTagPaths = [
      getDirectoryFromPath( getCurrentTemplatePath() ) & "customtags"
   ];
}
```

**Important**: Unlike `this.mappings` (which uses structs), `this.customTagPaths` takes an **array** because there is no "virtual path" that needs to be defined. Custom tags are found by filename in any of the mapped directories.

## Using Custom Tags

Once you've defined your custom tag mappings, you can use custom tags in your code:

```cfml
<!-- Using the cf_ prefix notation -->
<cf_myCustomTag attribute="value">

<!-- Or with closing tag -->
<cf_myCustomTag attribute="value">
   Some content here
</cf_myCustomTag>
```

Custom tags can also be invoked using `cfmodule`:

```cfml
<cfmodule template="myCustomTag.cfm" attribute="value">
```

## Using cfimport for Prefixed Custom Tags

Instead of using the `cf_` prefix, you can import custom tags with a custom prefix using `cfimport`:

```cfml
<cfimport prefix="my" taglib="/customtags/">

<!-- Then use with your custom prefix -->
<my:customTag attribute="value">
```

Or in script syntax:

```cfml
cfimport( prefix="my", taglib="/customtags/" );
```

**Note**: The `import` keyword cannot be used for custom tags—only `cfimport` supports the `prefix` and `taglib` attributes.

The `cfimport` approach is useful when:

- You want to use a more descriptive prefix than `cf_`
- You have custom tags from different sources and want to namespace them
- You want to make it clear where a custom tag comes from in your code

## Advanced Usage

### Using Archives

You can package your custom tags into a Lucee Archive (.lar) file and reference it in your custom tag mapping:

```cfs
// Application.cfc
component {
   this.customTagPaths = [
      {
         physical: getDirectoryFromPath( getCurrentTemplatePath() ) & 'customtags',
         archive: getDirectoryFromPath( getCurrentTemplatePath() ) & 'customtags.lar',
         primary: 'archive'
      }
   ];
}
```

With `primary` set to "archive", Lucee first checks the .lar file for custom tags. If not found there, it looks in the physical path.

This is particularly useful for:

- Deploying compiled custom tags
- Protecting source code
- Improving performance by reducing file system checks

### InspectTemplate Options

The `inspectTemplate` attribute controls how Lucee checks for changes to your custom tags:

- **auto**: Monitors the filesystem for changes (default)
- **never**: Never checks for changes (best for production)
- **once**: Checks filesystem once per request
- **always**: Slow, checks the filesystem everytime the templates are accessed.

By default, mappings inherit the server-level `inspectTemplate` setting. You can override this per mapping if needed.

```cfs
// Application.cfc
component {
   this.customTagPaths = [
      {
         physical: getDirectoryFromPath( getCurrentTemplatePath() ) & 'customtags',
         inspectTemplate: 'never'
      }
   ];
}
```

### Multiple Custom Tag Paths

You can define multiple custom tag paths, and Lucee will search them in order:

```cfs
// Application.cfc
component {
   this.customTagPaths = [
      getDirectoryFromPath( getCurrentTemplatePath() ) & "customtags",
      expandPath( "/shared/customtags" ),
      getDirectoryFromPath( getCurrentTemplatePath() ) & "vendor/tags"
   ];
}
```

When you use a custom tag, Lucee will search each path in order until it finds the matching custom tag file.

## Creating Custom Tags

Custom tags are simply CFML templates that can access special variables:

- `attributes` scope: Contains all attributes passed to the custom tag
- `caller` scope: Allows the custom tag to read and write variables in the calling template
- `thisTag` scope: Contains metadata about the custom tag execution

Example custom tag (`customtags/greeting.cfm`):

```coldfusion
<cfparam name="attributes.name" default="World">

<cfoutput>
   Hello, #attributes.name#!
</cfoutput>
```

Usage:

```coldfusion
<cf_greeting name="Lucee">
<!-- Outputs: Hello, Lucee! -->
```

## Best Practices

1. **Use Application.cfc for application-specific tags**: Define custom tag paths in Application.cfc to keep them version-controlled and portable with your application.

2. **Set inspectTemplate appropriately**: Use **auto** or **once** during development, but **never** in production for better performance.

3. **Organize tags by purpose**: Consider organizing custom tags into subdirectories by functionality (e.g., `customtags/forms/`, `customtags/layout/`).

4. **Use cfimport for clarity**: When working with multiple tag libraries, use `cfimport` with descriptive prefixes to make your code more readable.

## Differences from Component and Regular Mappings

| Feature | Regular Mappings | Component Mappings | Custom Tag Mappings |
|---------|------------------|-------------------|-------------------|
| Application.cfc Property | `this.mappings` | `this.componentPaths` | `this.customTagPaths` |
| Data Structure | Struct (with virtual paths) | Array | Array |
| Usage | `cfinclude`, `cffile`, etc. | `new`, `createObject()` | `cf_tagname`, `cfimport` |
| Requires Virtual Path | Yes | No | No |
