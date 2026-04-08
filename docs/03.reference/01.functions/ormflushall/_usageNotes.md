Equivalent to calling [[function-ormflush]] for each active datasource session.

Useful when your application uses multiple ORM datasources and you want to flush all pending changes in one call.

Like [[function-ormflush]], prefer using `transaction` blocks over manual flush calls — calling `ORMFlushAll()` outside a transaction means each statement auto-commits individually with no rollback on failure.

See [[orm-session-and-transactions]] for multi-datasource details.
