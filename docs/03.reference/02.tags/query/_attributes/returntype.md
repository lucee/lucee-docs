One of the following values:

- `query`: default for all dbtype expect "hql", returns a query object
- `array_of_entity`: works only with dbtype "hql" and is also the default value for dbtype "hql"
- `array`: converts the query object into an array of structs
- `struct`: returns either a struct of structs where the key is specified by the keyColumn attribute and each value is a struct with a query record, or a single record if keyColumn is not set, where each key is a column name and each value has its corresponding value
