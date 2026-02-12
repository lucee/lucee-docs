<!--
{
  "title": "DynamoDB Cache Extension",
  "id": "dynamodb-cache-extension",
  "since": "7.0",
  "categories": ["cache", "aws", "dynamodb"],
  "description": "Documentation for using Amazon DynamoDB as a cache provider and NoSQL data store in Lucee",
  "keywords": [
    "DynamoDB",
    "Cache",
    "AWS",
    "NoSQL",
    "Distributed Cache",
    "Cloud Storage",
    "Maven",
    "DynamoDBCommand"
  ],
  "related": [
    "cache-functions",
    "s3-extension"
  ]
}
-->

# DynamoDB Cache Extension

The DynamoDB Cache Extension enables Lucee applications to use Amazon DynamoDB as a distributed cache provider and NoSQL data store. This powerful combination provides a highly scalable, fully managed solution with automatic table creation, TTL support, seamless integration with Lucee's cache functions, and direct DynamoDB operations via the `DynamoDBCommand()` function.

## Overview

DynamoDB is Amazon's fully managed NoSQL database service that provides fast and predictable performance with seamless scalability. By using DynamoDB as a cache backend, your Lucee applications can benefit from:

- **Dual access mode** — use standard Lucee cache functions or native DynamoDB commands
- **Distributed caching** across multiple application servers
- **Automatic scalability** to handle varying loads
- **Built-in replication** for high availability
- **Pay-per-use billing** with on-demand capacity mode
- **Automatic table creation** — no manual setup required
- **Dynamic Primary Key discovery** — auto-detects existing table partition keys
- **TTL support** for automatic cache expiration
- **Session and scope storage** — offload session or client data to a durable cloud layer
- **Maven-based dependency management** (no OSGi complexity)
- **AWS SDK v2** — built on the latest asynchronous-capable Java SDK

## Requirements

- **Lucee 7.0 or higher** (requires Maven-based extension support)
- **AWS Account** with DynamoDB access (or DynamoDB Local for development/testing)
- **AWS Credentials** with appropriate DynamoDB permissions (not required when running on EC2/ECS with IAM roles)

## Installation

### Via Lucee Admin

1. Navigate to **Extension > Applications** in your Lucee Administrator
2. Search for "DynamoDB"
3. Click **Install** on the DynamoDB Cache extension
4. Restart Lucee if prompted

### Via Application.cfc

Configure the cache at the application level in your `Application.cfc`:

```javascript
this.name = "myApp";

this.caches = {
    "dynamo": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.7-RC",
        "storage": false,
        "custom": {
            "tableName": "my_cache_table",
            "accessKeyId": "${AWS_ACCESS_KEY_ID}",
            "secretkey": "${AWS_SECRET_ACCESS_KEY}",
            "primaryKey": "pk",
            "region": "us-east-1",
            "liveTimeout": 3600000,
            "log": "application"
        },
        "default": ""
    }
};
```

### Via .CFConfig.json

For server-wide configuration, add the cache definition to your `.CFConfig.json` file located at `{lucee-server}/context/.CFConfig.json`:

```json
{
  "caches": {
    "dynamo": {
      "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
      "maven": "org.lucee:dynamodb:1.0.0.7-RC",
      "custom": {
        "tableName": "prod_cache",
        "accessKeyId": "${AWS_ACCESS_KEY_ID}",
        "secretkey": "${AWS_SECRET_ACCESS_KEY}",
        "primaryKey": "pk",
        "region": "us-east-1",
        "liveTimeout": 5000,
        "log": "dynamodb"
      },
      "readOnly": false,
      "storage": false
    }
  }
}
```

**Note**: The `${VARIABLE_NAME}` syntax allows you to reference environment variables, making it easy to keep credentials secure and environment-specific without hardcoding them in configuration files.

### Configuration Method Comparison

