<!--
{
  "title": "Loading Java Libraries with Maven",
  "id": "maven",
  "categories": [
    "java"
  ],
  "since": "6.2",
  "description": "Load Java libraries from Maven repositories - automatic dependency management for CFML applications.",
  "keywords": [
    "Maven",
    "Java",
    "javaSettings",
    "dependencies"
  ],
  "related": [
    "function-createobject",
    "tag-import",
    "java-settings"
  ]
}
-->

# Loading Java Libraries with Maven

You want to use Apache POI to read Excel files. In the old days, you'd download the JAR, figure out its dependencies, put them all somewhere, and configure Lucee to find them. Maven handles this automatically - specify what you need and Lucee fetches everything.

**Maven terms:** Libraries are identified by *groupId* (organization), *artifactId* (library name), and *version*. These combine into coordinates like `org.apache.poi:poi-ooxml:5.2.5`.

> **Common gotcha:** Using `import org.apache.poi...` alone doesn't load POI - it just shortcuts the class name. Without `javaSettings`, Lucee uses whatever's already on the classpath (often its bundled libraries). To load a specific version, you need both: `javaSettings` to fetch the library, `import` for convenience.

## Quick Start

```cfml
component javaSettings='{"maven":["org.apache.poi:poi-ooxml:5.2.5"]}' {
	import org.apache.poi.xssf.usermodel.XSSFWorkbook;
	import java.io.FileInputStream;

	function readFirstCell( path ) {
		var workbook = new XSSFWorkbook( new FileInputStream( arguments.path ) );
		var sheet = workbook.getSheetAt( 0 );
		return sheet.getRow( 0 ).getCell( 0 ).getStringCellValue();
	}
}
```

Lucee downloads POI and all its dependencies automatically.

## Where to Define Dependencies

| Scope | Use Case |
|-------|----------|
| **Component attribute** | Isolate dependencies to a single component |
| **Application.cfc** | Share across your application |
| **`.CFConfig.json`** | Server-wide defaults |
| **createObject()** | One-off dynamic loading |

### Component (recommended for isolation)

Each component can have its own dependencies - different components can even use different versions of the same library without conflicts:

```cfml
component javaSettings='{"maven":["org.apache.poi:poi-ooxml:5.2.5"]}' {
	// POI 5.2.5 available here
}
```

### Application.cfc

Share dependencies across your entire application:

```cfml
// Application.cfc
this.javaSettings = {
	"maven": [
		"org.apache.poi:poi-ooxml:5.2.5",
		"com.google.guava:guava:32.1.3-jre"
	]
};
```

### .CFConfig.json (server-wide)

```json
{
	"javaSettings": {
		"maven": [
			"org.quartz-scheduler:quartz:2.3.2",
			"org.quartz-scheduler:quartz-jobs:2.3.2"
		]
	}
}
```

### createObject() (dynamic)

Load dependencies at runtime for one-off usage:

```cfml
BeanUtils = createObject( "java", "org.apache.commons.beanutils.BeanUtils", {
	"maven": [ "commons-beanutils:commons-beanutils:1.9.4" ]
});
```

## Dependency Syntax

### Shorthand (recommended)

```
"groupId:artifactId:version"
```

Examples:

```cfml
"org.apache.poi:poi-ooxml:5.2.5"
"com.google.guava:guava:32.1.3-jre"
```

### Verbose (when you need more control)

```json
{
	"groupId": "org.apache.poi",
	"artifactId": "poi-ooxml",
	"version": "5.2.5"
}
```

### Version is Optional

Omit version to fetch the latest available:

```cfml
"org.apache.poi:poi-ooxml"  // gets latest version
```

## Security: Checksum Validation

Lucee validates downloads against Maven repository checksums. For extra security, specify your own.

Full shorthand syntax: `groupId:artifactId:version:scope:transitive:checksum`

```cfml
// With checksum (scope=compile, transitive=false)
"commons-beanutils:commons-beanutils:1.9.4:compile:false:sha1-d52b9abcd97f38c81342bb7e7ae1eee9b73cba51"

// Verbose
{
	"groupId": "commons-beanutils",
	"artifactId": "commons-beanutils",
	"version": "1.9.4",
	"checksum": "sha1-d52b9abcd97f38c81342bb7e7ae1eee9b73cba51"
}
```

Supported algorithms: MD5, SHA-1, SHA-256, SHA-512. Failed validation prevents installation.

## Finding Maven Coordinates

Search [Maven Central](https://search.maven.org/) for the library you need. The coordinates are shown on the artifact page - just copy them.

## Classloader Reuse

Lucee hashes your javaSettings and reuses classloaders with matching configurations. This means:

- Multiple components with identical dependencies share one classloader
- No overhead from creating duplicate classloaders
- Memory stays efficient even with many components using Maven

## Limitations

- **Runtime download** - Libraries are fetched when first needed. For Docker, pre-download in `Server.cfc->onBuild`
- **CFML only** - Can't use this in Java-based Lucee extensions (yet)
