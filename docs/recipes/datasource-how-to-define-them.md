<!--
{
  "title": "Datasources",
  "id": "datasource-how-to-define-them",
  "description": "How to define a Datasource in Lucee.",
  "keywords": [
    "Datasource",
    "Define datasource",
    "Administrator",
    "Application.cfc",
    "Default datasource",
    "MySQL"
  ],
  "categories":[
    "query",
    "server"
  ]
}
-->

# Datasources

Define datasources to execute queries against local or remote databases.

## Lucee Administrator

Go to Services > Datasource, create a new datasource by choosing a name and type (e.g. MySQL).

![create datasource](https://bitbucket.org/repo/rX87Rq/images/3802808059-createds.png)

Configure connection settings on the next page. Server Administrator datasources are visible to all web contexts; Web Administrator datasources only to the current context.

## Application.cfc

Create a datasource in Administrator, then click "edit" to view its definition:

![select datasource](https://bitbucket.org/repo/rX87Rq/images/4142224660-select-datasource.png)

Copy the code from the bottom of the detail page:

![datasource application definition](https://bitbucket.org/repo/rX87Rq/images/1656402808-datasource-app-def.png)

```cfs
this.datasources["myds"] = {
    class: 'org.gjt.mm.mysql.Driver',
    connectionString: 'jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true',
    username: 'root',
    password: 'encrypted:5120611ea34c6123fd85120a0c27ab23fd81ea34cb854'
};
```

Or use this pattern:

```cfs
this.datasources["myds"] = {
    type: 'mysql',
    host: 'localhost',
    database: 'test',
    port: 3306,
    username: 'root',
    password: 'encrypted:5120611ea34c6123fd85120a0c27ab23fd81ea34cb854',
    connectionLimit: -1,
    connectionTimeout: 1,
    blob: false,
    clob: false,
    storage: false,
    timezone: 'CET',
    custom: {useUnicode: true, characterEncoding: 'UTF-8'}
};
```

### Default Datasource

Define a default datasource used when no `datasource` attribute is specified in `cfquery`, `cfstoredproc`, etc.:

```cfs
this.defaultdatasource = "myds";
```

Or define the datasource inline:

```cfs
this.datasource = {
    class: 'org.gjt.mm.mysql.Driver',
    connectionString: 'jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true',
    username: 'root',
    password: 'encrypted:5120611ea34c6123fd85120a0c27ab23fd81ea34cb854'
};
```

### Custom JDBC Drivers (Other)

When using the "Other - JDBC Driver" type for databases without built-in support, provide:

- **class**: The fully qualified JDBC driver class name
- **connectionString**: The JDBC connection URL

```cfs
this.datasources["mydb"] = {
    class: 'com.example.jdbc.Driver',
    connectionString: 'jdbc:example://localhost:1234/mydb',
    username: 'user',
    password: 'pass'
};
```

For OSGi-based JDBC drivers (JARs deployed as bundles in `/lucee-server/bundles/`), you can also specify:

- **bundleName**: The OSGi bundle symbolic name
- **bundleVersion**: The OSGi bundle version

```cfs
this.datasources["mydb"] = {
    class: 'com.example.jdbc.Driver',
    connectionString: 'jdbc:example://localhost:1234/mydb',
    bundleName: 'com.example.jdbc',
    bundleVersion: '1.2.3',
    username: 'user',
    password: 'pass'
};
```

This is useful when:

- Using database drivers not bundled with Lucee
- Deploying drivers as OSGi bundles for better version management
- Working with multiple versions of the same driver