| Method | Scope | Use Case |
|--------|-------|----------|
| Lucee Admin | Server/Web | GUI-based configuration, quick setup |
| Application.cfc | Application | Application-specific cache, portable with code |
| .CFConfig.json | Server | Server-wide default, infrastructure-as-code, environment variables |

## Configuration Options

### Required Settings

| Parameter | Type | Description |
|-----------|------|-------------|
| `tableName` | String | The name of the DynamoDB table to use for caching. The table will be created automatically if it doesn't exist. |

### Authentication Settings

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `accessKeyId` | String | No* | AWS Access Key ID for authentication. Leave empty when running on EC2/ECS with IAM roles. For DynamoDB Local testing, you can use any dummy value like `'dummy'`. |
| `secretkey` | String | No* | AWS Secret Access Key for authentication. Leave empty when running on EC2/ECS with IAM roles. For DynamoDB Local testing, you can use any dummy value like `'dummy'`. |

*Not required when running on EC2/ECS with IAM roles, but required for local development or external access.

### Custom Endpoint Settings

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `region` | String | No | AWS region where the DynamoDB table is located (e.g., `'us-east-1'`, `'eu-west-1'`). If not specified, the default region from your AWS configuration will be used. |
| `host` | String | No | Custom endpoint URL for DynamoDB. Use `'http://localhost:8000'` for DynamoDB Local testing. Leave empty to use the standard AWS DynamoDB endpoints. |

### Primary Key Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `primaryKey` | String | `"cacheKey"` | The name of the partition key attribute for the DynamoDB table. If the table already exists, the extension auto-detects the existing partition key name, so this setting is only used when creating a new table. |

### General Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `liveTimeout` | Number | 3600000 | Connection timeout in milliseconds for DynamoDB operations. |
| `log` | String | `"application"` | Name of the log file where cache operations and errors will be recorded. Set to `'application'` to use the default application log, or specify a custom log name (e.g., `'dynamodb-cache'`). |
| `storage` | Boolean | `false` | When set to `true`, allows this cache to be used as storage for Lucee's session or client scopes. See [Session & Scope Storage](#session--scope-storage). |

## Configuration Examples

### Production Configuration (AWS)

```javascript
this.caches = {
    "dynamo": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.7-RC",
        "storage": false,
        "custom": {
            "tableName": "prod_cache",
            "accessKeyId": getSystemSetting("AWS_ACCESS_KEY_ID"),
            "secretkey": getSystemSetting("AWS_SECRET_ACCESS_KEY"),
            "primaryKey": "pk",
            "region": "us-east-1",
            "liveTimeout": 5000,
            "log": "dynamodb"
        },
        "default": ""
    }
};
```

### Development Configuration (DynamoDB Local)

```javascript
this.caches = {
    "dynamo": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.7-RC",
        "storage": false,
        "custom": {
            "tableName": "dev_cache",
            "accessKeyId": "dummy",
            "secretkey": "dummy",
            "primaryKey": "pk",
            "region": "us-east-1",
            "host": "http://localhost:8000",
            "liveTimeout": 3600000,
            "log": "application"
        },
        "default": ""
    }
};
```

### EC2/ECS Configuration (IAM Roles)

When running on EC2 or ECS with IAM roles, you don't need to provide credentials:

```javascript
this.caches = {
    "dynamo": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.7-RC",
        "storage": false,
        "custom": {
            "tableName": "app_cache",
            "region": "us-east-1",
            "log": "dynamodb"
        },
        "default": ""
    }
};
```

## Access Models

The extension provides two ways to interact with your data, depending on your use case.

### 1. Lucee Cache Interface (High-Level)

This treats DynamoDB as a standard Lucee cache. It is ideal for query caching, session storage, or storing complex CFML objects. Once configured, you can use all standard Lucee cache functions with your DynamoDB cache.

### 2. Native Command API (Direct Access)

