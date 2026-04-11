<!--
{
  "title": "ORM - Sessions and Transactions",
  "id": "orm-session-and-transactions",
  "categories": [
    "orm"
  ],
  "description": "Understanding ORM sessions, entity lifecycle states, flush behaviour, dirty checking, transactions, savepoints, and multi-datasource usage in Lucee",
  "related": [
    "orm-getting-started",
    "orm-configuration",
    "orm-querying",
    "orm-troubleshooting",
    "function-ormgetsession",
    "function-ormflush",
    "function-ormclearsession",
    "function-ormclosesession",
    "function-entitymerge",
    "function-entityreload"
  ]
}
-->

# ORM - Sessions and Transactions

The ORM session is the most important concept to understand — and the most common source of confusion. This page covers the session lifecycle, entity states, dirty checking, flush behaviour, transactions, and multi-datasource usage.

## What is the ORM Session?

The ORM session is a first-level cache between your application and the database. When you load or save an entity, it goes through the session:

- **Load:** Hibernate checks the session cache first. If the entity is already loaded, it returns the same instance — loading the same PK twice gives you the exact same object
- **Save:** `entitySave()` registers the entity in the session but doesn't immediately write to the database
- **Flush:** When the session flushes, Hibernate generates and executes the SQL (INSERT, UPDATE, DELETE) for all pending changes

## Session Lifecycle

