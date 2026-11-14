`entityMerge()` copies the state of a **detached** entity onto a persistent instance in the current session and returns that persistent instance. Always use the returned object — the original detached entity is not modified.

A common use case is reattaching an entity after [[function-ormclearsession]] or across requests.

See [[orm-session-and-transactions]] for details on entity lifecycle states.
