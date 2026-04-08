`entitySave()` does **not** immediately write to the database. It marks the entity as pending in the ORM session. The actual INSERT or UPDATE executes when the session flushes — either at transaction commit, on explicit [[function-ormflush]], or at request end if `flushAtRequestEnd` is `true`.

For new entities with `generator="native"` or `generator="identity"`, the INSERT executes immediately because Hibernate needs the database-generated ID.

When `forceInsert` is `true`, Hibernate always attempts an INSERT regardless of whether the entity already exists. Use this when you know the entity is new but Hibernate might think otherwise (e.g. assigned IDs).

Always wrap saves in a `transaction` block for rollback safety. See [[orm-session-and-transactions]].
