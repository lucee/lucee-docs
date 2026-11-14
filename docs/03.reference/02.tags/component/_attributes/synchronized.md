If set to true all calls to an instance of a component are synchronized. This setting allows a method to be executed only by one single thread at a time.

The flag is **per-class, not inherited**. A child component that does not redeclare `synchronized="true"` is *not* synchronized, even when extending a synchronized parent. The runtime reads the flag from the leaf class's compile-time properties, so each class that needs serialised dispatch must declare `synchronized="true"` itself.

```luceescript
// SyncedParent.cfc:  component synchronized="true" { ... }
// PlainChild.cfc:    component extends="SyncedParent" { ... }

var sc = new PlainChild();
getMetaData( sc ).synchronized;          // false — child did not redeclare
getMetaData( sc ).extends.synchronized;  // true  — visible on the parent
```

Method calls on `sc` run unsynchronised. If you want the child synchronised too, declare `synchronized="true"` on the child as well.

`Duplicate()` preserves the flag from the source — a duplicate of a synchronized component is itself synchronized.

**Adobe ColdFusion compatibility.** `synchronized` is a Lucee-only attribute. It is not documented in Adobe ColdFusion's `cfcomponent` reference and ACF (verified through ACF 2025) does not honour it at runtime — the attribute is silently accepted and stored in metadata, but concurrent method dispatch on a CFC declaring `synchronized="true"` is **not** serialised. If you need cross-engine thread safety, use `cflock` inside the methods that need it instead of relying on the component-level attribute.
