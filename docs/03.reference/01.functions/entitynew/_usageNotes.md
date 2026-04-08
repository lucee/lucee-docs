The entity must be a persistent CFC with `persistent="true"`. The `entityName` argument is the entity name (defaults to the CFC name unless `entityname` is set on the component).

If you pass a `properties` struct, the values are set via setter methods — `accessors="true"` must be set on the CFC.

`entityNew()` creates a **transient** entity — it is not tracked by the ORM session until you call [[function-entitysave]].

See [[orm-getting-started]] for a complete walkthrough.
