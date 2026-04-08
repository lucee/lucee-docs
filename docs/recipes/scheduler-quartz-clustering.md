<!--
{
  "title": "Quartz Scheduler Clustering",
  "id": "clustering-quartz-scheduler",
  "related": [
    "scheduler-quartz",
    "tag-schedule"
  ],
  "categories": [
    "extensions",
    "recipes"
  ],
  "description": "How to set up and configure clustering with the Quartz Scheduler extension",
  "keywords": [
    "scheduler",
    "quartz",
    "clustering",
    "database",
    "redis"
  ]
}
-->

# Clustering with Quartz Scheduler

This recipe provides detailed instructions for setting up and configuring clustering with the Quartz Scheduler extension for Lucee.

For a general overview of the Quartz Scheduler extension, see the [Quartz Scheduler documentation](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/scheduler-quartz.md).

## Overview

Clustering in Quartz Scheduler allows you to distribute your scheduled tasks across multiple servers, providing:

- **High Availability**: If one server fails, others continue to execute scheduled tasks
- **Load Distribution**: Job execution is distributed across multiple servers
- **Scalability**: Add more servers to handle increasing workloads

## Prerequisites

- Lucee 6.2 or 7.0 with the Quartz Scheduler extension installed
- A shared database or Redis instance accessible by all cluster nodes
- Proper network connectivity between all cluster nodes

## Storage Options for Clustering

Quartz Scheduler supports two types of storage for clustering:

1. **Database Storage**: Uses a relational database like MySQL, PostgreSQL, etc.
2. **Redis Storage**: Uses Redis as a distributed data store

### Database Storage Setup

#### 1. Create the Database

You'll need to create a database and user with sufficient privileges. Here's an example for MySQL:

```sql
-- Create the database
CREATE DATABASE IF NOT EXISTS quartz;

-- Create a dedicated user (recommended)
CREATE USER IF NOT EXISTS 'qs'@'%' IDENTIFIED WITH caching_sha2_password BY 'strongpassword';

-- Grant necessary privileges
GRANT ALL PRIVILEGES ON quartz.* TO 'qs'@'%' WITH GRANT OPTION;

-- Apply the changes
FLUSH PRIVILEGES;
```

#### 2. Create Database Tables

Quartz Scheduler needs specific tables in your database. While the extension will attempt to create these tables automatically, you may need to create them manually if the database user doesn't have sufficient privileges.

You can find database-specific scripts in the official Quartz repository:

