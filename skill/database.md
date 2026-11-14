# Lucee skill: Database

Datasources, JDBC drivers, queries, query of queries, query listeners, connection pooling.

Fetch a recipe with `https://docs.lucee.org/recipes/<id>.md`. "Since" is the first Lucee version with the feature.

| ID | Title | Description | Since | Keywords |
|----|-------|-------------|-------|----------|
| `database-connection-management` | Database Connection Management in Lucee | Understanding how Lucee manages database connections: pooled, exclusive, and transaction-based connections | 5.0 | database, connection pool, datasource, transaction, exclusive connection, Apache Commons Pool, MySQL, connection pinning |
| `datasource-how-to-define-them` | Datasources | How to define a Datasource in Lucee. | - | Datasource, Define datasource, Administrator, Application.cfc, Default datasource, MySQL |
| `get-dbdriver-from-maven` | Get Datasource Drivers Directly from Maven | Learn how to get datasource drivers directly from Maven. | 6.1 | datasource, maven, mysql, snowflake, db |
| `lazy-queries` | Lazy Queries | How to stream large query result sets without loading everything into memory | - | Lazy Queries, Regular Queries, Performance, Memory Optimization, Lucee |
| `mssql-modern-mode` | MSSQL Modern Mode | How to enable and use MSSQL modern mode in Lucee for proper handling of RAISERROR exceptions and complex T-SQL batches | 5.3.8.169 | mssql, sql server, raiserror, deferred exceptions, modern mode, jdbc, stored procedures, t-sql |
| `query-of-queries-functions` | QoQ SQL Functions and Operators | Reference for the SQL keywords, operators, and functions supported by Lucee's native Query of Queries (QoQ) engine. | - | Query of Queries, QoQ, SQL, functions, operators, HSQLDB, Lucee |
| `query-async` | Query Async | Learn how to execute queries asynchronously in Lucee. This guide demonstrates how to set up asynchronous query execution using a simple flag. Examples include defining async execution for queries and using local listeners to handle exceptions. Additionally, function listeners introduced in Lucee 6.1 can be used for this purpose. | 6.0 | query, async, listener, thread |
| `query-handling` | Query Execution | Complete guide to executing database queries in Lucee with performance comparisons and best practices | - | cfquery, queryExecute, Query, database, parameters, performance, SQL, prepared statements |
| `query-indexes` | Query Indexes | Learn how to set and use indexes for query results in Lucee. This guide demonstrates how to define a query with an index and access parts of the query using the index. | 6.0 | query, indexes, cfquery, queryRowByIndex, column index, result set, queryGetCellByIndex |
| `query-listener` | Query Listeners | Learn how to define query listeners in Lucee. This guide demonstrates how to set up global query listeners in the Application.cfc file to listen to or manipulate every query executed. Examples include defining listeners directly in Application.cfc and using a component as a query listener. | 6.0 | query, listener, Lucee, Application.cfc, component |
| `query-of-queries` | Query of Queries (QoQ) | Query of queries (QoQ) is a technique for re-querying an existing (in memory) query without another trip to the database. | - | Query of Queries, QoQ, SQL, In memory query, Lucee, dbtype query |
| `query-of-query-sometime` | Query of Queries sometimes it rocks, sometimes it sucks | This document explains why Query of Queries (QoQ) may or may not be the best approach for your use case. | - | Query of Queries, QoQ, Performance, Query Filter, Query Sort, Lucee |
| `query-result-threshold` | Query Result Logging | Monitor and log database queries that return large result sets to prevent OutOfMemory errors | 6.2.3.15 | query, logging, monitoring, performance, OOM, OutOfMemory, database, threshold |
| `query-return-type` | Query return type | This document explains the different return types for a query with some examples. | - | Query return type, Array return type, Struct return type, Foreign key, Lucee |
| `sql-types` | SQL Types | SQL types for query parameters | - | SQL, SQL types, CF_SQL, queryparam, queryexecute, cfsqltype |
