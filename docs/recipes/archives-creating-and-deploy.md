<!--
{
  "title": "Lucee Archives (.lar files)",
  "id": "archives-creating-and-deploy",
  "related": [
    "mappings-how-to-define-a-reg-mapping",
    "mappings-component-mappings",
    "mappings-custom-tag-mappings",
    "tag-application"
  ],
  "categories": ["server", "devops", "application"],
  "description": "How to create, deploy and use Lucee Archives (.lar files) to distribute compiled CFML applications without exposing source code.",
  "keywords": ["Lucee", "Archives", ".lar files", "Deploy", "Mapping", "Component", "CFC", "CFM", "compiled", "source protection"]
}
-->

# Lucee Archives (.lar files)

A Lucee Archive (`.lar` file) is a packaged, compiled version of a CFML mapping. Think of it like a `.jar` file in Java — it bundles your compiled templates into a single file that can be deployed without the original CFML source code.

Archives work with all three mapping types:

- **Regular mappings** — templates, includes, pages
- **Component mappings** — CFCs and packages
- **Custom tag mappings** — custom tags

## Why use archives?

- **Protect source code** — distribute compiled CFML without exposing your `.cfm` / `.cfc` files
- **Simplify deployment** — ship a single `.lar` file instead of a directory tree
- **Improve startup performance** — templates are pre-compiled, no first-request compilation overhead
- **Version your deployments** — archive files are easy to swap, rollback or manage in CI/CD pipelines

## How archives work

Every mapping in Lucee can have two sources: a **physical** directory and an **archive** file. The `primary` setting controls which one Lucee checks first.

```coldfusion
<cfinclude template="/myApp/index.cfm">
```

When `primary` is set to `"archive"`, Lucee looks for `index.cfm` in the `.lar` file first. If it's not found there, it falls back to the physical directory. This lets you use an archive for production while keeping a physical path for development overrides.

## Creating an archive

### Via the Lucee Administrator

1. Go to **Archives & Resources** and select the mapping type (Mappings, Component, or Custom Tag)
2. Create or select an existing mapping with a physical path pointing to your source files
3. Click **assign archive to mapping**

Lucee compiles all CFML templates in the mapping and packages them into a `.lar` file, saved in `{lucee-config}/context/archives/`.

### Via cfadmin tag

You can script archive creation — useful for build scripts and CI/CD:

```cfs
// Step 1: Create a mapping to your source
admin
  action="updateMapping"
  type="web"
  password=adminPassword
  virtual="/myApp"
  physical="/path/to/source/"
  archive=""
  primary="physical"
  toplevel="true"
  trusted="no";

// Step 2: Create the archive
admin
  action="createArchive"
  type="web"
  password=adminPassword
  file="/path/to/output/myApp.lar"
  virtual="/myApp"
  addCFMLFiles="false"
  addNonCFMLFiles="true";
```

**Parameters:**

- `addCFMLFiles` — include the original `.cfm` / `.cfc` source in the archive (set to `false` to protect source code)
- `addNonCFMLFiles` — include static resources like CSS, JS, images (set to `true` if your mapping has any)

### Via the Lucee build system

Lucee itself uses archives — the admin interface is shipped as `lucee-admin.lar`. The build script at `ant/build-create-archive.xml` shows how this is done in the Lucee build process.

## Deploying an archive

### Drop-in deployment

Copy a `.lar` file to the server's deploy directory:

```
{lucee-server}/context/deploy/
```

Lucee automatically picks it up within 60 seconds, reads the mapping metadata from the archive's manifest, and creates the corresponding mapping.

### Manual deployment via Application.cfc

Point a mapping directly at the archive file:

```cfs
// Application.cfc
component {
  // Regular mapping with archive
  this.mappings["/myApp"] = {
    archive: getDirectoryFromPath( getCurrentTemplatePath() ) & "myApp.lar",
    primary: "archive"
  };

  // Component mapping with archive
  this.componentPaths = [
    {
      archive: getDirectoryFromPath( getCurrentTemplatePath() ) & "components.lar",
      primary: "archive"
    }
  ];

  // Custom tag mapping with archive
  this.customTagPaths = [
    {
      archive: getDirectoryFromPath( getCurrentTemplatePath() ) & "customtags.lar",
      primary: "archive"
    }
  ];
}
```

### Archive with physical fallback

A common pattern is to deploy an archive for compiled code but keep a physical path for templates that change frequently or need overriding:

```cfs
// Application.cfc
component {
  this.mappings["/myApp"] = {
    physical: getDirectoryFromPath( getCurrentTemplatePath() ) & "myApp",
    archive: getDirectoryFromPath( getCurrentTemplatePath() ) & "myApp.lar",
    primary: "archive"
  };
}
```

With `primary: "archive"`, Lucee uses the compiled archive by default but falls back to the physical directory for any templates not found in the archive.

### Deploying via cfadmin tag

```cfs
admin
  action="updateMapping"
  type="web"
  password=adminPassword
  virtual="/myApp"
  physical=""
  archive="/path/to/myApp.lar"
  primary="archive"
  toplevel="true"
  trusted="no";
```

## Archive contents

A `.lar` file is a standard ZIP/JAR file. You can inspect it with any ZIP tool or `jar tf myApp.lar`.

A typical archive contains:

- `META-INF/MANIFEST.MF` — mapping metadata (virtual path, mapping type, bundle headers)
- `*.class` — compiled CFML templates
- Static resources (CSS, JS, images, etc.) — if `addNonCFMLFiles` was `true`
- Original `.cfm` / `.cfc` source — only if `addCFMLFiles` was `true`

## Real-world example: the Lucee Admin

Lucee itself uses archives extensively. The admin interface (`lucee-admin.lar`) is a great example of how archives work in practice.

The admin is written in CFML — all the pages you see in the Lucee Administrator are `.cfm` templates. During the Lucee build, these are compiled into `lucee-admin.lar` with `addCFMLFiles="false"` (no source) and `addNonCFMLFiles="true"` (CSS, JS, images, language files are included). The source is stripped out purely for size reasons — the compiled archive is significantly smaller than the original source tree.

The `lucee-admin.lar` is bundled inside every Lucee jar (both the full and light versions), but the admin pages aren't accessible until the Admin extension is installed. All the extension does is create the mapping that exposes the archive — the compiled code is already there.

This is a useful pattern: you can bundle archives with your application and only activate them by creating mappings when needed.

## Practical example: deploy a component library

Here's a complete workflow — build a component library into an archive and deploy it to another server.

**On the development server:**

```cfs
// build-archive.cfm
admin
  action="updateComponentMapping"
  type="web"
  password="admin"
  virtual="/mylib"
  physical=expandPath( "/src/mylib/" )
  archive=""
  primary="physical";

admin
  action="createArchive"
  type="web"
  password="admin"
  file=expandPath( "/dist/mylib.lar" )
  virtual="/mylib"
  addCFMLFiles="false"
  addNonCFMLFiles="false";
```

**On the production server** (Application.cfc):

```cfs
component {
  this.componentPaths = [
    {
      archive: getDirectoryFromPath( getCurrentTemplatePath() ) & "lib/mylib.lar",
      primary: "archive"
    }
  ];
}
```

Now your production server can use `new mylib.SomeComponent()` without having any CFML source on disk.

## Footnotes

Here you can see the above details in a video:

[Lucee Deploy Archive file](https://www.youtube.com/watch?time_continue=473&v=E9Z0KvspBAY)
