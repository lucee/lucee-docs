<!--
{
  "title": "Deploying Custom Tags via Extensions",
  "id": "custom-tags-via-extensions",
  "related": [
    "mappings-custom-tag-mappings",
    "tag-import",
    "extensions"
  ],
  "categories": [
    "tags",
    "server",
    "extensions"
  ],
  "description": "How to bundle and deploy custom tags as part of a Lucee extension (.lex file), and how to import them using cfimport.",
  "keywords": [
    "Custom Tags",
    "Extensions",
    "LEX",
    "cfimport",
    "taglib",
    "prefix",
    "lucee-server context"
  ]
}
-->

# Deploying Custom Tags via Extensions

Lucee extensions (`.lex` files) can ship custom tags by copying files directly into the Lucee server context. This allows an extension to provide reusable tags — in classic `.cfm` or component-based `.cfc` format — that are immediately available to all applications on the server after the extension is installed.

## How Extensions Copy Files into the Context

A `.lex` file is a ZIP archive. Any files placed in a `context/` folder inside the extension are automatically copied to the corresponding location under `/lucee-server/context/` when the extension is installed.

For example, if your extension contains:

```
context/
  whatever/
    MyTag.cfm
    AnotherTag.cfc
```

After installation, those files will be available at:

```
/lucee-server/context/whatever/MyTag.cfm
/lucee-server/context/whatever/AnotherTag.cfc
```

A real-world example of this pattern is the [YAML extension](https://github.com/lucee/yaml-extension), which copies a single `.cfc` file into `context/components/org/lucee/cfml/tools/`, making it importable as a component.

## The `/lucee-server` Mapping

Lucee provides a built-in mapping `/lucee-server` that points to the `/lucee-server/context/` directory. This means files copied there by an extension are immediately reachable via this virtual path — no additional mapping configuration is needed.

> **Note**: Since Lucee 7 only supports Single Mode, `/lucee-server` is the recommended mapping to use. In earlier versions of Lucee 6 running in Multi Mode, `/lucee` pointed to the web context (`WEB-INF/lucee`), which was a different location. With Multi Mode removed in Lucee 7, prefer `/lucee-server` for clarity and forward compatibility.

## Using cfimport with Extension-Provided Tags

Once an extension copies tag files into a subfolder of the server context, you can import them using `cfimport` with a custom prefix:

```cfml
<cfimport prefix="elvis" taglib="/lucee-server/whatever/">

<elvis:myTag />
<elvis:anotherTag />
```

Or in script syntax:

```cfml
cfimport( prefix="elvis", taglib="/lucee-server/whatever/" );
```

**Important**: Tag files must be placed directly in the target folder — subdirectories within the `taglib` path are not searched. If your extension puts tags in `context/whatever/`, the `taglib` must point to `/lucee-server/whatever/` exactly, and all tags must be at that level with no further nesting.

> **Note**: The `import` keyword cannot be used for custom tags — only `cfimport` supports the `prefix` and `taglib` attributes for this purpose.

## Supported Tag Formats

Both classic and component-based custom tags are supported:

- **`.cfm` files**: Classic custom tag format, callable via `cf_tagname` or `cfimport`
- **`.cfc` files**: Component-based custom tags, also callable via `cf_tagname` or `cfimport`

## Deployment Locations and Their Prefixes

Depending on where inside `context/` you place your tags, they become available in different ways:

| Extension path | Installed at | How to use |
|---|---|---|
| `context/library/tag/` | `/lucee-server/context/library/tag/` | `<cftagname>` (built-in tag style — can even override Lucee's own tags like `<cflog>`) |
| `context/customtags/` | `/lucee-server/context/customtags/` | `<cf_tagname>` (custom tag style) |
| `context/whatever/` | `/lucee-server/context/whatever/` | `<cfimport prefix="myprefix" taglib="/lucee-server/whatever/">` |

Using a dedicated folder (like `context/whatever/`) and importing it with `cfimport` is the recommended approach when you want your extension to provide a clearly namespaced tag library.

## Example: Extension Structure

```
my-extension.lex (ZIP)
├── META-INF/
│   └── MANIFEST.MF
└── context/
    └── mytags/
        ├── Button.cfm
        ├── Form.cfm
        └── Input.cfc
```

After installation, in your CFML code:

```cfml
<cfimport prefix="ui" taglib="/lucee-server/mytags/">

<ui:Form action="submit.cfm">
    <ui:Input name="email" />
    <ui:Button label="Submit" />
</ui:Form>
```

## Related Documentation

- **[Custom Tag Mappings](mappings-custom-tag-mappings.md)** — Defining custom tag paths in Application.cfc and the Lucee Administrator
- **[tag-import](tag-import.md)** — `cfimport` tag reference
- **[Extensions](extensions.md)** — How to build and install Lucee extensions
- **[Single Mode vs Multi Mode](single-vs-multi-mode.md)** — Understanding the `/lucee-server` vs `/lucee` mappings