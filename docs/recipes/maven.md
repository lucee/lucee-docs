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
    "java-settings",
    "java-libraries",
    "java-class-interaction",
    "maven-based-extensions"
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
| **Deploy folder** | Server-wide, install the dependencies of a `pom.xml` |
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

### Deploy folder (server-wide)

Like an extension (`.lex`), a `pom.xml` or `*.pom` file dropped into the `deploy` folder of the Lucee server installs the dependencies it declares:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.example</groupId>
	<artifactId>app</artifactId>
	<version>1.0.0</version>
	<dependencies>
		<dependency>
			<groupId>org.quartz-scheduler</groupId>
			<artifactId>quartz</artifactId>
			<version>2.3.2</version>
		</dependency>
	</dependencies>
</project>
```

Lucee downloads the dependencies including their transitive dependencies and, once all of them are downloaded, adds them to the server-wide `javaSettings` `maven` setting of the server configuration, so they are available to all applications, as if you had defined them in `.CFConfig.json`. Nothing is added if one of the dependencies can not be downloaded.

The pom is then moved to the `deployed-poms` folder of the server configuration directory. If the pom can not be installed (invalid XML, a dependency without a version, an unresolved `${placeholder}`, an artifact that can not be downloaded) the error is written to the `deploy` log and the pom is moved to the `failed-to-deploy` folder inside the deploy folder.

How the pom is read:

- Versions can be given directly, with `${property}` placeholders (including `${project.version}`) or by `dependencyManagement`.
- Only dependencies needed at runtime are installed. Dependencies with the scope `test`, `provided`, `system` or `import`, optional dependencies and dependencies that are not a jar (`<type>`) are skipped.
- The parent pom and the `<repositories>` of the deployed pom are ignored, Lucee uses its own Maven configuration. Properties and versions that are only defined in a parent pom are not available.
- If the server already has the same dependency with a different version, the higher version is kept.

The deploy folder is checked at startup and periodically while Lucee is running, exactly as for extensions, see [[extension-installation]].

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

## Cache Inspection and Snapshots

> **Since 7.1.0.98** ([LDEV-6280](https://luceeserver.atlassian.net/browse/LDEV-6280)) — three BIFs for working with the on-disk `/mvn/` cache.

Lucee stores downloaded jars under `{lucee-server}/../mvn/` in standard Maven repository layout (`{group}/{artifact}/{version}/{artifact}-{version}.jar`). Three functions let you query and move that cache around:

### [[function-mavenexists]]

Cheap local-cache predicate — a `File.isFile()` check, no network, no transitive resolution. Use it to guard a `mavenLoad` when you want to avoid even the resolver walk:

```cfml
if ( !mavenExists( "org.apache.poi:poi-ooxml:5.2.5" ) ) {
    mavenLoad( "org.apache.poi:poi-ooxml:5.2.5" );
}
```

Version can be omitted to check "is *any* version of this coord cached":

```cfml
if ( mavenExists( "org.apache.poi", "poi-ooxml" ) ) {
    // at least one version is on disk
}
```

Don't reach for [[function-maveninfo]] as a predicate — it walks the full dependency tree and may hit the network. `mavenExists` is the filesystem-only variant.

### [[function-mavenexport]]

Walks `/mvn/` and writes a `pom.xml` listing every cached jar. Useful for snapshotting an environment's cache for reproducible deploys or audit:

```cfml
mavenExport( "/app/mvn-cache.xml" );
```

The emitted pom uses a synthetic `<groupId>com.example.lucee</groupId>` with `<packaging>pom</packaging>` so maven tooling treats it as a manifest, not a compilable artifact. Classifiers (e.g. platform-specific natives) are detected from filenames and preserved. Scope is intentionally omitted — the on-disk cache doesn't track it.

### [[function-mavenimport]]

Rehydrates a `/mvn/` cache from a `pom.xml` — the inverse of `mavenExport`:

```cfml
q = mavenImport( "/app/mvn-cache.xml" );
// q is a query of resolved deps (groupId, artifactId, version, path, url, ...)
```

Defaults to **literal** resolution (only the coords listed in the pom) so `mavenExport` → `mavenImport` round-trips exactly. Pass `includeTransitive=true` to walk the full tree per entry, same as [[function-mavenload]].

### Optional dependencies

Like Maven itself, Lucee skips optional dependencies of dependencies when resolving a tree. That is the default for [[function-mavenload]] and for [[function-mavenimport]] with `includeTransitive=true` (since [LDEV-6639](https://luceeserver.atlassian.net/browse/LDEV-6639) / [lucee/Lucee#3193](https://github.com/lucee/Lucee/pull/3193)).

Pass `includeOptional=true` to load optional dependencies at every level as well:

```cfml
mavenLoad( "org.apache.httpcomponents:httpclient:4.5.13", includeOptional=true );
mavenImport( "/app/mvn-cache.xml", includeTransitive=true, includeOptional=true );
```

Optional dependencies declared **directly** in an imported pom are always resolved. [[function-maveninfo]] still defaults `includeOptional` to `true` so you can inspect the full tree.

### Round-trip workflow

```cfml
// Dev machine: snapshot a known-good cache after loading everything
mavenLoad( "org.apache.poi:poi-ooxml:5.2.5" );
mavenLoad( "com.google.guava:guava:32.1.3-jre" );
mavenExport( "/app/mvn-cache.xml" );
// commit mvn-cache.xml

// Fresh install / Docker build: rehydrate
mavenImport( "/app/mvn-cache.xml" );
```

See the [[onbuild-function]] recipe for using this in Docker builds.

## Limitations

- **Runtime download** — libraries are fetched when first needed. For Docker, warm the cache at build time: the literal `javasettings` attribute of a component is resolved when the component is compiled during [[warmup]], other definitions can be loaded via `Server.cfc->onBuild` using `mavenImport` or guarded `mavenLoad` calls — see [[onbuild-function]].
- **CFML only** — can't use this in Java-based Lucee extensions (yet).