For advanced NoSQL patterns, the extension provides the `DynamoDBCommand()` function. This allows you to perform operations that the standard cache interface cannot express, such as atomic increments, complex queries, scans with filters, and direct item manipulation. See [DynamoDBCommand() Reference](#dynamodbcommand-reference) for full details.

## Usage — Lucee Cache Interface

### Basic Operations

#### Store Data in Cache

```javascript
// Simple string value
cachePut(id="user_session_123", value="active", cacheName="dynamo");

// Complex data structures
var userData = {
    "name": "John Doe",
    "email": "john@example.com",
    "preferences": {
        "theme": "dark",
        "notifications": true
    }
};
cachePut(id="user_profile_456", value=userData, cacheName="dynamo");

// With expiration (5 minutes)
cachePut(
    id="temporary_token", 
    value="abc123xyz", 
    timeSpan=createTimeSpan(0,0,5,0),
    cacheName="dynamo"
);
```

#### Retrieve Data from Cache

```javascript
// Get value (throws error if not found)
var sessionData = cacheGet(id="user_session_123", cacheName="dynamo");

// Get value with default
var userData = cacheGet(
    id="user_profile_456", 
    throwWhenNotExist=false,
    cacheName="dynamo"
);

// Check if exists before getting
if(cacheIdExists(id="user_session_123", cacheName="dynamo")) {
    var session = cacheGet(id="user_session_123", cacheName="dynamo");
}
```

#### Delete from Cache

```javascript
// Delete single item
cacheDelete(id="user_session_123", cacheName="dynamo");

// Clear all items matching a pattern
cacheClear(filter="user_session_*", cacheName="dynamo");

// Clear entire cache
cacheClear(cacheName="dynamo");
```

### Advanced Operations

#### Working with Multiple Items

```javascript
// Get all cache IDs
var allIds = cacheGetAllIds(cacheName="dynamo");

// Get IDs matching a pattern
var userSessions = cacheGetAllIds(filter="user_session_*", cacheName="dynamo");

// Get all values matching a pattern
var allUserData = cacheGetAll(filter="user_*", cacheName="dynamo");
// Returns a struct: { "user_123": {...}, "user_456": {...}, ... }

// Count cache items
var totalItems = cacheCount(cacheName="dynamo");
```

#### Cache Metadata

```javascript
// Get metadata for a cache entry
var metadata = cacheGetMetadata(id="user_profile_456", cacheName="dynamo");

// Metadata includes:
// - hitCount: number of times accessed
// - timeToLive: remaining time before expiration
// - lastAccessed: last access timestamp
// - lastModified: last modification timestamp
// - created: creation timestamp
```

### Data Type Support

The DynamoDB cache extension supports all native Lucee data types:

```javascript
// Strings
cachePut(id="key1", value="Simple string", cacheName="dynamo");

// Numbers
cachePut(id="key2", value=12345.67, cacheName="dynamo");

// Booleans
cachePut(id="key3", value=true, cacheName="dynamo");

// Dates
cachePut(id="key4", value=now(), cacheName="dynamo");

// Arrays
cachePut(id="key5", value=[1, "two", 3.0, true], cacheName="dynamo");

// Structs
cachePut(id="key6", value={
    "name": "Product",
    "price": 99.99,
    "inStock": true,
    "tags": ["featured", "sale"]
}, cacheName="dynamo");

// Queries
var qryData = queryNew("id,name", "integer,varchar", [[1,"Alice"],[2,"Bob"]]);
cachePut(id="key7", value=qryData, cacheName="dynamo");
```

## DynamoDBCommand() Reference

The `DynamoDBCommand()` function provides direct access to DynamoDB operations, going beyond what the standard cache interface offers. It reuses the connection and table configuration from your cache definition.

### Syntax

```javascript
result = DynamoDBCommand(action, data [, cacheName]);
```

| Argument | Type | Required | Description |
|----------|------|----------|-------------|
| `action` | String | Yes | The DynamoDB operation to perform. See supported actions below. |
| `data` | Struct | Yes | The operation parameters (keys, expressions, values, etc.). |
| `cacheName` | String | No | The name of the DynamoDB cache connection to use. If omitted, the default cache is used. |

### Supported Actions

#### putItem

Writes a complete item to the table. The struct you pass becomes the item; include the partition key attribute.

```javascript
// Insert a new item
DynamoDBCommand("putItem", {
    "pk": "user_001",
    "name": "Urs",
    "age": 30,
    "active": true
}, "dynamo");

// With ReturnValues to get the previous item
previous = DynamoDBCommand("putItem", {
    "pk": "user_001",
    "name": "Urs",
    "age": 31,
    "ReturnValues": "ALL_OLD"
}, "dynamo");
```

#### getItem

Retrieves a single item by its primary key. Returns a struct, or `null` if the item doesn't exist.

```javascript
// Get an item by primary key
user = DynamoDBCommand("getItem", {
    "pk": "user_001"
}, "dynamo");
```

#### updateItem

Updates specific attributes of an existing item without replacing the entire item. Supports atomic operations like incrementing counters.

```javascript
// Atomic increment — no read-modify-write cycle needed
result = DynamoDBCommand("updateItem", {
    "key": { "pk": "user_001" },
    "UpdateExpression": "SET age = age + :inc",
    "ExpressionAttributeValues": { ":inc": 1 },
    "ReturnValues": "UPDATED_NEW"
}, "dynamo");

// Update multiple attributes
result = DynamoDBCommand("updateItem", {
    "key": { "pk": "user_001" },
    "UpdateExpression": "SET #n = :name, active = :status",
    "ExpressionAttributeNames": { "#n": "name" },
    "ExpressionAttributeValues": { ":name": "Urs Updated", ":status": true },
    "ReturnValues": "UPDATED_NEW"
}, "dynamo");
```

**Supported parameters for updateItem:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `key` | Struct | The primary key of the item to update (required). |
| `UpdateExpression` | String | A DynamoDB update expression (e.g., `"SET age = age + :inc"`). |
| `ExpressionAttributeValues` | Struct | Placeholder values used in the expression. |
| `ExpressionAttributeNames` | Struct | Placeholder names for reserved words in the expression. |
| `ReturnValues` | String | What to return: `"NONE"`, `"UPDATED_OLD"`, `"UPDATED_NEW"`, `"ALL_OLD"`, `"ALL_NEW"`. |

#### deleteItem

Deletes an item by its primary key. Optionally returns the deleted item.

```javascript
// Simple delete
DynamoDBCommand("deleteItem", {
    "pk": "user_001"
}, "dynamo");

// Delete and return the old item
deleted = DynamoDBCommand("deleteItem", {
    "pk": "user_001",
    "ReturnValues": "ALL_OLD"
}, "dynamo");
```

#### query

Retrieves items that match a key condition. Use this when you know the partition key and optionally want to filter by sort key. Returns an array of structs.

```javascript
// Query by partition key
results = DynamoDBCommand("query", {
    "KeyConditionExpression": "pk = :userId",
    "ExpressionAttributeValues": { ":userId": "user_001" }
}, "dynamo");

// Query with filter expression
results = DynamoDBCommand("query", {
    "KeyConditionExpression": "pk = :userId",
    "FilterExpression": "age > :minAge",
    "ExpressionAttributeValues": {
        ":userId": "user_001",
        ":minAge": 18
    }
}, "dynamo");

// Query a Global Secondary Index
results = DynamoDBCommand("query", {
    "IndexName": "email-index",
    "KeyConditionExpression": "email = :email",
    "ExpressionAttributeValues": { ":email": "urs@example.com" }
}, "dynamo");
```

**Supported parameters for query:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `KeyConditionExpression` | String | The key condition (required). |
| `ExpressionAttributeValues` | Struct | Placeholder values used in expressions. |
| `FilterExpression` | String | Additional server-side filtering applied after the key condition. |
| `IndexName` | String | Name of a Global or Local Secondary Index to query. |

#### scan

Reads every item in the table (or index), optionally applying a filter. Returns an array of structs. Use sparingly on large tables.

```javascript
// Scan entire table
allItems = DynamoDBCommand("scan", {}, "dynamo");

// Scan with filter
activeUsers = DynamoDBCommand("scan", {
    "FilterExpression": "active = :status",
    "ExpressionAttributeValues": { ":status": true }
}, "dynamo");

// Scan with limit
sample = DynamoDBCommand("scan", {
    "Limit": 10
}, "dynamo");

// Scan a Global Secondary Index
results = DynamoDBCommand("scan", {
    "IndexName": "status-index",
    "FilterExpression": "age > :minAge",
    "ExpressionAttributeValues": { ":minAge": 25 }
}, "dynamo");
```

**Supported parameters for scan:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `FilterExpression` | String | Server-side filter applied to results. |
| `ExpressionAttributeValues` | Struct | Placeholder values used in the filter. |
| `IndexName` | String | Name of a Global or Local Secondary Index to scan. |
| `Limit` | Number | Maximum number of items to evaluate (before filtering). |

## Time-To-Live (TTL) and Expiration

The DynamoDB extension fully supports cache expiration using DynamoDB's native TTL feature.

### Setting Expiration

```javascript
// Expire after 1 hour
cachePut(
    id="session_token",
    value="xyz789",
    timeSpan=createTimeSpan(0,1,0,0),
    cacheName="dynamo"
);

// Expire at specific time
var expirationDate = dateAdd("h", 2, now());
cachePut(
    id="scheduled_job",
    value=jobData,
    until=expirationDate,
    cacheName="dynamo"
);

// Idle timeout (expires if not accessed)
cachePut(
    id="idle_session",
    value=sessionData,
    idleTime=1800000, // 30 minutes in milliseconds
    cacheName="dynamo"
);
```

### TTL Behavior

When using `cachePut()` with a `timeSpan`, the extension automatically calculates the epoch timestamp and stores it. If TTL is enabled on your DynamoDB table (on the attribute named `timeToLive`), AWS will automatically expire items at no extra cost.

- TTL is automatically enabled when the table is created by the extension
- Expired items are automatically deleted by DynamoDB (typically within 48 hours of expiration)
- The cache checks for expiration on read operations
- Expired items won't be returned by cache operations even if not yet deleted by DynamoDB

## Primary Key Discovery

The extension is designed to be "plug-and-play" with existing DynamoDB tables. During initialization, it describes the target table to discover the partition key name:

- **If the table exists**, the extension adopts the existing partition key name automatically — no configuration needed.
- **If the table does not exist**, the extension creates one using the `primaryKey` setting from your configuration (defaulting to `cacheKey`).

This means you can point the extension at any existing DynamoDB table regardless of its key schema, and both the cache interface and `DynamoDBCommand()` will work correctly.

## Session & Scope Storage

DynamoDB can be used as a durable, distributed storage backend for Lucee's session and client scopes. This is especially useful in clustered environments where sessions need to be shared across multiple application servers.

### Configuration

To enable scope storage, set `storage` to `true` in your cache definition and then reference the cache name in your `Application.cfc`:

```javascript
component {
    this.name = "myApp";

    this.caches["dynamo"] = {
        class: "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        maven: "org.lucee:dynamodb:1.0.0.7-RC",
        storage: true,
        custom: {
            "tableName": "session-table",
            "region": "us-east-1"
        }
    };

    // Use DynamoDB for session storage
    this.sessionStorage = "dynamo";

    // Or for client storage
    // this.clientStorage = "dynamo";
}
```

## Use Cases

### API Rate Limiting

```javascript
function checkRateLimit(apiKey, maxRequests=100, timeWindow=3600) {
    var cacheKey = "ratelimit_" & hash(apiKey);
    var requests = cacheGet(id=cacheKey, throwWhenNotExist=false, cacheName="dynamo");
    
    if(isNull(requests)) {
        cachePut(
            id=cacheKey,
            value=1,
            timeSpan=createTimeSpan(0,0,0,timeWindow),
            cacheName="dynamo"
        );
        return true;
    }
    
    if(requests >= maxRequests) {
        return false;
    }
    
    cachePut(
        id=cacheKey,
        value=requests + 1,
        timeSpan=createTimeSpan(0,0,0,timeWindow),
        cacheName="dynamo"
    );
    
    return true;
}
```

### Query Result Caching

```javascript
function getCachedQueryResults(sql, cacheMinutes=15) {
    var cacheKey = "query_" & hash(sql);
    
    var results = cacheGet(
        id=cacheKey,
        throwWhenNotExist=false,
        cacheName="dynamo"
    );
    
    if(!isNull(results)) {
        return results;
    }
    
    results = queryExecute(sql);
    
    cachePut(
        id=cacheKey,
        value=results,
        timeSpan=createTimeSpan(0,0,cacheMinutes,0),
        cacheName="dynamo"
    );
    
    return results;
}
```

### Atomic Counters with DynamoDBCommand

```javascript
// Increment a page view counter atomically — no read-modify-write needed
function incrementPageView(pageId) {
    return DynamoDBCommand("updateItem", {
        "key": { "pk": "pageviews_" & pageId },
        "UpdateExpression": "SET hits = if_not_exists(hits, :zero) + :inc",
        "ExpressionAttributeValues": { ":inc": 1, ":zero": 0 },
        "ReturnValues": "UPDATED_NEW"
    }, "dynamo");
}
```

### Distributed Lock Implementation

```javascript
function acquireLock(resourceName, timeout=30) {
    var lockKey = "lock_" & resourceName;
    var lockValue = createUUID();
    
    try {
        cachePut(
            id=lockKey,
            value=lockValue,
            timeSpan=createTimeSpan(0,0,0,timeout),
            cacheName="dynamo"
        );
        return lockValue;
    } catch(any e) {
        return null;
    }
}

function releaseLock(resourceName, lockValue) {
    var lockKey = "lock_" & resourceName;
    var currentValue = cacheGet(
        id=lockKey,
        throwWhenNotExist=false,
        cacheName="dynamo"
    );
    
    if(!isNull(currentValue) && currentValue == lockValue) {
        cacheDelete(id=lockKey, cacheName="dynamo");
        return true;
    }
    
    return false;
}
```

## Local Development with DynamoDB Local

For local development and testing, you can use DynamoDB Local instead of AWS DynamoDB.

### Installing DynamoDB Local

#### Using Docker

```bash
docker run -p 8000:8000 amazon/dynamodb-local:latest
```

#### Using Java (Manual Installation)

1. Download DynamoDB Local from [AWS Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)

2. Extract and run:

```bash
java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb
```

### Local Configuration

```javascript
this.caches = {
    "dynamo": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.7-RC",
        "storage": false,
        "custom": {
            "tableName": "local_cache",
            "accessKeyId": "dummy",
            "secretkey": "dummy",
            "region": "us-east-1",
            "host": "http://localhost:8000",
            "liveTimeout": 3600000,
            "log": "application"
        }
    }
};
```

### Environment-Based Configuration

```javascript
// Detect environment
var isDevelopment = (server.coldfusion.productname contains "Lucee") && 
                    (cgi.server_name contains "localhost");

var cacheConfig = {
    "tableName": isDevelopment ? "dev_cache" : "prod_cache",
    "region": "us-east-1",
    "log": "dynamodb"
};

if(isDevelopment) {
    cacheConfig.host = "http://localhost:8000";
    cacheConfig.accessKeyId = "dummy";
    cacheConfig.secretkey = "dummy";
} else {
    if(len(getSystemSetting("AWS_ACCESS_KEY_ID", ""))) {
        cacheConfig.accessKeyId = getSystemSetting("AWS_ACCESS_KEY_ID");
        cacheConfig.secretkey = getSystemSetting("AWS_SECRET_ACCESS_KEY");
    }
}

this.caches = {
    "dynamo": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.7-RC",
        "storage": false,
        "custom": cacheConfig
    }
};
```

## Performance Considerations

### Best Practices

1. **Use Appropriate Key Names**: Create meaningful, namespaced keys to avoid collisions

```javascript
   // Good
   cachePut(id="user:123:profile", value=data, cacheName="dynamo");
   
   // Less ideal
   cachePut(id="123", value=data, cacheName="dynamo");
```

2. **Implement Cache Warming**: Pre-populate frequently accessed data

```javascript
   function warmCache() {
       var criticalData = queryExecute("SELECT * FROM frequently_accessed");
       loop query=criticalData {
           cachePut(
               id="warm_" & criticalData.id,
               value=criticalData,
               cacheName="dynamo"
           );
       }
   }
```

3. **Use Batch Operations**: Leverage `cacheGetAll()` for multiple items

```javascript
   // Efficient: single query
   var userData = cacheGetAll(filter="user_*", cacheName="dynamo");
   
   // Less efficient: multiple queries
   for(var id in userIDs) {
       var data = cacheGet(id="user_" & id, cacheName="dynamo");
   }
```

4. **Set Appropriate TTL**: Balance between freshness and performance

```javascript
   // Frequently changing data: short TTL
   cachePut(id="stock_price", value=price, timeSpan=createTimeSpan(0,0,1,0), cacheName="dynamo");
   
   // Rarely changing data: longer TTL
   cachePut(id="config_settings", value=config, timeSpan=createTimeSpan(1,0,0,0), cacheName="dynamo");
```

5. **Prefer `query` over `scan`**: When using `DynamoDBCommand()`, use `query` with a key condition whenever possible. `scan` reads the entire table and should be used sparingly on large tables.

### Monitoring and Optimization

1. **Enable Logging**: Monitor cache operations

```javascript
   custom: {
       "log": "dynamodb",
       // ... other settings
   }
```

2. **Check Cache Metrics**: Use `cacheGetMetadata()` to analyze usage patterns

```javascript
   var metadata = cacheGetMetadata(id="popular_item", cacheName="dynamo");
   if(metadata.hitCount > 1000) {
       // Consider longer TTL for popular items
   }
```

3. **Monitor DynamoDB Metrics**: Use AWS CloudWatch to track read/write capacity usage, throttled requests, item count, table size, and average item size.

## Security Best Practices

### Credentials Management

1. **Use IAM Roles** when running on AWS infrastructure
2. **Use Environment Variables** for credentials in non-AWS environments
3. **Never hardcode credentials** in your application code
4. **Rotate credentials regularly**

### Access Control

1. **Use least privilege principle** for DynamoDB permissions
2. **Enable encryption at rest** in DynamoDB table settings
3. **Use VPC endpoints** for private network access
4. **Enable CloudTrail logging** for audit trails

### Recommended IAM Policy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:GetItem",
                "dynamodb:UpdateItem",
                "dynamodb:DeleteItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:DescribeTable",
                "dynamodb:DescribeTimeToLive"
            ],
            "Resource": "arn:aws:dynamodb:*:*:table/your-cache-table-name"
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:CreateTable",
                "dynamodb:UpdateTimeToLive"
            ],
            "Resource": "arn:aws:dynamodb:*:*:table/your-cache-table-name",
            "Condition": {
                "StringLike": {
                    "dynamodb:tableName": "your-cache-table-name"
                }
            }
        }
    ]
}
```

## Troubleshooting

### Common Issues

#### Connection Errors

```
Error: Unable to connect to DynamoDB
```

**Solution**: Verify your credentials and region settings. Check if the `host` parameter is set correctly for DynamoDB Local.

#### Table Not Found

```
Error: ResourceNotFoundException: Cannot do operations on a non-existent table
```

**Solution**: The extension automatically creates tables. If this error occurs, verify the IAM permissions include `CreateTable` action.

#### 400 Bad Request (Required keys missing)

**Solution**: When using `DynamoDBCommand()`, ensure the keys you pass match the case and name of the partition key in your table. The extension auto-detects the key name, but the data you pass must use the correct attribute name.

#### Throttling

```
Error: ProvisionedThroughputExceededException
```

**Solution**: For production tables, consider switching to on-demand billing mode or increasing provisioned capacity.

#### Invalid Security Token

```
Error: The security token included in the request is invalid
```

**Solution**: For AWS, verify your credentials are correct and not expired. For DynamoDB Local, ensure the `host` parameter is set to `http://localhost:8000`.

