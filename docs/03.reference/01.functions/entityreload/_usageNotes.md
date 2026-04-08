Refreshes the entity from the database, discarding any in-memory changes. The entity must be **persistent** (in the current session).

Useful when you suspect the database has been modified by another process or raw SQL and you want the latest state.
