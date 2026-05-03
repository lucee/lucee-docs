<!--
{
  "title": "ORM - Configuration",
  "id": "orm-configuration",
  "categories": [
    "orm"
  ],
  "description": "Complete guide to ORM settings, schema management, naming strategies, and custom Hibernate mappings in Lucee",
  "related": [
    "orm-getting-started",
    "orm-entity-mapping",
    "orm-session-and-transactions",
    "orm-logging",
    "orm-caching",
    "tag-application"
  ]
}
-->

# ORM - Configuration

All ORM configuration lives in `this.ormSettings` inside your `Application.cfc`. This page covers every available setting, schema management modes, naming strategies, and custom Hibernate configuration.

For a minimal setup, see [[orm-getting-started]]. For logging-specific settings, see [[orm-logging]].

## Quick Reference

Here's a recommended starting point for development and production:

**Development:**

```cfml
this.ormSettings = {
	dbcreate: "dropcreate",
	cfclocation: [ "/models" ],
	logSQL: true,
	logParams: true,
	formatSQL: true,
	savemapping: true,
	flushAtRequestEnd: false
};
```

**Production:**

```cfml
this.ormSettings = {
	dbcreate: "none",
	cfclocation: [ "/models" ],
	dialect: "MySQL8",
	flushAtRequestEnd: false
};
```

> **Always set `flushAtRequestEnd: false` in production.** The default (`true`) means any entity you modify — even for display purposes — gets silently persisted at the end of the request. Use explicit `cftransaction` blocks instead. See [[orm-session-and-transactions]].

## Core Settings

### ormenabled

| Type | Default |
|------|---------|
| boolean | `false` |

Turns ORM on for this application. Must be `true` for any ORM functionality to work.

```cfml
this.ormEnabled = true;
```

> **Note:** This is set directly on `this`, not inside `this.ormSettings`.

### datasource

| Type | Default |
|------|---------|
| string | falls back to `this.datasource` |

Which datasource ORM uses. If omitted, ORM uses the application's default datasource.

```cfml
this.ormSettings = {
	datasource: "myOrmDb"
};
```

For using ORM with multiple datasources, see [[orm-session-and-transactions]].

### cfclocation

| Type | Default |
|------|---------|
| string or array | application root |

Directory or array of directories to scan for persistent CFCs. Paths are relative to the application root.

```cfml
this.ormSettings = {
	cfclocation: [ "/models", "/models/legacy" ]
};
```

If omitted, Lucee scans the entire application root — which works fine for small apps but slows startup on larger codebases.

Overlapping entries (e.g. parent and child directory both listed) are safe — the same CFC won't be registered twice. Hibernate extension 5.6.15.16+ dedupes by canonical file path, matching ACF ([LDEV-1697](https://luceeserver.atlassian.net/browse/LDEV-1697)). Two _different_ files sharing an `entityname` will still raise an ambiguity error.

Recursion ignores nested `Application.cfc` files — any persistent CFCs in subdirectories are scooped into the parent application's ORM, even if those subdirs declare their own application. ACF behaves the same way. Avoid pointing `cfclocation` at directories that contain unrelated apps.

### dialect

| Type | Default |
|------|---------|
| string | auto-detected |

The SQL dialect Hibernate uses for query generation. **Always set this explicitly** — auto-detection can fail with JTDS drivers or less common databases.

```cfml
this.ormSettings = {
	dialect: "MySQL8"
};
```

You can use short names or fully qualified class names:

| Short Name | Hibernate Dialect Class |
|------------|------------------------|
| `H2` | `org.hibernate.dialect.H2Dialect` |
| `MySQL` / `MySQL8` | `org.hibernate.dialect.MySQL8Dialect` |
| `MySQL57` | `org.hibernate.dialect.MySQL57Dialect` |
| `PostgreSQL` | `org.hibernate.dialect.PostgreSQLDialect` |
| `PostgreSQL10` | `org.hibernate.dialect.PostgreSQL10Dialect` |
| `SQLServer` | `org.hibernate.dialect.SQLServerDialect` |
| `SQLServer2012` | `org.hibernate.dialect.SQLServer2012Dialect` |
| `Oracle` | `org.hibernate.dialect.OracleDialect` |
| `Oracle12c` | `org.hibernate.dialect.Oracle12cDialect` |
| `DB2` | `org.hibernate.dialect.DB2Dialect` |
| `Derby` | `org.hibernate.dialect.DerbyDialect` |
| `MariaDB` | `org.hibernate.dialect.MariaDBDialect` |
| `MariaDB103` | `org.hibernate.dialect.MariaDB103Dialect` |
| `Informix` | `org.hibernate.dialect.InformixDialect` |
| `Sybase` | `org.hibernate.dialect.SybaseDialect` |

