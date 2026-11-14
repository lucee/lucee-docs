Closes the current ORM session and releases its database connection back to the pool. All entities in the session become detached.

A new session is automatically created on the next ORM operation. The session is also automatically closed at the end of every request regardless of whether you call this function.

In most cases you don't need to call this — it's mainly useful for explicitly releasing resources in long-running requests.

See [[orm-session-and-transactions]] for session lifecycle details.
