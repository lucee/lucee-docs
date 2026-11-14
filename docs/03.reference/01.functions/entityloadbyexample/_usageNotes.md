Creates a Hibernate query-by-example (QBE) using the provided entity instance. Any non-null property on the example entity is used as a filter criterion.

Set `unique` to `true` if you expect exactly one result — returns the entity directly instead of an array. Throws if multiple rows match.

Properties set to their default values (e.g. `0` for numeric, `""` for string) may be included in the filter, which can produce unexpected results. Only set the properties you want to filter on.