Many more are available — any non-abstract subclass of `org.hibernate.dialect.Dialect` in Hibernate 5.6 is supported. You can also pass a fully qualified class name for custom dialects.

### catalog

| Type | Default |
|------|---------|
| string | none |

Default database catalog for all entities. Can be overridden per-entity with the `catalog` component attribute.

### schema

| Type | Default |
|------|---------|
| string | none |

Default database schema for all entities. Can be overridden per-entity with the `schema` component attribute.

```cfml
this.ormSettings = {
	schema: "public"
};
```

## Schema Management

### dbcreate

| Type | Default |
|------|---------|
| string | `"none"` |

Controls how Hibernate manages your database schema on application startup.

| Value | Behaviour | Use Case |
|-------|-----------|----------|
| `"none"` | No schema management. Tables must exist | **Production** |
| `"update"` | Adds new tables/columns, never removes or renames | Prototyping, early development |
| `"dropcreate"` | Drops all mapped tables, then creates fresh | Development, test suites |
| `"create"` | Creates tables if they don't exist, ignores existing | First deployment *(new in 5.6, requires Lucee 7.0.4+)* |
| `"create-drop"` | Creates on startup, drops on shutdown | Temporary test environments *(new in 5.6, requires Lucee 7.0.4+)* |
| `"validate"` | Checks every mapped table exists, throws on mismatch | Staging, CI *(new in 5.6, requires Lucee 7.0.4+)* |

> **Warning:** `"dropcreate"` destroys all data on every application restart. Never use in production.

> **Note:** `"update"` only *adds* — it will never drop a column, rename a table, or change a column type. Don't rely on it for real migrations; use a dedicated migration tool.

> **Note:** `"validate"` currently checks table existence only — it does not validate individual columns or types. This is due to a limitation in Hibernate 5.6 (HHH-10882). On older Lucee versions, `"create"`, `"create-drop"`, and `"validate"` are not recognised and silently fall back to `"none"`.

### sqlscript

| Type | Default |
|------|---------|
| string (file path) | none |

Path to a SQL script that runs after ORM initialisation, regardless of `dbcreate` mode. Commonly used with `"dropcreate"` to seed test data, but executes for all modes including `"none"`. The script runs once per application start, after Hibernate's schema tool has finished.

```cfml
this.ormSettings = {
	dbcreate: "dropcreate",
	sqlScript: getDirectoryFromPath( getCurrentTemplatePath() ) & "seed.sql"
};
```

### savemapping

| Type | Default |
|------|---------|
| boolean | `false` |

When `true`, writes the generated `.hbm.xml` mapping files to disk alongside your entity CFCs. Invaluable for debugging mapping issues — inspect these files to see exactly what Hibernate thinks your entities look like.

```cfml
this.ormSettings = {
	savemapping: true
};
```

> **Dev only.** Don't leave this on in production — it writes files on every startup.

### autogenmap

| Type | Default |
|------|---------|
| boolean | `true` |

When `true` (the default), Lucee generates Hibernate mappings automatically from your CFC properties. Set to `false` if you're providing your own `.hbm.xml` mapping files.

### useDBForMapping

| Type | Default | ACF-compatible |
|------|---------|----------------|
| boolean | `true` | yes |

When `true`, Lucee inspects the database to determine column types, primary keys, and foreign keys. This helps Hibernate generate more accurate mappings but requires a database connection at startup.

## Session & Flush Settings

### flushAtRequestEnd

| Type | Default |
|------|---------|
| boolean | `true` |

When `true`, Lucee automatically flushes (persists) all dirty entities at the end of every request. This is **the most dangerous default in ORM** — any entity you load and modify gets silently saved, even if you only changed it for display purposes.

