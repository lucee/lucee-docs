Returns `null` if no entity matches the given primary key — always check with `isNull()` before using the result.

For composite primary keys, pass a struct with the key property names and values.

The returned entity is **persistent** — it is tracked by the ORM session. Any modifications are automatically detected and persisted on flush.

See [[orm-querying]] for all entity loading options.