1. **Application start** — Hibernate builds a `SessionFactory` (expensive, lives for the application lifetime)
2. **First ORM operation** — Lucee creates a session on demand (when you call `entityLoad()`, `entitySave()`, `ORMGetSession()`, etc.)
3. **During the request** — the session accumulates changes
4. **Flush** — pending changes are written to the database (see [When Does the Session Flush?](#when-does-the-session-flush))
5. **Request end** — the session is closed and all entities become detached

## Entity Lifecycle States

Every entity is in one of four states:

```
                entitySave()                    ormClearSession()
                    |                                |
entityNew() --> TRANSIENT --> PERSISTENT -------> DETACHED
                                |   ^                |
                                |   |  entityMerge() |
                                |   +----------------+
                                |
                          entityDelete()
                                |
                                v
                             REMOVED
```

### Transient

A new entity that hasn't been saved. The session doesn't know about it:

```cfml
entity = entityNew( "User", { id: createUUID(), name: "Susi" } );
// entity is transient — not tracked by the session
```

### Persistent

An entity that's been saved or loaded. The session tracks it and will flush changes:

```cfml
entitySave( entity );
// entity is now persistent — session tracks it

loaded = entityLoadByPK( "User", 42 );
// loaded is also persistent — came from the session/database
```

### Detached

An entity that was persistent but is no longer in the session (session was cleared or closed):

```cfml
ormClearSession();
// all entities in this session are now detached
// modifying them has no effect on the database
```

Reattach a detached entity with [[function-entitymerge]]:

```cfml
merged = entityMerge( detachedEntity );
// merged is a NEW persistent instance — use it, not the old reference
```

### Removed

An entity marked for deletion. It will be DELETEd on the next flush:

```cfml
entityDelete( entity );
// entity is removed — DELETE executes on flush
```

### Verifying State

Use the native Hibernate session to check:

```cfml
sess = ORMGetSession();
sess.contains( entity );  // true if persistent
```

## When Does the Session Flush?

This is the #1 source of ORM confusion. Flush timing depends on your configuration:

### flushAtRequestEnd: true (the default)

All dirty entities are automatically flushed at the end of every request. This means:

```cfml
user = entityLoadByPK( "User", 42 );
user.setName( "Oops" );
// You didn't call entitySave() or ormFlush()
// But the change persists anyway — Hibernate detected the dirty property
```

This is called **implicit flush**, and it's the most dangerous default in ORM. Set `flushAtRequestEnd: false` in your [[orm-configuration]].

### flushAtRequestEnd: false (recommended)

You control when persistence happens:

```cfml
// Nothing persists until you say so
user = entityLoadByPK( "User", 42 );
user.setName( "Safe to modify" );
// change is NOT persisted — no flush happens automatically
```

With `flushAtRequestEnd: false`, persistence happens when:

1. **Transaction commit** — a `cftransaction` block commits (explicit or implicit)
2. **Explicit `ormFlush()`** — you call it directly
3. **Before HQL queries** — Hibernate auto-flushes to ensure query consistency (but NOT before `queryExecute()` / raw SQL)

### Dirty Checking

Hibernate automatically detects changes to persistent entities. You don't need to call `entitySave()` on an entity you loaded and modified — the change is detected at flush time.

This is powerful but can bite you: modifying an entity for display purposes (e.g. formatting a name) silently persists the change.

## Session BIFs

| Function | Description |
|----------|-------------|
| Function | Description |
|----------|-------------|
| [[function-ormgetsession]] | Returns the native `org.hibernate.Session` for the current request. Lucee returns the Hibernate session directly (unlike ACF which wraps it) |
| [[function-ormgetsessionfactory]] | Returns the `org.hibernate.SessionFactory` |
| [[function-ormflush]] | Flushes the current session — writes all pending changes to the database |
| `ORMFlush( datasource )` | Flushes the session for a specific datasource |
| `ORMFlushAll()` | Flushes all datasource sessions |
| [[function-ormclearsession]] | Clears the session cache — all entities become detached. Does NOT flush |
| [[function-ormclosesession]] | Closes the current session. A new one is created on next ORM operation |
| [[function-ormcloseallsessions]] | Closes all sessions across all datasources |
| [[function-entitymerge]] | Reattaches a detached entity, returning a new persistent instance |
| [[function-entityreload]] | Refreshes an entity from the database, discarding in-memory changes |

> **Important:** `ORMGetSession()` returns the native `org.hibernate.Session` directly. In ACF, it returns a `SessionWrapper` that requires `.getActualSession()` for native API access. This matters if you're migrating code from ACF — see [[orm-migration-guide]].

### Session Diagnostics

The native session exposes useful debugging methods:

```cfml
sess = ORMGetSession();

// Is anything pending?
sess.isDirty();  // true if there are unflushed changes

// Session statistics
stats = sess.getStatistics();
stats.getEntityCount();      // number of entities in the session cache
stats.getCollectionCount();  // number of collections in the session cache
```

## Transactions

For anything beyond throwaway scripts, wrap ORM operations in a transaction:

### Basic Transaction

```cfml
transaction {
	product = entityNew( "Product", { name: "Widget", price: 9.99 } );
	entitySave( product );
	// transaction commit flushes the session and commits
}
```

When the `transaction` block ends without an explicit commit or rollback, it **auto-commits**. The session is flushed before the commit.

### Explicit Commit and Rollback

```cfml
transaction {
	entitySave( entityNew( "Product", { name: "Widget", price: 9.99 } ) );
	transactionCommit();
	// committed — data is in the database
}
```

```cfml
transaction {
	entitySave( entityNew( "Product", { name: "Widget", price: 9.99 } ) );
	transactionRollback();
	// rolled back — nothing persisted
}
```

### Why Always Use Transactions?

Without a transaction, `ormFlush()` auto-commits each statement individually. If something fails mid-flush:

- Some INSERTs succeed, others don't
- Your data is in a partial, inconsistent state
- There's no way to roll back

With a transaction, either everything commits or nothing does.

### Transaction Session Lifecycle

Understanding what happens to the ORM session during transactions is critical:

1. **Transaction begins** — a new Hibernate transaction starts on the session
2. **Transaction commits** — the session is auto-flushed, then the database transaction commits
3. **Transaction rolls back** — the database transaction rolls back and the session is cleared (all entities become stale — don't reuse them)
4. **Transaction ends without commit/rollback** — auto-commits

> **After rollback, entities are stale.** The session is cleared, but your CFC variables still point to the old objects. Don't try to save or modify them — load fresh entities if you need to continue.

### Rollback Example

```cfml
id1 = createUUID();
id2 = createUUID();

transaction {
	entitySave( entityNew( "Auto", { id: id1, make: "Toyota" } ) );
	ormFlush();

	entitySave( entityNew( "Auto", { id: id2, make: "Ford" } ) );
	ormFlush();

	transactionRollback();
}
// Both Toyota and Ford are rolled back — neither is in the database
```

### Savepoints

Savepoints let you partially roll back within a transaction: *(new in 5.6)*

```cfml
transaction {
	entitySave( entityNew( "Auto", { id: createUUID(), make: "Toyota" } ) );
	transactionSetSavepoint();

	entitySave( entityNew( "Auto", { id: createUUID(), make: "Ford" } ) );
	transactionRollback( "savepoint1" );

	// Toyota is kept, Ford is rolled back
	transactionCommit();
}
```

### IsWithinORMTransaction()

Check whether you're inside an active ORM transaction: *(new in 5.6)*

```cfml
isWithinORMTransaction();  // false

transaction {
	isWithinORMTransaction();  // true
	entitySave( entityNew( "Auto", { id: createUUID(), make: "Toyota" } ) );
}

isWithinORMTransaction();  // false
```

This replaces the need for Java hacks like ACF's `TransactionTag.getCurrent()`.

### Transaction Isolation Levels

Control the isolation level for a transaction: *(requires Lucee 7.1+)*

```cfml
transaction isolation="serializable" {
	// strictest isolation — serializable reads
	entitySave( ... );
}
```

Check the current isolation level with `GetORMTransactionIsolation()`.

### Multi-Datasource Restriction

Only **one** datasource session can be dirty within a single transaction. If you modify entities from two different datasources inside the same `transaction` block, Lucee throws an exception and rolls back.

## Batch Processing

When inserting or updating large numbers of entities (bulk imports, nightly jobs, data migrations), you **must** periodically flush and clear the session. Without clearing, every entity stays attached and each flush dirty-checks all of them — making total work O(N²) and eventually causing `OutOfMemoryError`.

```cfml
var batchSize = 50;
for ( var i = 1; i <= totalRecords; i++ ) {
	var entity = entityNew( "Product" );
	entity.setName( "Item #i#" );
	entity.setSku( "SKU-#i#" );
	entitySave( entity );

	if ( i mod batchSize == 0 ) {
		ormFlush();
		ormClearSession();  // detach processed entities, free memory
	}
}
ormFlush();  // flush any remainder
```

### Why this matters

Without `ormClearSession()`, Hibernate's first-level cache (the session identity map) grows with every entity. Each `ormFlush()` must dirty-check every attached entity to determine what changed — even entities from previous batches that haven't been modified.

At 40,000 entities with 10 properties each, that's 400,000 property reads per flush. With 50,000 entities and 1,000 flushes, total property reads approach 500 million — almost all wasted on entities that haven't changed.

### Impact

Profiling with 50,000 entities (batch size 50):

| | Without clear | With clear |
|---|---|---|
| Time | 55 sec | **3.5 sec** |
| Rate | 903 ent/sec | **14,204 ent/sec** |
| Heap growth | 837 MB | **244 MB** |

### Tips

- **Batch size of 20-50** works well for most cases — matches Hibernate's default JDBC batch size
- **Wrap in a transaction** if you need atomicity across the full import
- **Use HQL for simple bulk updates/deletes** instead of loading entities: `ORMExecuteQuery( "UPDATE Product SET active = false WHERE lastSold < :cutoff", { cutoff: dateAdd( "yyyy", -1, now() ) } )`
- After `ormClearSession()`, any entity references you held are now **detached** — don't modify them

## Mixing ORM and Raw SQL

A common need — use `entitySave()` for some operations and `queryExecute()` for others in the same request.

**Critical rule:** `entitySave()` does NOT automatically flush before `queryExecute()` runs. If you save an entity and then try to read it with raw SQL, the row won't be there yet:

```cfml
entitySave( entityNew( "User", { id: 1, name: "Susi" } ) );

// BAD — the row hasn't been flushed to the database yet
result = queryExecute( "SELECT * FROM users WHERE id = 1" );
// result.recordCount is 0!

// GOOD — flush first
ormFlush();
result = queryExecute( "SELECT * FROM users WHERE id = 1" );
// result.recordCount is 1
```

This applies to both Lucee and ACF. Always call `ormFlush()` before raw SQL reads if you've made ORM changes. Within a transaction, the flush ensures both ORM and SQL operations see the same state.

## Multiple Datasources

ORM supports multiple datasources with separate entity sets and sessions.

### Configuration

Map entities to specific datasources using the `datasource` attribute on the entity, or configure multiple datasources in Application.cfc:

```cfml
this.datasources["inventory"] = { ... };
this.datasources["accounts"]  = { ... };
this.ormSettings = {
	datasource: "inventory"  // default for ORM
};
```

### Lazy Session Opening

Sessions are created lazily — only when you first use a datasource:

```cfml
// Only the default datasource session opens
car = entityNew( "Auto" );
car.setId( createUUID() );
entitySave( car );
ormFlush();

// NOW the second datasource session opens
dealer = entityNew( "Dealership" );
dealer.setId( createUUID() );
entitySave( dealer );
ormFlush( "accounts" );
```

### Flushing All Datasources

`ORMFlushAll()` flushes every open datasource session in one call:

```cfml
entitySave( car );
entitySave( dealer );
ORMFlushAll();  // flushes both datasources
```

### Datasource-Scoped HQL

Pass the `datasource` option to `ORMExecuteQuery()`:

```cfml
results = ORMExecuteQuery(
	"FROM Product WHERE active = true",
	{},
	false,
	{ datasource: "inventory" }
);
```

## Common Session Mistakes

### Never Store Entities in SESSION or APPLICATION Scope

ORM entities are bound to the request-scoped Hibernate session. When the request ends, the session closes and entities become detached. Accessing lazy-loaded relationships on a detached entity throws "could not initialize proxy - no Session".

```cfml
// BAD
session.currentUser = entityLoadByPK( "User", 42 );

// GOOD — store the PK, reload each request
session.currentUserId = 42;
user = entityLoadByPK( "User", session.currentUserId );
```

### Serializing Entities

`duplicate()`, `serializeJSON()`, and storing in session scope all trigger lazy loading of ALL relationships recursively. This can explode memory or hit "no Session" errors. Convert to plain structs first if you need to serialize.

### ORMFlush Unnecessary Updates

A known issue: flushing a one-to-many relationship can generate UPDATE statements that set child FK columns to null and then back to the correct value. This is cosmetic (no data loss) but generates unnecessary SQL. Wrapping in a transaction avoids the issue.

## What's Next?

- [[orm-events]] — entity lifecycle events that fire during flush
- [[orm-troubleshooting]] — "no Session", "unsaved transient instance", and transaction error messages
- [[orm-configuration]] — flushAtRequestEnd, autoManageSession settings
