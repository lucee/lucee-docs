**`IsInstanceOf` accepts three type-string forms for components.**

For each component in the inheritance chain, the runtime checks the type string against three things — any match is enough:

1. The **bare class name** — the last segment of the loading path, e.g. `Child` for a CFC at `mypackage/SubFolder/Child.cfc`.
2. The **loading-context-relative path** that was passed to `new`, e.g. `SubFolder.Child` when instantiated from inside `mypackage/`.
3. The **fully-qualified path from the web root**, which is what `getMetaData( c ).name` returns, e.g. `mypackage.SubFolder.Child`.

Matches are case-insensitive. The check walks the `extends` chain and any interfaces declared via `implements` on the component or its ancestors.

```luceescript
var c = new mypackage.SubFolder.Child();   // extends ParentBase implements MyInterface

isInstanceOf( c, "Child" );                            // true — bare class name
isInstanceOf( c, "mypackage.SubFolder.Child" );        // true — full path
isInstanceOf( c, getMetaData( c ).name );              // true — same as above
isInstanceOf( c, "ParentBase" );                       // true — extends chain
isInstanceOf( c, "MyInterface" );                      // true — implements (incl. from ancestors)
isInstanceOf( c, "Component" );                        // true — every CFC matches
```

A path slice that's none of those three forms (e.g. `SubFolder.Child` when the loading path was different) returns false.

**Java class checks accept the FQCN, plus a small shortlist of bare names.**

For Java types, pass the fully-qualified Java class or interface name (e.g. `java.util.Map`, `java.lang.String`) — Lucee runs the standard `instanceof` check against the underlying Java object.

A few bare names also resolve, via a hardcoded shortlist in `ClassUtil.checkPrimaryTypes`: the Java primitives (`boolean`, `int`, `long`, `float`, `double`, `byte`, `char`, `short`), plus `Object`, `String`, `Integer`, `Character`, plus the CFML synonyms `Numeric` (= `Double`) and `Null` (= `Object`). Other bare Java names (`Map`, `CharSequence`, `Comparable`, etc.) do **not** resolve — use the FQCN.
