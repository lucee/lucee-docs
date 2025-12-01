<!--
{
  "title": "DynamoDB Cache Extension",
  "id": "dynamodb-cache-extension",
  "since": "7.0",
  "categories": ["cache", "aws", "dynamodb"],
  "description": "Documentation for using Amazon DynamoDB as a cache provider in Lucee",
  "keywords": [
    "DynamoDB",
    "Cache",
    "AWS",
    "NoSQL",
    "Distributed Cache",
    "Cloud Storage",
    "Maven"
  ],
  "related": [
    "cache-functions",
    "s3-extension"
  ]
}
-->

# DynamoDB Cache Extension

The DynamoDB Cache Extension enables Lucee applications to use Amazon DynamoDB as a distributed cache provider. This powerful combination provides a highly scalable, fully managed NoSQL cache solution with automatic table creation, TTL support, and seamless integration with Lucee's cache functions.

## Overview

DynamoDB is Amazon's fully managed NoSQL database service that provides fast and predictable performance with seamless scalability. By using DynamoDB as a cache backend, your Lucee applications can benefit from:

- **Distributed caching** across multiple application servers
- **Automatic scalability** to handle varying loads
- **Built-in replication** for high availability
- **Pay-per-use billing** with on-demand capacity mode
- **Automatic table creation** - no manual setup required
- **TTL support** for automatic cache expiration
- **Maven-based dependency management** (no OSGi complexity)

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
    "dynamodb": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.0",
        "storage": false,
        "custom": {
            "table": "my_cache_table",
            "accessKeyId": "${AWS_ACCESS_KEY_ID}",
            "secretkey": "${AWS_SECRET_ACCESS_KEY}",
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
    "dynamodb": {
      "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
      "maven": "org.lucee:dynamodb:1.0.0.0",
      "custom": {
        "table": "prod_cache",
        "accessKeyId": "${AWS_ACCESS_KEY_ID}",
        "secretkey": "${AWS_SECRET_ACCESS_KEY}",
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
| `table` | String | The name of the DynamoDB table to use for caching. The table will be created automatically if it doesn't exist with a simple key-value structure using 'cacheKey' as the partition key. |

### Authentication Settings

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `accessKeyId` | String | No* | AWS Access Key ID for authentication. Leave empty when running on EC2/ECS with IAM roles. For DynamoDB Local testing, you can use any dummy value like 'dummy'. |
| `secretkey` | String | No* | AWS Secret Access Key for authentication. Leave empty when running on EC2/ECS with IAM roles. For DynamoDB Local testing, you can use any dummy value like 'dummy'. |

*Not required when running on EC2/ECS with IAM roles, but required for local development or external access.

### Custom Endpoint Settings

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `region` | String | No | AWS region where the DynamoDB table is located (e.g., 'us-east-1', 'eu-west-1'). If not specified, the default region from your AWS configuration will be used. |
| `host` | String | No | Custom endpoint URL for DynamoDB. Use 'http://localhost:8000' for DynamoDB Local testing. Leave empty to use the standard AWS DynamoDB endpoints. |

### General Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `liveTimeout` | Number | 3600000 | Connection timeout in milliseconds for DynamoDB operations. |
| `log` | String | "application" | Name of the log file where cache operations and errors will be recorded. Set to 'application' to use the default application log, or specify a custom log name (e.g., 'dynamodb-cache'). |

## Configuration Examples

### Production Configuration (AWS)

```javascript
this.caches = {
    "dynamodb": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.0",
        "storage": false,
        "custom": {
            "table": "prod_cache",
            "accessKeyId": getSystemSetting("AWS_ACCESS_KEY_ID"),
            "secretkey": getSystemSetting("AWS_SECRET_ACCESS_KEY"),
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
    "dynamodb": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.0",
        "storage": false,
        "custom": {
            "table": "dev_cache",
            "accessKeyId": "dummy",
            "secretkey": "dummy",
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
    "dynamodb": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.0",
        "storage": false,
        "custom": {
            "table": "app_cache",
            "region": "us-east-1",
            "log": "dynamodb"
        },
        "default": ""
    }
};
```

## Usage

Once configured, you can use all standard Lucee cache functions with your DynamoDB cache.

### Basic Operations

#### Store Data in Cache

```javascript
// Simple string value
cachePut(id="user_session_123", value="active", cacheName="dynamodb");

// Complex data structures
var userData = {
    "name": "John Doe",
    "email": "john@example.com",
    "preferences": {
        "theme": "dark",
        "notifications": true
    }
};
cachePut(id="user_profile_456", value=userData, cacheName="dynamodb");

// With expiration (5 minutes)
cachePut(
    id="temporary_token", 
    value="abc123xyz", 
    timeSpan=createTimeSpan(0,0,5,0),
    cacheName="dynamodb"
);
```

#### Retrieve Data from Cache

```javascript
// Get value (throws error if not found)
var sessionData = cacheGet(id="user_session_123", cacheName="dynamodb");

// Get value with default
var userData = cacheGet(
    id="user_profile_456", 
    throwWhenNotExist=false,
    cacheName="dynamodb"
);

// Check if exists before getting
if(cacheIdExists(id="user_session_123", cacheName="dynamodb")) {
    var session = cacheGet(id="user_session_123", cacheName="dynamodb");
}
```

#### Delete from Cache

```javascript
// Delete single item
cacheDelete(id="user_session_123", cacheName="dynamodb");

// Clear all items matching a pattern
cacheClear(filter="user_session_*", cacheName="dynamodb");

// Clear entire cache
cacheClear(cacheName="dynamodb");
```

### Advanced Operations

#### Working with Multiple Items

```javascript
// Get all cache IDs
var allIds = cacheGetAllIds(cacheName="dynamodb");

// Get IDs matching a pattern
var userSessions = cacheGetAllIds(filter="user_session_*", cacheName="dynamodb");

// Get all values matching a pattern
var allUserData = cacheGetAll(filter="user_*", cacheName="dynamodb");
// Returns a struct: { "user_123": {...}, "user_456": {...}, ... }

// Count cache items
var totalItems = cacheCount(cacheName="dynamodb");
```

#### Cache Metadata

```javascript
// Get metadata for a cache entry
var metadata = cacheGetMetadata(id="user_profile_456", cacheName="dynamodb");

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
cachePut(id="key1", value="Simple string", cacheName="dynamodb");

// Numbers
cachePut(id="key2", value=12345.67, cacheName="dynamodb");

// Booleans
cachePut(id="key3", value=true, cacheName="dynamodb");

// Dates
cachePut(id="key4", value=now(), cacheName="dynamodb");

// Arrays
cachePut(id="key5", value=[1, "two", 3.0, true], cacheName="dynamodb");

// Structs
cachePut(id="key6", value={
    "name": "Product",
    "price": 99.99,
    "inStock": true,
    "tags": ["featured", "sale"]
}, cacheName="dynamodb");

// Queries
var qryData = queryNew("id,name", "integer,varchar", [[1,"Alice"],[2,"Bob"]]);
cachePut(id="key7", value=qryData, cacheName="dynamodb");
```

## Time-To-Live (TTL) and Expiration

The DynamoDB extension fully supports cache expiration using DynamoDB's native TTL feature.

### Setting Expiration

```javascript
// Expire after 1 hour
cachePut(
    id="session_token",
    value="xyz789",
    timeSpan=createTimeSpan(0,1,0,0),
    cacheName="dynamodb"
);

// Expire at specific time
var expirationDate = dateAdd("h", 2, now());
cachePut(
    id="scheduled_job",
    value=jobData,
    until=expirationDate,
    cacheName="dynamodb"
);

// Idle timeout (expires if not accessed)
cachePut(
    id="idle_session",
    value=sessionData,
    idleTime=1800000, // 30 minutes in milliseconds
    cacheName="dynamodb"
);
```

### TTL Behavior

- TTL is automatically enabled when the table is created
- Expired items are automatically deleted by DynamoDB (typically within 48 hours of expiration)
- The cache checks for expiration on read operations
- Expired items won't be returned by cache operations even if not yet deleted by DynamoDB

## Use Cases

### Session Storage

```javascript
// Store user session
function createUserSession(userID, sessionData) {
    var sessionID = createUUID();
    
    cachePut(
        id="session_" & sessionID,
        value={
            "userID": userID,
            "loginTime": now(),
            "data": sessionData
        },
        timeSpan=createTimeSpan(0,2,0,0), // 2 hour timeout
        cacheName="dynamodb"
    );
    
    return sessionID;
}

// Retrieve session
function getUserSession(sessionID) {
    return cacheGet(
        id="session_" & sessionID,
        throwWhenNotExist=false,
        cacheName="dynamodb"
    );
}
```

### API Rate Limiting

```javascript
function checkRateLimit(apiKey, maxRequests=100, timeWindow=3600) {
    var cacheKey = "ratelimit_" & hash(apiKey);
    var requests = cacheGet(id=cacheKey, throwWhenNotExist=false, cacheName="dynamodb");
    
    if(isNull(requests)) {
        // First request
        cachePut(
            id=cacheKey,
            value=1,
            timeSpan=createTimeSpan(0,0,0,timeWindow),
            cacheName="dynamodb"
        );
        return true;
    }
    
    if(requests >= maxRequests) {
        return false; // Rate limit exceeded
    }
    
    // Increment counter
    cachePut(
        id=cacheKey,
        value=requests + 1,
        timeSpan=createTimeSpan(0,0,0,timeWindow),
        cacheName="dynamodb"
    );
    
    return true;
}
```

### Query Result Caching

```javascript
function getCachedQueryResults(sql, cacheMinutes=15) {
    var cacheKey = "query_" & hash(sql);
    
    // Try to get from cache
    var results = cacheGet(
        id=cacheKey,
        throwWhenNotExist=false,
        cacheName="dynamodb"
    );
    
    if(!isNull(results)) {
        return results;
    }
    
    // Execute query
    results = queryExecute(sql);
    
    // Cache results
    cachePut(
        id=cacheKey,
        value=results,
        timeSpan=createTimeSpan(0,0,cacheMinutes,0),
        cacheName="dynamodb"
    );
    
    return results;
}
```

### Distributed Lock Implementation

```javascript
function acquireLock(resourceName, timeout=30) {
    var lockKey = "lock_" & resourceName;
    var lockValue = createUUID();
    
    try {
        // Try to acquire lock
        cachePut(
            id=lockKey,
            value=lockValue,
            timeSpan=createTimeSpan(0,0,0,timeout),
            cacheName="dynamodb"
        );
        return lockValue;
    } catch(any e) {
        // Lock already exists
        return null;
    }
}

function releaseLock(resourceName, lockValue) {
    var lockKey = "lock_" & resourceName;
    var currentValue = cacheGet(
        id=lockKey,
        throwWhenNotExist=false,
        cacheName="dynamodb"
    );
    
    // Only release if we own the lock
    if(!isNull(currentValue) && currentValue == lockValue) {
        cacheDelete(id=lockKey, cacheName="dynamodb");
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
    "dynamodb": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.0",
        "storage": false,
        "custom": {
            "table": "local_cache",
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
    "table": isDevelopment ? "dev_cache" : "prod_cache",
    "region": "us-east-1",
    "log": "dynamodb"
};

if(isDevelopment) {
    // Local development
    cacheConfig.host = "http://localhost:8000";
    cacheConfig.accessKeyId = "dummy";
    cacheConfig.secretkey = "dummy";
} else {
    // Production - use environment variables or IAM roles
    if(len(getSystemSetting("AWS_ACCESS_KEY_ID", ""))) {
        cacheConfig.accessKeyId = getSystemSetting("AWS_ACCESS_KEY_ID");
        cacheConfig.secretkey = getSystemSetting("AWS_SECRET_ACCESS_KEY");
    }
    // Otherwise rely on IAM role (no credentials needed)
}

this.caches = {
    "dynamodb": {
        "class": "org.lucee.extension.aws.dynamodb.DynamoDBCache",
        "maven": "org.lucee:dynamodb:1.0.0.0",
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
   cachePut(id="user:123:profile", value=data, cacheName="dynamodb");
   
   // Less ideal
   cachePut(id="123", value=data, cacheName="dynamodb");
```

2. **Implement Cache Warming**: Pre-populate frequently accessed data

```javascript
   function warmCache() {
       var criticalData = queryExecute("SELECT * FROM frequently_accessed");
       loop query=criticalData {
           cachePut(
               id="warm_" & criticalData.id,
               value=criticalData,
               cacheName="dynamodb"
           );
       }
   }
```

3. **Use Batch Operations**: Leverage `cacheGetAll()` for multiple items

```javascript
   // Efficient: single query
   var userData = cacheGetAll(filter="user_*", cacheName="dynamodb");
   
   // Less efficient: multiple queries
   for(var id in userIDs) {
       var data = cacheGet(id="user_" & id, cacheName="dynamodb");
   }
```

4. **Set Appropriate TTL**: Balance between freshness and performance

```javascript
   // Frequently changing data: short TTL
   cachePut(id="stock_price", value=price, timeSpan=createTimeSpan(0,0,1,0), cacheName="dynamodb");
   
   // Rarely changing data: longer TTL
   cachePut(id="config_settings", value=config, timeSpan=createTimeSpan(1,0,0,0), cacheName="dynamodb");
```

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
   var metadata = cacheGetMetadata(id="popular_item", cacheName="dynamodb");
   if(metadata.hitCount > 1000) {
       // Consider longer TTL for popular items
   }
```

3. **Monitor DynamoDB Metrics**: Use AWS CloudWatch to track:
   - Read/Write capacity usage
   - Throttled requests
   - Item count and table size
   - Average item size

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

**Solution**: Verify your credentials and region settings. Check if the host parameter is set correctly for DynamoDB Local.

#### Table Not Found
```
Error: ResourceNotFoundException: Cannot do operations on a non-existent table
```

**Solution**: The extension automatically creates tables. If this error occurs, verify the IAM permissions include `CreateTable` action.

#### Throttling
```
Error: ProvisionedThroughputExceededException
```

**Solution**: For production tables, consider switching to on-demand billing mode or increasing provisioned capacity.

#### Invalid Security Token
```
Error: The security token included in the request is invalid
```

**Solution**: 
- For AWS: Verify your credentials are correct and not expired
- For DynamoDB Local: Ensure the host parameter is set to `http://localhost:8000`

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
this.cache.connections["dynamodb"] = {
    class: "org.lucee.extension.aws.dynamodb.DynamoDBCache",
    maven: "org.lucee:dynamodb:1.0.0.0",
    storage: false,
    custom: {
        "table": "app_cache",
        "region": "us-east-1"
    }
};

// Application code remains the same
cachePut(id="key", value="value", cacheName="dynamodb");
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
| Complex Queries | ⚠️ Limited | ⚠️ Limited | ❌ No |
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
- **Issues**: Report bugs or request features on [ Jira](https://issues.lucee.org/)
- **Community**: Join the Lucee community forums for support
- **Extensions**: Visit the Lucee [Download](https://download.lucee.org/) page for updates
