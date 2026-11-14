Flushes the current ORM session — all pending INSERT, UPDATE, and DELETE operations are executed against the database.

If a `datasource` argument is provided, only the session for that datasource is flushed. Otherwise the default ORM datasource session is flushed.

Prefer using `transaction` blocks over manual `ormFlush()` calls — the transaction commit handles the flush and provides rollback safety. Calling `ormFlush()` outside a transaction means each statement auto-commits individually with no rollback on failure.

See [[orm-session-and-transactions]] for flush timing details.
