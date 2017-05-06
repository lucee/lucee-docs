one of the following values:
			- query: default for all dbtype expect "hql", returns a query object
			- array_of_entity: works only with dbtype "hql" and is also the default value for dbtype "hql"
			- array: converts the query object into an array of structs
			- struct: converts the query object into a struct using the columnKey attribute as a primary key
