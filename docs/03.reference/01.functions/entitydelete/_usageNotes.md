The entity must be **persistent** (loaded from the database or previously saved). Deleting a transient entity has no effect.

The actual DELETE SQL executes on session flush, not immediately. Use a `transaction` block for rollback safety.

See [[orm-session-and-transactions]] for details on flush timing.
