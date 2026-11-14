*New in 5.6.* Returns the isolation level as a lowercase string matching the convention of the core `getTransactionIsolation()` BIF.

Possible return values: `"none"`, `"read_uncommitted"`, `"read_committed"`, `"repeatable_read"`, `"serializable"`, or `""` if no ORM session is active.

See [[orm-session-and-transactions]] for transaction isolation details.