```cfml
// RECOMMENDED: always set to false
this.ormSettings = {
	flushAtRequestEnd: false
};
```

With `flushAtRequestEnd: false`, you control when persistence happens:

- Inside a `cftransaction` block (commit triggers flush)
- By calling `ormFlush()` explicitly

See [[orm-session-and-transactions]] for details.

### autoManageSession

| Type | Default |
|------|---------|
| boolean | `true` |

When `true`, Lucee manages the ORM session lifecycle: open, flush, clear, and close. When `false`, your application is responsible for managing the session. The session always closes at the end of the request regardless of this setting.

## Event Settings

### eventHandling

| Type | Default |
|------|---------|
| boolean | `false` |

Must be `true` for the global event handler CFC (`eventHandler`) to receive events. Entity-level event methods (`preInsert`, `postUpdate`, etc. defined directly in entity CFCs) fire regardless of this setting.

```cfml
this.ormSettings = {
	eventHandling: true
};
```

See [[orm-events]] for the full event lifecycle.

### eventHandler

| Type | Default |
|------|---------|
| string (CFC path) | none |

Path to a global event handler CFC. This CFC receives events for all entities — useful for cross-cutting concerns like audit logging.

```cfml
this.ormSettings = {
	eventHandling: true,
	eventHandler: "models.GlobalEventHandler"
};
```

See [[orm-events]] for the full list of global events.

## Cache Settings

### secondaryCacheEnabled

| Type | Default |
|------|---------|
| boolean | `false` |

Enables Hibernate's second-level (L2) cache. The L2 cache sits between the session cache (per-request) and the database, caching entity data across requests.

### cacheProvider

| Type | Default |
|------|---------|
| string | `"ehcache"` |

The cache implementation to use. Currently only `"ehcache"` is fully supported.

### cacheconfig

| Type | Default |
|------|---------|
| string (file path) | auto-generated |

Path to an `ehcache.xml` configuration file. Only used when `secondaryCacheEnabled` is `true`. If omitted, a default configuration is generated automatically.

```cfml
this.ormSettings = {
	secondaryCacheEnabled: true,
	cacheProvider: "ehcache",
	cacheconfig: "ehcache.xml"
};
```

See [[orm-caching]] for details on configuring entity and query caching.

## Logging Settings

*New in 5.6.* These settings control what Hibernate logs to the Lucee `orm` log. For full logging setup including log levels and the `orm.log` file, see [[orm-logging]].

### logSQL

| Type | Default |
|------|---------|
| boolean | `false` |

Logs SQL statements generated by Hibernate.

### logParams

| Type | Default | Lucee-only |
|------|---------|------------|
| boolean | `false` | yes |

Logs parameter bindings for SQL statements — shows the actual values being bound to `?` placeholders. Most useful alongside `logSQL`.

### logCache

| Type | Default | Lucee-only |
|------|---------|------------|
| boolean | `false` | yes |

Logs second-level cache and query cache activity — hits, misses, puts, evictions.

### logVerbose

| Type | Default | Lucee-only |
|------|---------|------------|
| boolean | `false` | yes |

Logs Hibernate internals — session lifecycle, entity loading, dirty checking. Produces a lot of output; use for targeted debugging only.

### formatSQL

| Type | Default | Lucee-only |
|------|---------|------------|
| boolean | `false` | yes |

Pretty-prints SQL in the log output. Makes long queries readable but has a small performance cost per statement.

```cfml
this.ormSettings = {
	logSQL: true,
	logParams: true,
	formatSQL: true
};
```

## Naming Strategies

### namingStrategy

| Type | Default |
|------|---------|
| string | `"default"` |

Controls how CFC names and property names are translated to table and column names.

| Value | Behaviour | Example |
|-------|-----------|---------|
| `"default"` | Uses names as-is | `MyEntity` → table `MyEntity`, `firstName` → column `firstName` |
| `"smart"` | Converts camelCase to UPPER_SNAKE_CASE | `MyEntity` → `MY_ENTITY`, `firstName` → `FIRST_NAME` |
| CFC path | Your own naming strategy CFC | Implement `convertTableName()` and `convertColumnName()` |

```cfml
this.ormSettings = {
	namingStrategy: "smart"
};
```