### Debug Logging

Enable detailed logging to troubleshoot issues:

```javascript
custom: {
    "log": "dynamodb-debug",
    // ... other settings
}
```

Then check your Lucee logs at: `[lucee-config]/logs/dynamodb-debug.log`

## Migration from Other Cache Providers

### From EhCache

```javascript
// Old EhCache configuration
this.cache.connections["ehcache"] = {
    class: "lucee.runtime.cache.eh.EHCache",
    storage: false
};

// New DynamoDB configuration
this.cache.connections["dynamo"] = {
    class: "org.lucee.extension.aws.dynamodb.DynamoDBCache",
    maven: "org.lucee:dynamodb:1.0.0.7-RC",
    storage: false,
    custom: {
        "tableName": "app_cache",
        "region": "us-east-1"
    }
};

// Application code remains the same — just update the cacheName
cachePut(id="key", value="value", cacheName="dynamo");
```

### From Redis

The API is identical since both implement the Lucee cache interface. Simply change the cache configuration.

## Comparison with Other Cache Providers

| Feature | DynamoDB | Redis | EhCache |
|---------|----------|-------|---------|
| Distributed | ✅ Yes | ✅ Yes | ❌ No |
| Managed Service | ✅ Yes | ⚠️ Optional | ❌ No |
| Auto-scaling | ✅ Yes | ❌ No | ❌ No |
| TTL Support | ✅ Native | ✅ Native | ✅ Yes |
| Native NoSQL Commands | ✅ Yes | ⚠️ Limited | ❌ No |
| Cost | 💰 Usage-based | 💰 Instance-based | ✅ Free |
| Setup Complexity | ✅ Minimal | ⚠️ Moderate | ✅ Minimal |

## Maven-Based Extension Benefits

Unlike older OSGi-based extensions, the DynamoDB extension leverages Lucee 7's Maven support, providing:

- **Automatic dependency resolution**: No need to bundle all JAR files
- **Easier updates**: Maven handles dependency versioning
- **Smaller extension size**: Dependencies downloaded on-demand
- **Better compatibility**: Reduced version conflicts
- **Simplified development**: Standard Maven project structure

## Additional Resources

- [AWS DynamoDB Documentation](https://docs.aws.amazon.com/dynamodb/)
- [DynamoDB Best Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)
- [Lucee Cache Functions](https://docs.lucee.org/categories/cache.html)
- [DynamoDB Local Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)

## Support and Contribution

- **GitHub**: [lucee/extension-dynamodb](https://github.com/lucee/extension-dynamodb)
- **Issues**: Report bugs or request features on [Jira](https://issues.lucee.org/)
- **Community**: Join the Lucee community forums for support
- **Extensions**: Visit the Lucee [Download](https://download.lucee.org/) page for updates