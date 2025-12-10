<!--
{
  "title": "Database Connection Management in Lucee",
  "id": "database-connection-management",
  "since": "5.0",
  "categories": ["database", "performance"],
  "description": "Understanding how Lucee manages database connections: pooled, exclusive, and transaction-based connections",
  "keywords": [
    "database",
    "connection pool",
    "datasource",
    "transaction",
    "exclusive connection",
    "Apache Commons Pool",
    "MySQL",
    "connection pinning"
  ],
  "related": [
    "cfconfig",
    "cftransaction",
    "datasource-configuration",
    "tag-query",
    "function-dbpoolevict"
  ]
}
-->

# Database Connection Management in Lucee

Lucee uses Apache Commons Pool 2 to manage database connections efficiently. Understanding how Lucee handles connections is crucial for optimal performance and for working with connection-sensitive features like AWS RDS Proxy.

This document explains the three types of database connections in Lucee and when to use each approach.

## Overview

Lucee provides three distinct connection management patterns:

1. **Pooled Connections** (Default) - Shared across requests for maximum efficiency
2. **Exclusive Connections** - Dedicated connection per request when needed
3. **Transaction Connections** - Automatically exclusive within transaction blocks

Each pattern serves specific use cases and has different performance characteristics.

## Connection Pool Architecture

Lucee uses Apache Commons Pool 2 to maintain a pool of database connections that can be reused across multiple requests. This provides significant performance benefits by avoiding the overhead of establishing new connections for each database operation.

### How the Connection Pool Works

1. When a query executes, Lucee requests a connection from the pool
2. The query runs using this connection
3. After the query completes, the connection returns to the pool
4. Subsequent queries may receive the same connection or a different one from the pool
5. Connections remain open and available for reuse

This approach maximizes resource efficiency and throughput for typical web applications.

## Connection Types

### 1. Pooled Connections (Default)

**Behavior**: Connections are shared across requests and returned to the pool after each query.

**Use Case**: The default choice for most applications. Provides the best performance and resource utilization.

**Configuration in Application.cfc**:

```javascript
// Standard datasource configuration
this.datasources["mydb"] = {
    class: "com.mysql.cj.jdbc.Driver",
    bundleName: "com.mysql.cj",
    bundleVersion: "9.5.0",
    connectionString: "jdbc:mysql://localhost:3306/mydb?characterEncoding=UTF-8&serverTimezone=UTC",
    username: "dbuser",
    password: "dbpass"
    // requestExclusive is false by default
};
```

**Configuration in .CFConfig.json**:

```json
{
    "datasources": {
        "stateful_db": {
            "class": "com.mysql.cj.jdbc.Driver",
            "bundleName": "com.mysql.cj",
            "bundleVersion": "9.5.0",
            "connectionString": "jdbc:mysql://localhost:3306/mydb?characterEncoding=UTF-8&serverTimezone=UTC",
            "username": "dbuser",
            "password": "dbpass"
        }
    }
}
```

**Characteristics**:

- Maximum connection reuse across requests
- Optimal performance for stateless queries
- Connection state is not guaranteed between queries
- Best compatibility with connection proxies (like AWS RDS Proxy)

**Example**:

```javascript
// Each query may use a different connection from the pool
queryExecute("SELECT * FROM users WHERE active = 1");
queryExecute("SELECT * FROM products WHERE in_stock = 1");
queryExecute("INSERT INTO audit_log (action, timestamp) VALUES (?, ?)", 
    ["user_login", now()]);
```

### 2. Exclusive Connections

**Behavior**: Each web request receives a dedicated connection that persists for the entire request lifecycle.

**Use Case**: Required when your application needs to maintain connection-specific state across multiple queries within a request.

**Configuration in Application.cfc**:

```javascript
this.datasources["stateful_db"] = {
    class: "com.mysql.cj.jdbc.Driver",
    bundleName: "com.mysql.cj",
    bundleVersion: "9.5.0",
    connectionString: "jdbc:mysql://localhost:3306/mydb?characterEncoding=UTF-8&serverTimezone=UTC",
    username: "dbuser",
    password: "dbpass",
    requestExclusive: true  // Enable exclusive connections
};
```

**Configuration in .CFConfig.json**:

```json
{
    "datasources": {
        "stateful_db": {
            "class": "com.mysql.cj.jdbc.Driver",
            "bundleName": "com.mysql.cj",
            "bundleVersion": "9.5.0",
            "connectionString": "jdbc:mysql://localhost:3306/mydb?characterEncoding=UTF-8&serverTimezone=UTC",
            "username": "dbuser",
            "password": "encrypted:...",
            "requestExclusive": true
        }
    }
}
```

