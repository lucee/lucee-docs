Executes an HQL (Hibernate Query Language) query. HQL operates on entity names and property names, not table and column names.

The function signature is flexible:

- `ORMExecuteQuery( hql )` — no params, returns array
- `ORMExecuteQuery( hql, params )` — params as struct (named) or array (positional)
- `ORMExecuteQuery( hql, unique )` — no params, returns single entity if `true`
- `ORMExecuteQuery( hql, params, unique )` — with params, returns single entity if `true`
- `ORMExecuteQuery( hql, params, unique, options )` — full form with query options

The `options` struct supports: `maxresults`, `offset`, `cacheable`, `cachename`, `timeout`, `datasource`.

`ORMQueryExecute()` is an alias for this function.

For bulk UPDATE/DELETE via HQL, entity lifecycle events do **not** fire. See [[orm-querying]] for full documentation.
