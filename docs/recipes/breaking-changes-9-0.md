<!--
{
  "title": "Breaking Changes between Lucee 8.0 and 9.0",
  "id": "breaking-changes-8-0-to-9-0",
  "categories": ["breaking changes", "migration","compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 8.0 and 9.0",
  "keywords": ["breaking changes", "Lucee 8.0", "Lucee 9.0", "migration", "upgrade", "OSGi", "Felix", "ASM", "extensions"],
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
