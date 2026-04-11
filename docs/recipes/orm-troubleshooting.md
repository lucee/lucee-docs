<!--
{
  "title": "ORM - Troubleshooting",
  "id": "orm-troubleshooting",
  "categories": [
    "orm"
  ],
  "description": "Common ORM pitfalls, error messages decoded, performance tips, and design patterns for Lucee ORM",
  "related": [
    "orm-configuration",
    "orm-session-and-transactions",
    "orm-relationships",
    "orm-events",
    "orm-logging",
    "orm-entity-mapping"
  ]
}
-->

# ORM - Troubleshooting

ORM is powerful but has sharp edges. This page covers common pitfalls, what the error messages actually mean, performance advice, and design patterns.

## Session and Flushing Traps

### Implicit Flush Surprise

With `flushAtRequestEnd: true` (the default), any dirty entity gets flushed at the end of the request — even changes you didn't mean to persist:

```cfml
user = entityLoadByPK( "User", 42 );
user.setName( "DISPLAY ONLY: " & user.getName() );
// You didn't call entitySave() — but the change persists anyway
```

**Fix:** Set `flushAtRequestEnd: false` and use explicit `cftransaction` blocks. The transaction commit handles the flush:

```cfml
this.ormSettings = {
	flushAtRequestEnd: false
};
```

### Flush Ordering

Hibernate flushes before HQL queries to keep the session consistent. This can cause unexpected INSERTs mid-request if you have unsaved dirty entities:

```cfml
entitySave( someEntity );
// You haven't called ormFlush() yet, but...
results = ORMExecuteQuery( "FROM OtherEntity" );
// Hibernate auto-flushed before the HQL query — someEntity is now INSERTed
```

### ORMFlush Outside a Transaction

Calling `ormFlush()` without a transaction means each SQL statement auto-commits individually. If something fails mid-flush, your data is in a partial state with no rollback.

**Fix:** Always use transactions for writes:

```cfml
transaction {
	entitySave( entity );
	// commit flushes and commits atomically
}
```

## Lazy Loading Landmines

### "Could not initialize proxy - no Session"

The #1 ORM error. Happens when you access a lazy-loaded relationship after the session is closed:

```cfml
// Request 1
session.currentUser = entityLoadByPK( "User", 42 );

// Request 2
user = session.currentUser;
user.getOrders();  // BOOM — "no Session"
```

**Fix:** Never store ORM entities in `SESSION` or `APPLICATION` scope. Store the PK and reload each request:

```cfml
session.currentUserId = 42;
// later...
user = entityLoadByPK( "User", session.currentUserId );
```

Or use `entityMerge()` to reattach a detached entity to the current session.

### Memory Tracking Kills Lazy Loading

If Lucee's "memory tracking" is enabled in the admin, lazy relationships get eagerly loaded silently. Massive performance hit with zero warning.

**Fix:** Disable memory tracking in production (Lucee Admin > Settings > Performance).

### Serializing Entities

`duplicate()`, `serializeJSON()`, and storing in session scope all trigger lazy loading of ALL relationships recursively. This can explode memory or hit "no Session" errors.

**Fix:** Convert to plain structs before serializing:

```cfml
data = {
	id: user.getId(),
	name: user.getName()
};
serializeJSON( data );
```

## N+1 Query Problem

Loading a list of parents and accessing a lazy relationship triggers one query per parent:

```cfml
// 1 query: SELECT * FROM dealerships
dealers = entityLoad( "Dealership" );
for ( dealer in dealers ) {
	// N queries: SELECT * FROM autos WHERE dealerID = ? (once per dealer!)
	writeOutput( arrayLen( dealer.getInventory() ) );
}
```

**Diagnosis:** Enable `logSQL: true` in [[orm-configuration]]. If you see the same SELECT repeated with different IDs, you've got N+1.

**Fixes:**

- `batchsize` on the relationship — loads multiple collections per query. See [[orm-relationships]]
- HQL JOIN FETCH — `ORMExecuteQuery( "FROM Dealership d JOIN FETCH d.inventory" )`. See [[orm-querying]]
- `fetch="join"` on the relationship — single JOIN query, good when you always need the association
- `lazy="extra"` on large collections — `.size()` runs a COUNT instead of loading all children

## Entity Mapping Mistakes

### ormtype vs Column Mismatch

Hibernate type doesn't match database column type = cryptic errors at flush time, not at load time. If you set `ormtype="integer"` but the column is VARCHAR, the error appears when you try to save, not when the entity is mapped.

**Fix:** Check generated mappings with `savemapping: true`. See [[orm-logging]].

### Missing inverse on Bidirectional Relationships

Without `inverse="true"` on the non-owning side, you get duplicate INSERT/UPDATE statements:

```sql
-- Without inverse: Hibernate writes the FK from BOTH sides
INSERT INTO autos (id, make, model, dealerID) VALUES (?, ?, ?, ?)
UPDATE autos SET dealerID = ? WHERE id = ?  -- redundant!
```

**Fix:** Set `inverse="true"` on the one-to-many side. See [[orm-relationships]].

### Replacing a Collection

Hibernate loses track of the proxied collection when you replace it:

```cfml
// BAD — Hibernate recreates the entire collection (DELETE all + INSERT all)
entity.setChildren( newArray );

// GOOD — modify in place
entity.getChildren().clear();
entity.getChildren().addAll( newArray );
```

### Generator Mismatch

Using `generator="identity"` on a database that doesn't support IDENTITY columns (e.g. Oracle needs `"sequence"`). Use `generator="native"` to let the database pick the right strategy.

