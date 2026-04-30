**Runtime-injected functions are invisible to `GetMetadata`.** When you assign a closure to a component at runtime — `myComp.foo = function(){ ... }` — the function is callable on the instance but does **not** appear in `GetMetadata( myComp ).functions`. Only declared `<cffunction>` definitions and auto-generated `accessors=true` getters/setters are surfaced.

This matches Adobe ColdFusion behaviour: `GetMetadata()` reflects the component's *declared structure*, not its current runtime member table. If you need to discover dynamically-injected methods, iterate the component as a struct (e.g. `structKeyArray( myComp )`) — runtime mixins live in the variables/this scope, not in metadata.

The same applies to `Component.duplicate()`: a duplicate's `GetMetadata` output is identical to the prototype's, regardless of any runtime mixins applied to either side.