- MySQL: [tables_mysql_innodb.sql](https://github.com/quartznet/quartznet/blob/main/database/tables/tables_mysql_innodb.sql)
- PostgreSQL: [tables_postgres.sql](https://github.com/quartznet/quartznet/blob/main/database/tables/tables_postgres.sql)
- Oracle: [tables_oracle.sql](https://github.com/quartznet/quartznet/blob/main/database/tables/tables_oracle.sql)
- SQL Server: [tables_sqlServer.sql](https://github.com/quartznet/quartznet/blob/main/database/tables/tables_sqlServer.sql)

#### 3. Configure the Datasource in Lucee

Create a datasource in the Lucee Administrator:

1. Navigate to Server/Web Admin > Datasources
2. Add a new datasource with the appropriate settings
3. Verify the connection is successful

#### 4. Configure Quartz Scheduler to Use the Datasource

Update your Quartz Scheduler configuration to use the datasource:

```json
{
  "store": {
    "type": "datasource",
    "datasource": "quartz",
    "tablePrefix": "QRTZ_",
    "cluster": true,
    "clusterCheckinInterval": "15000",
    "misfireThreshold": "60000"
  }
}
```

### Redis Storage Setup

#### 1. Install and Configure Redis

Ensure Redis is installed and accessible from all cluster nodes.

#### 2. Configure Quartz Scheduler to Use Redis

Update your Quartz Scheduler configuration to use Redis:

```json
{
  "store": {
    "type": "redis",
    "host": "redis.example.com",
    "port": 6379,
    "keyPrefix": "QRTZ_",
    "password": "${REDIS_PASSWORD}",
    "redisCluster": false,
    "redisSentinel": false,
    "database": 0,
    "lockTimeout": 30000,
    "ssl": false,
    "misfireThreshold": 60000
  }
}
```

## Primary Configuration Source

When running a cluster, you need to decide which source is authoritative for job definitions: the store or the config file. This is controlled by the `primary` setting.

```json
{
  "primary": "store"
}
```

| Value | Default when | Behaviour |
|-------|-------------|-----------|
| `"store"` | A store is defined | The store is the primary source of truth. The config file is only used to seed initial jobs when the store is empty. |
| `"file"` | No store is defined | The config file is always the primary source of truth. Jobs missing from the file will be removed from the store on startup. |

> **Note**: Listeners always come from the config file regardless of the `primary` setting.

### Store as Primary (Recommended for Most Clusters)

This is the default when a store is configured. Jobs are seeded from the config file on first start, after which the store takes over. Changes made through the Administrator UI or API are preserved across restarts.

```json
{
  "primary": "store",
  "store": {
    "type": "datasource",
    "datasource": "quartz",
    "cluster": true
  }
}
```

Use this when you manage jobs dynamically at runtime via the Administrator UI or programmatically via the API.

### File as Primary (Config-Managed Clusters)

When `primary` is set to `"file"`, the config file is always authoritative. On every startup, the scheduler reconciles the store against the file — adding missing jobs, updating changed ones, and removing any that are no longer defined in the file.

```json
{
  "primary": "file",
  "store": {
    "type": "datasource",
    "datasource": "quartz",
    "cluster": true
  }
}
```

Use this when you manage your cluster entirely through configuration files, for example in a CI/CD or infrastructure-as-code workflow where the config file is the single source of truth and runtime changes are not expected.

> **Warning**: With `"primary": "file"`, any jobs added at runtime through the Administrator UI will be removed on the next restart. Only use this mode if the config file is your sole management interface.

## How Clustering Works

In a clustered environment, Quartz Scheduler ensures that each job is executed by exactly one node in the cluster:

- If a job has a trigger set to fire every 10 seconds, at exactly 12:00:00, only one node will run the job
- At 12:00:10, again only one node will run the job
- It won't necessarily be the same node each time - the execution is distributed across the cluster

The load-balancing mechanism is:

- Near-random for busy schedulers with many triggers
- Favors the same node that was just active for schedulers with fewer triggers

This behavior is normal and should not be manually adjusted. It ensures efficient resource utilization across the cluster while maintaining the integrity of your scheduled tasks.

## Troubleshooting

### Common Issues

#### Database Permission Errors

If you see errors like `Table 'quartz.QRTZ_TRIGGERS' doesn't exist`, check:

1. The database user has sufficient privileges to create tables
2. The tables exist in the database
3. The table prefix in your configuration matches the actual tables

#### Clock Synchronization Issues

For clustering to work properly, all servers should have synchronized clocks. Use NTP to keep server clocks in sync.

#### Connection Issues

Ensure all nodes can connect to the storage backend (database or Redis) and that connection limits aren't being exceeded.

#### Jobs Disappearing After Restart

If jobs added at runtime are removed after a restart, check your `primary` setting. If it is set to `"file"`, the config file is authoritative and any jobs not defined there will be removed on startup. Either add the jobs to the config file or switch to `"primary": "store"`.

## Custom Logging

When running in a clustered environment, you may want to configure custom log files to track job execution across the cluster. Since Quartz Scheduler runs as an event gateway instance, you can configure custom logging through the event gateway settings in the Lucee Administrator.

You can also configure listeners to log job execution to a specific location:

```json
{
  "listeners": [
    {
      "component": "path.to.LoggingListener",
      "stream": "err",
      "logFile": "/path/to/quartz-cluster.log"
    }
  ]
}
```

## Advanced Configuration

### Fine-Tuning Cluster Settings

For optimal performance in a clustered environment, consider the following settings:

```json
{
  "store": {
    "type": "datasource",
    "datasource": "quartz",
    "tablePrefix": "QRTZ_",
    "cluster": true,
    "clusterCheckinInterval": "15000",
    "misfireThreshold": "60000",
    "acquireTriggersWithinLock": "true",
    "lockHandler.class": "org.quartz.impl.jdbcjobstore.UpdateLockRowSemaphore"
  }
}
```

- **clusterCheckinInterval**: How often (in milliseconds) a node checks in with the cluster
- **misfireThreshold**: How long (in milliseconds) a trigger can be late before it's considered misfired
- **acquireTriggersWithinLock**: Important for clustered environments to prevent race conditions

## Conclusion

Clustering with Quartz Scheduler provides robust, distributed task scheduling for your Lucee applications. By setting up a shared storage backend and configuring your nodes correctly, you can achieve high availability and scalability for your scheduled tasks.

Remember that the key to successful clustering is proper configuration of both the storage backend and the Quartz Scheduler itself, as well as ensuring all nodes in the cluster have synchronized clocks and reliable network connectivity.