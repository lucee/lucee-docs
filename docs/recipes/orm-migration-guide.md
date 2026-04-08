<!--
{
  "title": "ORM - Migration Guide",
  "id": "orm-migration-guide",
  "categories": [
    "orm"
  ],
  "description": "What's new in the 5.6 ORM extension, migrating from older versions, and migrating from Adobe ColdFusion ORM to Lucee",
  "related": [
    "orm-configuration",
    "orm-session-and-transactions",
    "orm-events",
    "orm-logging"
  ]
}
-->

# ORM - Migration Guide

This page covers what changed in the 5.6 ORM extension, what's coming in future versions, and how to migrate from Adobe ColdFusion.

## What's New in 5.6

### New ormSettings

| Setting | Description |
|---------|-------------|
| `logParams` | Logs parameter bindings for SQL statements |
| `logCache` | Logs L2 cache activity |
| `logVerbose` | Logs Hibernate internals |
| `formatSQL` | Pretty-prints SQL in logs |

All default to `false`. See [[orm-logging]] for full setup.

### New BIFs

| Function | Description |
|----------|-------------|
| `IsWithinORMTransaction()` | Returns `true` if a Hibernate transaction is active |
| `GetORMTransactionIsolation()` | Returns the current transaction isolation level |

### New dbcreate Modes *(requires Lucee 7.0.4+)*

| Mode | Description |
|------|-------------|
| `"create"` | Creates tables if they don't exist, ignores existing |
| `"create-drop"` | Creates on startup, drops on shutdown |
| `"validate"` | Checks every mapped table exists, throws on mismatch |

> **Note:** `"validate"` currently checks table existence only — column and type validation is not yet supported (Hibernate 5.6 limitation, HHH-10882). On older Lucee versions these modes silently fall back to `"none"`.

See [[orm-configuration]] for all schema management options.

### Transaction Integration

- **cftransaction integration** — ORM operations inside a `transaction {}` block participate in the database transaction. Commit flushes the session, rollback clears it
- **Savepoint support** — `transactionSetSavepoint()` works inside ORM transactions
- **Mixed ORM + raw SQL** — `entitySave()` and `queryExecute()` in the same transaction now share the same connection (fixed LDEV-6234, previously caused silent failures)

See [[orm-session-and-transactions]].

### Event Handling Changes

- **Entity events fire before global handler** — previously the global handler fired first. This lets entity-level handlers set values that the global handler can see (LDEV-4561)
- **Nullability check runs after event handlers** — `preInsert` and `preUpdate` can now set NOT NULL properties without triggering constraint violations. Previously Hibernate's null check ran before handlers had a chance to set values

See [[orm-events]].

### Other Fixes and Improvements

- **Property defaults apply on NULL load** — when loading an entity from the database, NULL columns now get the CFC `default` value applied (LDEV-4121)
- **Native logging bridge** — Hibernate's JBoss Logging is bridged to Lucee's log system. No more log4j configuration needed
- **Single connection per session** — the connection provider borrows one connection from Lucee's pool per session, preventing double-borrow issues (LDEV-6156)
- **Split schema export** — `dbcreate="dropcreate"` now runs DROP and CREATE as separate phases for better error reporting
- **Stricter HQL parsing** — Hibernate 5.6 is stricter about HQL syntax than 5.4. Common issues:
  - Implicit joins may need explicit `JOIN` syntax
  - Some previously-accepted invalid HQL may now throw parse errors
  - Entity and property names are case-sensitive in some contexts

## Coming in 7.2

Features deferred to the next major version will be listed here as they're identified.

## Migrating from Adobe ColdFusion

If you're moving an ACF application to Lucee, most ORM code works unchanged. Here are the key differences:

### Session Wrapper

ACF wraps the Hibernate session in `coldfusion.orm.hibernate.SessionWrapper`. To access the native Hibernate API, you need `.getActualSession()`:

```cfml
// ACF
nativeSession = ORMGetSession().getActualSession();

// Lucee — returns the native org.hibernate.Session directly
nativeSession = ORMGetSession();
```

If your code calls `.getActualSession()`, it will fail on Lucee. Remove the extra call.

### Transaction Detection

ACF has no built-in way to check if you're inside an ORM transaction. Common hacks include:

```cfml
// ACF hack — Java reflection
inTx = !isNull( createObject( "java", "coldfusion.tagext.sql.TransactionTag" ).getCurrent() );
```

On Lucee, use the built-in BIF: *(new in 5.6)*

```cfml
inTx = IsWithinORMTransaction();
```

### Hibernate Type Access

When using Hibernate's Criteria API or Restrictions directly:

```cfml
// ACF — needs .INSTANCE
import org.hibernate.criterion.Restrictions;
criteria.add( Restrictions.INSTANCE.eq( "name", "test" ) );

// Lucee — static fields are accessible directly
criteria.add( Restrictions::eq( "name", "test" ) );
```

### Logging

ACF uses log4j configuration for Hibernate logging. Lucee 5.6 has a native logging bridge — configure everything through ormSettings and Lucee's log system. See [[orm-logging]].

### Error Messages

Lucee wraps some Hibernate exceptions differently than ACF. The underlying error is the same, but the exception type and message format may differ. Check `cfcatch.cause` or `cfcatch.rootCause` to get the original Hibernate exception.

### autoManageSession

Both ACF and Lucee support `autoManageSession`, but the implementation details differ slightly. If you rely on specific session lifecycle timing, test thoroughly after migration.

## Migrating from Older Extension Versions

If you're upgrading from the 5.4 extension:

1. **Check HQL queries** — Hibernate 5.6 has stricter parsing. Test all HQL queries
2. **Check event handler order** — entity events now fire before global handlers
3. **Check NULL property defaults** — loading a NULL column now applies the CFC `default` value
4. **Check transaction behaviour** — ORM now participates in `cftransaction` blocks properly
5. **Update logging configuration** — the new logging settings replace any manual log4j setup

## What's Next?

- [[orm-configuration]] — all ormSettings including 5.6 additions
- [[orm-session-and-transactions]] — transaction integration details
- [[orm-events]] — event firing order changes
- [[orm-troubleshooting]] — common errors and fixes
