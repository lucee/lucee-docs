**Runtime-injected functions are invisible to `GetMetadata`.** When you assign a closure to a component at runtime — `myComp.foo = function(){ ... }` — the function is callable on the instance but does **not** appear in `GetMetadata( myComp ).functions`. Only declared `<cffunction>` definitions and auto-generated `accessors=true` getters/setters are surfaced.

This matches Adobe ColdFusion behaviour: `GetMetadata()` reflects the component's *declared structure*, not its current runtime member table. If you need to discover dynamically-injected methods, iterate the component as a struct (e.g. `structKeyArray( myComp )`) — runtime mixins live in the variables/this scope, not in metadata.

The same applies to `Component.duplicate()`: a duplicate's `GetMetadata` output is identical to the prototype's, regardless of any runtime mixins applied to either side.

**`implements` is reported on the CFC that declared it, not on descendants.**

When a component inherits an interface implementation through `extends`, the `implements` key only appears on the metadata of the CFC that originally declared `implements="…"`. Descendant components have an empty `implements` struct of their own:

```luceescript
// IBase.cfc:    component implements="IFace" { ... }
// IChild.cfc:   component extends="IBase" { ... }

var c = new IChild();
var meta = getMetaData( c );

writeDump( meta.implements );                  // {} — IChild does not directly implement
writeDump( meta.extends.implements.IFace );    // the IFace metadata, declared on IBase
```

To check whether an instance fulfils an interface across the whole hierarchy, prefer `IsInstanceOf( cfc, "interface.path" )`, or walk the `extends` chain looking for the interface key.

The same shape applies to `properties` and `functions`: each CFC's metadata reports only what's declared in that file. Inherited members live on `meta.extends.properties`, `meta.extends.functions`, and so on — walk the chain to flatten.

**The `name` field is the fully-qualified dotted path.**

`getMetaData( cfc ).name` is the path from the web/test root with `/` replaced by `.`, not the relative path you may have passed to `new`. `IsInstanceOf` accepts this string, the relative path, or the bare class name (see [`isinstanceof`](../isinstanceof/_usageNotes.md)).

