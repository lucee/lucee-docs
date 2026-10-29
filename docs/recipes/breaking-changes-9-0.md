<!--
{
  "title": "Breaking Changes between Lucee 8.0 and 9.0",
  "id": "breaking-changes-8-0-to-9-0",
  "categories": ["breaking changes", "migration","compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 8.0 and 9.0",
  "keywords": ["breaking changes", "Lucee 8.0", "Lucee 9.0", "migration", "upgrade", "OSGi", "Felix", "ASM", "HttpClient", "javax.mail", "commons-logging", "extensions", "isJson", "JSON"],
  "related": [
    "breaking-changes-7-1-to-8-0"
  ]
}
-->

# Breaking Changes between Lucee 8.0 and 9.0

This document outlines the breaking changes introduced when upgrading from Lucee 8.0 to Lucee 9.0. Lucee 9.0 is under development (alpha), this page is extended with every change that can break existing code, extensions or configurations.

## Other Breaking Changes in Lucee Releases

- [[breaking-changes-5-4-to-6-0]]
- [[breaking-changes-6-0-to-6-1]]
- [[breaking-changes-6-1-to-6-2]]
- [[breaking-changes-6-2-to-7-0]]
- [[breaking-changes-7-0-to-7-1]]
- [[breaking-changes-7-1-to-8-0]]

## Apache Felix is shaded into the Lucee jar

The OSGi framework that Lucee uses (Apache Felix) is no longer merged into the Lucee jar as it is. It is **shaded**: the classes are copied into the jar and their package is relocated from `org.apache.felix` to `lucee.shaded.felix`. This is the first step to a single jar with shaded libraries, OSGi itself will move to an extension later (and is deprecated).

OSGi stays fully supported for extensions and bundles, the OSGi API (`org.osgi.*`) is **not** relocated, bundles and extensions import it from the framework as before. What changes are the names and types of the framework implementation.

### The `org.apache.felix` packages do not exist anymore

Classes in `org.apache.felix.*` are not available to the core, to extensions and to bundles. This includes the `org.apache.felix` exports of the system bundle and the boot delegation to them.

Code that imports or casts to a Felix class fails with a `NoClassDefFoundError`, for example:

```
java.lang.NoClassDefFoundError: org/apache/felix/framework/BundleWiringImpl$BundleClassLoader
```

The most common case is a cast of a class loader to Felix's `BundleClassLoader` to get the bundle of a class. Use the OSGi API instead, `org.osgi.framework.BundleReference` works with every Lucee version, with every OSGi framework:

Before:

```java
import org.apache.felix.framework.BundleWiringImpl.BundleClassLoader;

BundleClassLoader bcl = (BundleClassLoader) MyClass.class.getClassLoader();
Bundle bundle = bcl.getBundle();
```

After:

```java
import org.osgi.framework.Bundle;
import org.osgi.framework.BundleReference;

ClassLoader cl = MyClass.class.getClassLoader();
Bundle bundle = ((BundleReference) cl).getBundle();
// or, to get the class loader of a bundle
// BundleWiring wiring = bundle.adapt(BundleWiring.class);
```

The same applies to the other Felix classes (`org.apache.felix.framework.Logger`, `org.apache.felix.framework.Felix`, ...), use the `org.osgi.*` API (`org.osgi.framework.launch.Framework` for the framework itself) or your own logger.

An extension that has to run on Lucee 8 and 9 can use `BundleReference` in both, it is available in every Lucee version.

### The symbolic name of the system bundle changed

The system bundle (the framework itself, bundle id `0`) had the symbolic name `org.apache.felix.framework`, it is now `lucee.shaded.felix.framework`. This is visible in `BundleInfo()`, in the bundle listings of the Administrator and in `Bundle.getSymbolicName()`.

- Do not compare the symbolic name to detect the system bundle, check the bundle id: `bundle.getBundleId() == 0`.
- A manifest with `Require-Bundle: org.apache.felix.framework` does not resolve anymore. Require the packages you need (`Import-Package`) instead, which is what you should do in any case.

### Loader API: `getFelix` and `BundleCollection` use `Framework`

The public classes of the loader do not expose Felix types anymore:

| Class | Before | Now |
| --- | --- | --- |
| `lucee.loader.engine.CFMLEngineFactory` | `Felix getFelix(File, Map)` | `org.osgi.framework.launch.Framework getFelix(File, Map)` |
| `lucee.loader.osgi.BundleCollection` | `public final Felix felix`, constructor `BundleCollection(Felix, Bundle, List<Bundle>)` | `public final Framework felix`, constructor `BundleCollection(Framework, Bundle, List<Bundle>)` |

`Framework` is the interface that Felix implements, code that only used the OSGi methods of the returned object keeps working after a recompile. Code that used methods that exist only in the Felix class does not.

### Extensions

Extensions that use Felix classes must be updated before they can run on Lucee 9. For the first-party extensions:

| Extension | Status |
| --- | --- |
| Hibernate (ORM) | uses `BundleReference` since 5.6.15.21 |

Check your own extensions with a search for `org.apache.felix` in the source and in the bytecode (`javap -c`), the import in a class file shows up as `org/apache/felix/`.

## ASM is shaded into the Lucee core

The bytecode library that Lucee uses to compile CFML (ASM) is no longer a set of separate bundles. It is **shaded** into the core: the classes are copied into the core (`.lco`) and their package is relocated from `org.objectweb.asm` to `lucee.shaded.asm`. This is the same step as for Felix above.

### Lucee does not provide `org.objectweb.asm` anymore

The core does not require the ASM bundles anymore (`org.objectweb.asm`, `org.objectweb.asm.commons`, `org.objectweb.asm.tree`, `org.objectweb.asm.tree.analysis`, `org.objectweb.asm.util`), and the Lucee jar does not ship them anymore. The classes in `org.objectweb.asm.*` are not visible through the core.

Code that used the ASM of Lucee fails with a `ClassNotFoundException` or `NoClassDefFoundError`, for example:

```
java.lang.NoClassDefFoundError: org/objectweb/asm/ClassReader
```

The shaded classes in `lucee.shaded.asm` are internal to the core, they are not exported and must not be used.

### Bring your own ASM

Code that needs ASM loads its own copy, in the version it needs.

In CFML, with `javaSettings` (on a component or in the `Application.cfc`), Lucee downloads the library from Maven:

```cfml
component javaSettings='{"maven":["org.ow2.asm:asm-util:9.10.1"]}' {

	function getBytecodeText( required binary classBytes ) {
		var reader = createObject( "java", "org.objectweb.asm.ClassReader" ).init( arguments.classBytes );
		var sw = createObject( "java", "java.io.StringWriter" ).init();
		var pw = createObject( "java", "java.io.PrintWriter" ).init( sw );
		var visitor = createObject( "java", "org.objectweb.asm.util.TraceClassVisitor" ).init( javaCast( "null", "" ), pw );
		reader.accept( visitor, 0 );
		pw.flush();
		return sw.toString();
	}
}
```

`asm-util` brings `asm`, `asm-tree` and `asm-analysis` as dependencies, use `org.ow2.asm:asm` alone if you only need the core classes.

In an extension, require the ASM bundles in the manifest of your bundle (`Require-Bundle: org.objectweb.asm;bundle-version=9.10.1` or `Import-Package: org.objectweb.asm`) or ship them in the extension. Bundles that are required but not installed are downloaded on demand.

**Offline installs:** before Lucee 9 the ASM bundles were part of the Lucee jar, now they are only downloaded when something requires them. On a server without internet access (or with `lucee.enable.bundle.download=false`) that download fails. Ship the ASM bundles with your extension, or copy the jars into the `bundles` folder of the server (`lucee-server/bundles`) before you start it.

### The bytecode API uses the relocated ASM types

The core exports the compiler API in `lucee.transformer.bytecode.*` (for example `BytecodeContext.getAdapter()`, which returns ASM's `GeneratorAdapter`). These classes now use the relocated types (`lucee.shaded.asm.*`), and those are not exported.

Code that was compiled against this API with the original ASM types does not link anymore on Lucee 9 (`NoSuchMethodError`, `NoClassDefFoundError`). This API is internal to the compiler, no first-party extension uses it.

### Migration

- Search your code and extensions for `org.objectweb.asm` in the source and in the bytecode (`javap -c`), the import in a class file shows up as `org/objectweb/asm/`.
- CFML that creates ASM objects with `createObject( "java", "org.objectweb.asm..." )`: add the ASM library with `javaSettings` (see above).
- Extensions that used the ASM bundles of Lucee: require them explicitly in the manifest and, for offline installs, ship them with the extension.
- Java code that extends or calls `lucee.transformer.bytecode.*`: do not depend on this API, generate your bytecode with your own copy of ASM.

## `group` of `cfoutput` and `cfloop` compares the values as strings

The `group` attribute of `cfoutput` and `cfloop` (tag and script) compared the values of the group column loosely, with numeric conversion. Values that are numerically equal but differ as text ended up in the same group: `"013"`, `"0013"` and `"13"` were one group in Lucee 8.0. In Lucee 9 the values are compared as strings, so they form separate groups, which is what Adobe ColdFusion does.

```cfml
<cfset q = queryNew( "artNr", "varchar", [ [ "013" ], [ "0013" ], [ "13" ] ] )>
<cfoutput query="q" group="artNr">#artNr#,</cfoutput>
<!--- 8.0: 013, --->
<!--- 9.0: 013,0013,13, --->
```

- Only adjacent rows are grouped, as before: the query has to be sorted by the group column.
- Case is still ignored by default, `groupCaseSensitive=true` compares the case as well.
- Numeric columns are not affected, `13` is `13` however it was written.
- The same applies to nested `group`.

### Migration

Code that relied on `"013"` and `"0013"` being one group has to make the values equal before the grouping, for example by selecting a normalized column in the query, such as `CAST( artNr AS INTEGER ) AS artNr` in the SQL, and grouping by it.

## Libraries that Lucee does not provide anymore

Lucee 9 removes third party libraries from the core that were only there for a feature that no longer needs them, or that are replaced by the JDK or by a small implementation of Lucee itself. Lucee does not provide the classes of these libraries to code that runs on Lucee anymore (CFML `createObject( "java", ... )`, extensions, bundles).

| Library | Package(s) | What replaced it |
| --- | --- | --- |
| Apache HttpClient 4, HttpCore 4, HttpMime | `org.apache.http.*` | cfhttp runs on an HTTP engine interface, the default engine is the JDK `java.net.http.HttpClient`. The features that need Apache HttpClient 5 (the full cfhttp feature set) come with the HTTP extension, using them without the extension fails with a message that says which feature and which extension. |
| commons-logging | `org.apache.commons.logging.*` | nothing, Lucee does not use it anymore |
| commons-email-all (`javax.mail`, `javax.activation`, `org.apache.commons.mail`) | `javax.mail.*`, `javax.activation.*`, `org.apache.commons.mail.*` | nothing in the core, the Mail extension brings its own `jakarta.mail`, `jakarta.activation` and `commons-email2` |
| commons-codec | `org.apache.commons.codec.*` | the JDK (`MessageDigest`, `HexFormat`) and small implementations in the core. `metaphone()` is not supported anymore and fails with a clear error, `soundex()` still works. |
| commons-fileupload2-core | `org.apache.commons.fileupload2.*` | a small streaming multipart parser in the core. The form scope and `cffile` upload behave as before, with two differences: a truncated or corrupted multipart request is rejected (empty form scope) where the library sometimes returned a partial form, and the limit for the headers of one part is 10240 bytes (it was 512). |

(commons-io and commons-pool2 are still provided for now.)

Code that used one of these libraries of Lucee fails with a `ClassNotFoundException` or a `NoClassDefFoundError`, for example:

```
java.lang.NoClassDefFoundError: javax/mail/Session
```

### Bring your own copy

In CFML, with `javaSettings` (on a component or in the `Application.cfc`), Lucee downloads the library from Maven:

```cfml
component javaSettings='{"maven":["com.sun.mail:javax.mail:1.6.2"]}' {

	function getSession( required any props ) {
		return createObject( "java", "javax.mail.Session" ).getInstance( arguments.props );
	}
}
```

In an extension, require the bundle in the manifest (for example `Require-Bundle: org.lucee.commons-email-all`, or `Import-Package` for the package you need) or ship the library in the extension. The mapping from the old bundle names to Maven is still in Lucee, so a bundle that is required but not installed is downloaded on demand.

**Offline installs:** the same as for ASM above, these libraries were part of the Lucee jar before, now they are only downloaded when something requires them. Without internet access (or with `lucee.enable.bundle.download=false`) the download fails. Ship the library with your extension, or copy the jars into the `bundles` folder of the server before you start it.

### Log output of libraries that bring their own commons-logging

Lucee used to set the system properties `org.apache.commons.logging.LogFactory`, `org.apache.commons.logging.Log` (`SimpleLog`) and `org.apache.commons.logging.simplelog.defaultlog` (`warn`) for every commons-logging in the JVM. It does not do that anymore, because it does not provide commons-logging anymore.

A library that brings its own commons-logging (for example the AWS SDK of the S3 extension or PDFBox of the PDF extension) now falls back to the discovery of commons-logging, which normally ends up in `java.util.logging` with the default level `INFO`. INFO messages of such a library can show up in the console of the servlet container (`catalina.out`) where they were suppressed before. To get the old behaviour back, set the system properties above yourself (for example in `setenv.sh` / `CATALINA_OPTS`), or configure `java.util.logging` for the package of the library.

### Migration

- Search your code and extensions for `javax.mail`, `org.apache.commons.mail`, `org.apache.commons.logging`, `org.apache.http`, `org.apache.commons.codec` and `org.apache.commons.fileupload2` in the source and in the bytecode (`javap -c`).
- CFML that creates objects of one of these libraries with `createObject( "java", ... )`: add the library with `javaSettings` (see above).
- cfhttp: nothing to change for the base feature set. If a request fails with a message that names the HTTP extension, install the extension.
- Extensions that used one of these libraries of Lucee: require it explicitly in the manifest or ship it, and for offline installs ship it with the extension.
- Code that calls `metaphone()`: use `soundex()` or another phonetic algorithm of your own.

## `isJson()` is strict by default

`isJson()` used the lenient expression parser of Lucee, so it also returned `true` for input that is not valid JSON and that other JSON parsers reject (unquoted keys, single quotes, trailing commas, comments, ...). In Lucee 9 `isJson()` has the new argument `lenient` with the default `false`: only strict JSON is valid.

```cfml
isJson( '{"foo":"bar"}' ); // true
isJson( '{foo:"bar"}' );   // true in 8.0, false in 9.0 (unquoted key)
isJson( "{'foo':'bar'}" ); // true in 8.0, false in 9.0 (single quotes)
isJson( '[1,2,]' );        // true in 8.0, false in 9.0 (trailing comma)
```

With the strict check the input is only validated, nothing in it is evaluated.

The argument `lenient` exists since 8.0, with the default `true` (no change in 8.0), so code can already be adjusted in 8.0.

### What else is affected

- `isValid( "json", value )` uses the default of `isJson()` and so is strict as well.
- `deserializeJSON()` is not changed, it stays lenient and still reads input like `{foo:"bar"}`.
- `format="json5"` is not affected by `lenient`, JSON5 is lenient by definition.

### Migration

Code that needs the previous behaviour passes `lenient=true`:

Before:

```cfml
isJson( '{foo:"bar"}' );
```

After:

```cfml
isJson( var='{foo:"bar"}', lenient=true );
// or, if the input is JSON5
isJson( '{foo:"bar"}', "json5" );
```

Code that decides with `isJson()` if a string can be passed to `deserializeJSON()` and that must also accept lenient input, needs `lenient=true` (or `format="json5"`) as well.
