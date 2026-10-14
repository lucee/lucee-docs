`entityLoad()` has multiple call signatures:

- `entityLoad( entityName )` — returns an array of all entities
- `entityLoad( entityName, id )` — loads by primary key (same as [[function-entityloadbypk]])
- `entityLoad( entityName, filterStruct )` — returns an array filtered by property values (AND logic)
- `entityLoad( entityName, filterStruct, sortOrder )` — filtered and sorted
- `entityLoad( entityName, filterStruct, sortOrder, options )` — with pagination and caching

The `options` struct supports: `maxresults`, `offset`, `ignorecase`, `cacheable`, `cachename`, `timeout`.

Filter values are combined with AND. For OR logic or more complex queries, use [[function-ormexecutequery]] with HQL.

See [[orm-querying]] for full details.
