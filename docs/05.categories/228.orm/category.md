---
title: ORM
id: category-orm
categories:
- query
---

Lucee's ORM extension provides Object-Relational Mapping powered by Hibernate 5.6. Define persistent CFCs, map properties to database columns, and use built-in functions to create, read, update, and delete data without writing SQL.

## History

1. **Lucee core (Hibernate 3.5)** — ORM was originally built into Lucee core
2. **Extension extraction** — ORM was pulled out of core into a standalone extension
3. **Lucee 5.4 (beta)** — Lucee began upgrading to Hibernate 5.4 but it only reached beta
4. **Ortus fork** — Ortus Solutions forked the extension, completed the Hibernate 5.4 upgrade, and maintained it
5. **Lucee 5.6 (current)** — Lucee resumed active development, merging the Ortus work and upgrading to Hibernate 5.6 with native logging, transaction integration, and expanded test coverage

## Recipes

- [[orm-getting-started]] — Enable ORM, define an entity, CRUD operations
- [[orm-configuration]] — All ormSettings, schema management, naming strategies
- [[orm-entity-mapping]] — Entity properties, primary keys, inheritance
- [[orm-relationships]] — many-to-one, one-to-many, many-to-many, cascade, fetching
- [[orm-querying]] — HQL queries, entity loading, pagination, JOIN FETCH
- [[orm-session-and-transactions]] — Sessions, flush behaviour, transactions, multi-datasource
- [[orm-events]] — Entity lifecycle events and global event handlers
- [[orm-caching]] — Second-level cache and query cache
- [[orm-logging]] — SQL logging, debugging techniques
- [[orm-migration-guide]] — What's new in 5.6, migrating from ACF
- [[orm-troubleshooting]] — Common pitfalls, error messages, performance tips