For a custom naming strategy, create a CFC that implements `convertTableName( name )` and `convertColumnName( name )`:

```cfml
// models/MyNaming.cfc
component {

	function convertTableName( name ) {
		return "tbl_" & lCase( arguments.name );
	}

	function convertColumnName( name ) {
		return lCase( arguments.name );
	}

}
```

```cfml
this.ormSettings = {
	namingStrategy: "models.MyNaming"
};
```

## Error Handling Settings

### skipCFCWithError

| Type | Default |
|------|---------|
| boolean | `false` |

When `true`, persistent CFCs that have mapping errors are silently skipped instead of throwing an error at startup. Can be useful when `cfclocation` includes directories with work-in-progress entities.

```cfml
this.ormSettings = {
	skipCFCWithError: true,
	cfclocation: [ "/models", "/models/experimental" ]
};
```

> **Use with caution.** Silent failures can mask real problems.

## External Hibernate Configuration

### ormconfig

| Type | Default |
|------|---------|
| string (file path) | none |

Path to an external `hibernate.cfg.xml` file. Settings from `this.ormSettings` take precedence over values in the XML. Connection information in the XML is ignored — Lucee always uses its own datasource pool.

```cfml
this.ormSettings = {
	dbcreate: "dropcreate",
	datasource: "h2",
	ormConfig: "hibernate.cfg.xml"
};
```

This is useful for advanced Hibernate configuration that isn't exposed through `ormSettings`, like custom type registrations or Hibernate-specific properties.

## Custom Hibernate Mappings

By default, Lucee generates Hibernate mapping XML from your CFC property attributes (`autogenmap: true`). For full control, you can provide your own `.hbm.xml` mapping files.

### Using .cfc.hbm.xml Files

Place a mapping file alongside your entity CFC with the naming convention `EntityName.cfc.hbm.xml`:

```
/models/
    User.cfc
    User.cfc.hbm.xml
```

When `savemapping: true`, Lucee writes the auto-generated mappings to disk in this format — a good starting point for customisation.

### Hybrid Approach

You can mix auto-generated and custom mappings. Set `autogenmap: true` (the default), and Lucee will use your `.hbm.xml` file when it exists, or generate mappings from CFC properties when it doesn't.

### Via hibernate.cfg.xml

You can also define mappings in an external `hibernate.cfg.xml` file via the `ormConfig` setting. This gives you access to the full Hibernate mapping DSL.

## All Settings at a Glance

| Setting | Type | Default | Lucee-only | Notes |
|---------|------|---------|------------|-------|
| `ormenabled` | boolean | `false` | no | Set on `this`, not in `ormSettings` |
| `datasource` | string | `this.datasource` | no | |
| `cfclocation` | string/array | app root | no | |
| `dbcreate` | string | `"none"` | no | `create`, `create-drop`, `validate` require Lucee 7.0.4+ |
| `dialect` | string | auto-detected | no | Always set explicitly |
| `catalog` | string | none | no | |
| `schema` | string | none | no | |
| `autogenmap` | boolean | `true` | no | |
| `useDBForMapping` | boolean | `true` | no | |
| `savemapping` | boolean | `false` | no | Dev only |
| `flushAtRequestEnd` | boolean | `true` | no | Recommend `false` |
| `autoManageSession` | boolean | `true` | no | |
| `eventHandling` | boolean | `false` | no | |
| `eventHandler` | string | none | no | |
| `secondaryCacheEnabled` | boolean | `false` | no | |
| `cacheProvider` | string | `"ehcache"` | no | |
| `cacheconfig` | string | auto-generated | no | |
| `logSQL` | boolean | `false` | no | |
| `logParams` | boolean | `false` | yes | *New in 5.6* |
| `logCache` | boolean | `false` | yes | *New in 5.6* |
| `logVerbose` | boolean | `false` | yes | *New in 5.6* |
| `formatSQL` | boolean | `false` | yes | *New in 5.6* |
| `namingStrategy` | string | `"default"` | no | `default`, `smart`, or CFC path |
| `skipCFCWithError` | boolean | `false` | no | |
| `sqlscript` | string | none | no | |
| `ormConfig` | string | none | no | Path to `hibernate.cfg.xml` |