## Configuration Foot Guns

### dbcreate="dropcreate" in Production

Drops and recreates all tables on every application restart. Self-explanatory disaster.

**Production settings:** `dbcreate: "none"` or `dbcreate: "validate"`.

### dbcreate="update" Limitations

Only ADDS columns and tables. Never removes columns, renames anything, or changes column types. Don't rely on it for real migrations — use a dedicated migration tool.

### ORMReload() in Production

[[function-ormreload]] rebuilds all mappings, closes all sessions, causes request pile-ups while the SessionFactory is rebuilt. Development only.

### savemapping=true in Production

Writes `.hbm.xml` files to disk on every application startup. Development only.

### Not Setting a Dialect

Hibernate auto-detects the dialect from the JDBC driver, but sometimes gets it wrong — especially with JTDS drivers or less common databases.

**Fix:** Always set `dialect` explicitly in [[orm-configuration]].

## Transaction Mistakes

### No Transaction at All

`entitySave()` without a `cftransaction` means the flush happens at request end (or on explicit `ormFlush()`) with no rollback safety. If the flush partially fails, your data is inconsistent.

### Nested ORMFlush in Event Handlers

Calling `ormFlush()` inside `preInsert` or `postInsert` = infinite loop. See [[orm-events]].

## Performance Tips

- **Use HQL for bulk operations** — `ORMExecuteQuery( "DELETE FROM Product WHERE active = false" )` is much faster than loading and deleting entities one by one
- **Use `lazy="extra"` for large collections** where you mostly need `.size()` — avoids loading the full collection
- **Use `entityToQuery()`** when you need tabular data, not full entity graphs
- **Batch your saves with flush + clear** — for bulk inserts, call `ormFlush()` + `ormClearSession()` every 50 entities. Without clearing, the session grows unbounded and each flush dirty-checks everything — leading to O(N²) slowdown and eventually OOM. See [[orm-session-and-transactions]]
- **Use query caching** (`cacheable: true`) for HQL queries that run frequently with the same parameters. See [[orm-caching]]
- **Use L2 cache for read-heavy reference data** — lookup tables that are loaded constantly but rarely change
- **Keep entity CFCs thin** — business logic belongs in service layers, not entities

## Design Patterns

- **Keep relationships shallow** — deep entity graphs cause cascading loads and saves
- **Prefer unidirectional relationships** unless you genuinely need navigation from both sides
- **Use assigned IDs (UUIDs)** instead of database-generated IDs when you need to create entities before saving
- **Name your entities explicitly** with `entityname` if CFC names would collide across directories
- **`dbdefault` vs `default`** — `dbdefault` affects schema generation (DDL DEFAULT clause), `default` affects CFC behaviour (application-level default). They're different things

## Common Error Messages

### "could not initialize proxy - no Session"

Lazy load after session closed. You're accessing a relationship on an entity whose session has ended. See [Lazy Loading Landmines](#lazy-loading-landmines).

### "object references an unsaved transient instance"

You're saving an entity that has a relationship pointing to another entity that hasn't been saved yet.

**Fix:** Either save the referenced entity first, or add `cascade="all"` (or `cascade="save-update"`) to the relationship.

### "a different object with the same identifier value was already associated with the session"

Two different CFC instances with the same primary key are in the same session.

**Fix:** Use `entityMerge()` to merge the detached instance, or call `ormClearSession()` before loading.

### "could not determine type"

`ormtype` not set and Hibernate can't infer the type from the CF type.

**Fix:** Set `ormtype` explicitly on the property.

### "Unknown entity: Foo"

Entity CFC not found during HQL or `entityLoad()`.

**Checklist:**

- Is `persistent="true"` set on the CFC?
- Is the CFC in a directory listed in `cfclocation`?
- Does the `entityname` match what you're using in queries?

### "MappingException: collection was not an association"

`fieldtype="collection"` requires `elementtype` and `elementcolumn`. See [[orm-relationships]].

### "Table 'X' doesn't exist"

`dbcreate="none"` or `dbcreate="validate"` and the table is missing from the database. Create the table or change `dbcreate`.

### "ids for this class must be manually assigned"

Missing `generator` attribute on the ID property.

**Fix:** Add `generator="native"` or another strategy. See [[orm-entity-mapping]].

### "Batch update returned unexpected row count"

Optimistic locking failure — the row was modified by another process between your load and your save. Can also be caused by database triggers that affect row counts.

### "Unable to locate appropriate constructor"

HQL `select new` syntax issue, or `entityNew()` with a property struct that doesn't match.

### "this feature is not supported"

Mixing ORM and raw SQL in the same transaction on older versions. Fixed in 5.6 (LDEV-6234). Upgrade to the latest extension.

### "PersistentTemplateProxy cannot be cast to java.util.Collection"

many-to-one relationship configured where a collection type was expected (or vice versa). Check that `fieldtype` matches the actual relationship cardinality.

### "Unrecognized Id Type"

`ormtype` mismatch on the ID property — the type you specified doesn't match what Hibernate expects for the generator.

### "ConcurrentModificationException"

This is a Hibernate *logger* bug, not a data integrity issue. It occurs when flushing one-to-many saves because Hibernate's logger iterates a collection that's being modified. The save succeeds — the exception is cosmetic. The 5.6 logging bridge handles this via the native logging integration.

## What's Next?

- [[orm-logging]] — enable SQL logging to diagnose issues
- [[orm-configuration]] — settings reference
- [[orm-relationships]] — inverse, cascade, and fetching strategies
- [[orm-session-and-transactions]] — session lifecycle and transaction handling
