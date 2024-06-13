<!--
{
  "title": "Get Datasource Drivers Directly from Maven",
  "id": "get-datasource-drivers-from-maven",
  "since": "6.1",
  "description": "Learn how to get datasource drivers directly from Maven.",
  "keywords": [
    "datasource",
    "maven"
  ]
}
-->
# Get Datasource Drivers Directly from Maven

The following example is for the MySQL driver, but it works for all types of datasource drivers in exactly the same way. 
While you could install the MySQL extension to get the driver you need, it is not necessary. You can simply define the driver as shown below in the `Application.cfc` or `.CFConfig.json`.

## Application.cfc

You can define your datasource in the `Application.cfc` like this:

```lucee
this.datasources["mysql"] = {
    class: "com.mysql.cj.jdbc.Driver", 
    bundleName: "com.mysql.cj", 
    bundleVersion: "8.4.0",
    connectionString: "jdbc:mysql://localhost:3307/test?characterEncoding=UTF-8&serverTimezone=CET&maxReconnects=3",
    username: "root",
    password: "encrypted:...",

    // optional settings
    connectionLimit: -1, // default: -1
    liveTimeout: 15, // default: -1; unit: minutes
    alwaysSetTimeout: true, // default: false
    validate: false // default: false
};
```

You can use whatever version is available on [Maven](https://mvnrepository.com/artifact/com.mysql/mysql-connector-j).

If you are unsure about the correct settings, simply install the MySQL extension, create a datasource in the Lucee admin, and at the bottom of the detail page, you will get an `Application.cfc` template for these settings.

## .CFConfig.json

For `.CFConfig.json`, your settings will look like this:

```json
"dataSources": {
    "mysql": {
        "class": "com.mysql.cj.jdbc.Driver",
        "bundleName": "com.mysql.cj",
        "bundleVersion": "8.4.0",
        "custom": "characterEncoding=UTF-8&serverTimezone=CET&maxReconnects=3",
        "database": "test",
        "dbdriver": "MySQL",
        "dsn": "jdbc:mysql://{host}:{port}/{database}",
        "liveTimeout": "15",
        "metaCacheTimeout": "60000",
        "password": "encrypted:...",
        "port": "3307",
        "storage": "false",
        "username": "root",
        "validate": "false"
    }
}
```

Here, you can also use any version that is available on [Maven](https://mvnrepository.com/artifact/com.mysql/mysql-connector-j).

Again, if you are unsure about the exact settings, simply install the MySQL extension, create a datasource in the admin, and then check out the datasource created in `.CFConfig`. Be careful here, because when you define the datasource in the Lucee admin, Lucee will set neither `bundleName` nor `bundleVersion`, as Lucee uses what is installed by default. To get it from Maven directly, you need to define the bundle information, so always add that information.

## Conclusion

The benefit over simply use the MySQL extension is, you can use the newest version of MySQL or any other DB driver that is fresh from the press, if no Lucee extension exist yet for that version.