<!--
{
  "title": "Query Result Logging",
  "id": "query-result-threshold",
  "since": "6.2.3.15",
  "categories": ["monitoring", "performance", "database", "query"],
  "description": "Monitor and log database queries that return large result sets to prevent OutOfMemory errors",
  "keywords": [
    "query",
    "logging",
    "monitoring",
    "performance",
    "OOM",
    "OutOfMemory",
    "database",
    "threshold"
  ],
  "related" :[
    "tag-query"
  ]
}
-->

# Query Result Logging

Lucee 6.2.3.15 introduces automatic logging for database queries that return large result sets, helping you proactively identify potential OutOfMemory (OOM) issues before they impact your applications.

This feature provides early warning when queries return unexpectedly large datasets, enabling better monitoring and performance optimization.

## Configuration

Query result logging is configured using a single environment variable or system property:

**Environment Variable:**
```bash
LUCEE_QUERY_RESULT_THRESHOLD=100000
```

**System Property:**
```bash
-Dlucee.query.result.threshold=100000
```

### Configuration Options

- **Threshold Value**: Any positive integer representing the minimum number of rows that will trigger logging
- **Disabled**: Set to `0` or leave unset to disable the feature (default behavior)
- **Log Category**: Fixed to `datasource` (cannot be changed)
- **Log Level**: Fixed to `warn` (cannot be changed)

## Usage Examples

### Basic Setup

Set a threshold of 10,000 rows to catch moderately large result sets:

```bash
# Environment variable
export LUCEE_QUERY_RESULT_THRESHOLD=10000

# Or as system property
java -Dlucee.query.result.threshold=10000 -jar lucee.jar
```

### Production Monitoring

For production environments, set a higher threshold to focus on truly problematic queries:

```bash
export LUCEE_QUERY_RESULT_THRESHOLD=100000
```

### Development Testing

For development and testing, use a lower threshold to catch potential issues early:

```bash
export LUCEE_QUERY_RESULT_THRESHOLD=1000
```

## Log Output

When a query exceeds the threshold, Lucee logs a warning message with detailed information:

```
WARN [datasource] Large query result detected: execution-time:12.475417ms, rows=11, columns=7, threshold=10, query=SELECT X as id, 'User ' || X as name, 'user' || X || '@example.com' as email, CASE WHEN MOD(X, 4) = 0 THEN 'Engineering' WHEN MOD(X, 4) = 1 THEN 'Marketing' WHEN MOD(X, 4) = 2 THEN 'Sales' ELSE 'HR' END as department, 60000 + (X * 1000) as salary, DATEADD('DAY', X * 10, DATE '2023-01-01') as hire_date, CASE WHEN MOD(X, 3) = 0 THEN false ELSE true END as active FROM SYSTEM_RANGE(1, 11);, tagcontext=/test1.cfm:16;
```

### Log Information Includes

- **Execution Time**: Query execution duration in milliseconds
- **Row Count**: Number of rows returned
- **Column Count**: Number of columns in the result set
- **Threshold**: The configured threshold value
- **Query**: The SQL statement that was executed
- **Tag Context**: Stacktrace to File and line number where the query was executed

## Monitoring and Analysis

### Log File Location

Query result logs are written to the `datasource` log category. Check your Lucee logging configuration to determine where these logs are stored.

### Common Log Analysis

Use log analysis tools or scripts to:

1. **Identify Patterns**: Find queries that frequently exceed thresholds
2. **Monitor Trends**: Track if query result sizes are growing over time
3. **Performance Impact**: Correlate large result sets with application performance issues
4. **Optimization Targets**: Prioritize which queries need optimization

### Sample Log Analysis Script

```bash
# Count occurrences of large query results
grep "Large query result detected" /path/to/datasource.log | wc -l

# Find the largest result sets
grep "Large query result detected" /path/to/datasource.log | \
  sed 's/.*rows=\([0-9]*\).*/\1/' | sort -n | tail -10

# Identify most problematic queries
grep "Large query result detected" /path/to/datasource.log | \
  sed 's/.*query=\([^,]*\).*/\1/' | sort | uniq -c | sort -nr
```

## Best Practices

### Threshold Selection

- **Development**: 1,000 - 10,000 rows (catch issues early)
- **Staging**: 10,000 - 50,000 rows (realistic testing)
- **Production**: 50,000 - 100,000+ rows (focus on critical issues)

### Performance Considerations

- The logging check has minimal performance impact
- Row counting uses existing query metadata
- No additional database queries are executed

### Optimization Strategies

When large result sets are logged:

1. **Add Pagination**: Implement LIMIT/OFFSET for large datasets
2. **Optimize WHERE Clauses**: Add filters to reduce result size
3. **Use Streaming**: Process results in chunks rather than loading all at once
4. **Index Analysis**: Ensure proper indexing for query performance
5. **Caching**: Cache frequently accessed large datasets

## Troubleshooting

### No Logs Appearing

1. Verify the threshold is set correctly
2. Check that queries actually exceed the threshold
3. Ensure `warn` level logging is enabled for the `datasource` category


### False Positives

If logging captures expected large result sets:
- Adjust the threshold higher
- Use different thresholds for different environments
- Consider the business logic requirements

## Security Considerations

- SQL queries in logs may contain sensitive data
- Ensure log files have appropriate access restrictions
- Consider log rotation and retention policies
- Review logged queries for potential SQL injection attempts