**When to Use Exclusive Connections**:

1. **Session Variables**: When using MySQL session variables that need to persist across queries
2. **Temporary Tables**: When creating session-specific temporary tables
3. **Connection Settings**: When setting connection-level configuration with `SET` commands
4. **Custom Collations**: When temporarily changing connection collation
5. **Lock Management**: When using connection-level locks

**Example**:

```javascript
// All queries in this request use the same connection
queryExecute("SET @user_role = ?", ["admin"]);
queryExecute("SET @department_id = ?", [42]);

// These queries can reference the session variables
queryExecute("
    SELECT * FROM documents 
    WHERE department_id = @department_id 
    AND required_role = @user_role
");

// Session variable persists throughout the request
queryExecute("
    INSERT INTO audit_log (user_role, action) 
    VALUES (@user_role, 'document_access')
");
```

**Important Considerations**:

- **Performance Impact**: Exclusive connections limit concurrent requests to the number of available connections
- **Connection Exhaustion**: Can lead to more open connections and potential pool exhaustion under high load
- **Proxy Compatibility**: May cause connection pinning issues with connection proxies like AWS RDS Proxy
- **Use Sparingly**: Only enable when absolutely necessary for your use case

### 3. Transaction Connections

**Behavior**: Automatically provides an exclusive connection for the duration of the transaction block.

**Use Case**: Any time you use `<cftransaction>` or need ACID guarantees across multiple queries.

**Why Automatic**:

Transactions require non-atomic operations across multiple queries. To ensure all queries within a transaction execute on the same connection with consistent state, Lucee automatically:

1. Requests an exclusive connection when the transaction begins
2. Sets `autocommit` to `false` on that connection
3. Maintains that connection for all queries within the transaction
4. Returns the connection to the pool only after the transaction completes (commit or rollback)

**Configuration**: No special configuration needed. This behavior is automatic for all datasources.

**Example**:

```javascript
transaction {
    try {
        // All queries use the same connection with autocommit=false
        queryExecute("
            UPDATE accounts 
            SET balance = balance - ? 
            WHERE account_id = ?
        ", [100, accountFrom]);
        
        queryExecute("
            UPDATE accounts 
            SET balance = balance + ? 
            WHERE account_id = ?
        ", [100, accountTo]);
        
        queryExecute("
            INSERT INTO transactions (from_account, to_account, amount) 
            VALUES (?, ?, ?)
        ", [accountFrom, accountTo, 100]);
        
        // Transaction commits automatically if no errors
        transaction action="commit";
        
    } catch (any e) {
        // Transaction rolls back automatically on error
        transaction action="rollback";
        rethrow;
    }
}
// Connection returns to pool here
```

**Transaction Isolation Levels**:

```javascript
// Specify isolation level for the transaction
transaction isolation="read_committed" {
    // Queries here execute with READ COMMITTED isolation
    queryExecute("SELECT * FROM accounts WHERE account_id = ?", [accountId]);
}

// Available isolation levels:
// - read_uncommitted
// - read_committed (most common)
// - repeatable_read
// - serializable
```

**Key Characteristics**:

- **Automatic**: No configuration required
- **ACID Compliance**: Ensures atomicity, consistency, isolation, and durability
- **Connection Locking**: Connection held exclusively until transaction completes
- **Error Handling**: Automatic rollback on exceptions
- **Autocommit Behavior**: This is what generates `SET autocommit=0` commands visible in connection logs

## Connection Pinning and Proxy Compatibility

When working with connection proxies like AWS RDS Proxy, understanding connection management becomes critical.

### What is Connection Pinning?

Connection pinning occurs when a proxy must maintain a specific client-to-database connection mapping, preventing the proxy from multiplexing connections efficiently. This happens when:

1. Connection-specific state is set (via `SET` commands)
2. Session variables are used
3. Temporary tables are created
4. `autocommit` is changed (which happens in transactions)

### Common Pinning Triggers in Lucee

Based on production observations, the most common pinning triggers are:

1. **Transaction Blocks**: `SET autocommit=0` and `SET autocommit=1`
2. **Session Variables**: `SET @variable_name = value`
3. **Character Set Changes**: `SET NAMES utf8mb4`
4. **Timezone Changes**: `SET time_zone = 'UTC'`
5. **System Variable Queries**: `SELECT @@session.variable_name`

