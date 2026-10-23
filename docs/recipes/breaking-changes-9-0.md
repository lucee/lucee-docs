<!--
{
  "title": "Breaking Changes between Lucee 8.0 and 9.0",
  "id": "breaking-changes-8-0-to-9-0",
  "categories": ["breaking changes", "migration","compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 8.0 and 9.0",
  "keywords": ["breaking changes", "Lucee 8.0", "Lucee 9.0", "migration", "upgrade", "OSGi", "Felix", "extensions"],
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
