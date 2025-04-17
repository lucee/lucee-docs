### Simple example for MavenInfo

```lucee
mavenData = mavenInfo(
    groupId = "com.mysql",
    artifactId = "mysql-connector-j",
    version = "9.0.0",
    scopes = ["compile"],
    includeOptional = true
);
```