### Minimizing Connection Pinning

**Best Practices**:

1. **Use Pooled Connections**: Avoid `requestExclusive=true` unless absolutely necessary
2. **Limit Transaction Scope**: Keep transaction blocks as short as possible
3. **Avoid Session Variables**: Use application variables or query parameters instead
4. **Set Connection Defaults**: Configure character sets and timezones in the connection string
5. **Monitor Pinning**: Track pinning metrics in your proxy logs

**Example - Optimized Connection String**:

```javascript
this.datasources["optimized_db"] = {
    class: "com.mysql.cj.jdbc.Driver",
    bundleName: "com.mysql.cj",
    bundleVersion: "9.5.0",
    connectionString: "jdbc:mysql://my-rds-proxy.proxy-xxx.us-east-1.rds.amazonaws.com:3306/mydb" &
        "?characterEncoding=UTF-8" &
        "&serverTimezone=UTC" &
        "&useServerPrepStmts=true" &
        "&cachePrepStmts=true" &
        "&prepStmtCacheSize=250" &
        "&prepStmtCacheSqlLimit=2048",
    username: "dbuser",
    password: "dbpass"
    // requestExclusive: false (default - best for proxy compatibility)
};
```

## Performance Comparison

| Connection Type | Concurrency | State Persistence | Proxy Friendly | Use Frequency |
|----------------|-------------|-------------------|----------------|---------------|
| Pooled | High | No | Yes | Default |
| Exclusive | Limited | Yes | No | Rare |
| Transaction | Medium | Within block | Partial | As needed |

## Monitoring Connection Usage

### Checking Active Connections

```javascript
// Get datasource information
admin = new Administrator("web", "admin_password");
datasources = admin.getDatasources();

// Check connection pool statistics
writeOutput("<h3>Connection Pool Statistics</h3>");
for (var dsName in datasources) {
    var ds = datasources[dsName];
    writeDump(var=ds, label="Datasource: #dsName#");
}
```

## Troubleshooting

### Problem: Connection Pool Exhaustion

**Symptoms**: Requests timeout waiting for connections

**Causes**:

- Too many exclusive connections enabled
- Long-running transactions holding connections
- Connection leaks (connections not properly returned)

**Solutions**:

```javascript
// Increase pool size if needed
this.datasources["mydb"].connectionLimit = 50;

// Set connection timeout
this.datasources["mydb"].connectionTimeout = 30000; // 30 seconds

```

### Problem: "Commands out of sync" Error

**Symptoms**: MySQL error "Commands out of sync; you can't run this command now"

**Cause**: Mixing result set streaming with connection reuse

**Solution**: Ensure all result sets are fully consumed before the connection returns to the pool

```javascript
// Process all results completely
var qryResults = queryExecute("SELECT * FROM large_table");
loop query=qryResults {
    // Process each row
}
// Now safe to return connection to pool
```

## Best Practices

1. **Default to Pooled Connections**: Use the standard connection pool unless you have a specific need for exclusive or transaction connections

2. **Keep Transactions Short**: Only include necessary queries within transaction blocks to minimize connection holding time

3. **Configure Connection Strings Properly**: Set character encodings, timezones, and other settings in the connection string rather than via `SET` commands

4. **Monitor Your Connection Pool**: Track active connections, pool exhaustion events, and connection wait times

5. **Test Under Load**: Verify your connection configuration performs well under realistic production load

6. **Document Exclusive Usage**: If you must use `requestExclusive=true`, document why it's necessary and which queries require it

7. **Use Connection Limits Wisely**: Set `connectionLimit` based on your database server's capacity and expected concurrent load

8. **Handle Transactions Properly**: Always use try/catch blocks to ensure transactions are properly committed or rolled back

## Related Resources

- [CFTransaction Reference](https://docs.lucee.org/reference/tags/transaction.html)
- [Apache Commons Pool Documentation](https://commons.apache.org/proper/commons-pool/)
- [AWS RDS Proxy Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html)

## Summary

Understanding Lucee's three connection management patterns is essential for building efficient, scalable applications:

- **Pooled connections** provide the best performance and should be your default choice
- **Exclusive connections** enable stateful operations but should be used sparingly due to performance implications
- **Transaction connections** are automatically exclusive and handle ACID requirements transparently

Choose the right connection type for each datasource based on your specific requirements, and always consider the implications for connection pooling, concurrency, and proxy compatibility.