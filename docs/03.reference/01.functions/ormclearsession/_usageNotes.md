**Unflushed changes are lost.** This function clears the first-level session cache without flushing — all entities become **detached** and any pending INSERT/UPDATE/DELETE operations are discarded.

If you need to persist changes before clearing, call [[function-ormflush]] first.

Common uses:

- Ensuring fresh database reads (e.g. after bulk SQL updates)
- Releasing memory in long-running requests that load many entities
- Testing: clearing state between operations

See [[orm-session-and-transactions]] for entity lifecycle states.
