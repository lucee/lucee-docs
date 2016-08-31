---
title: GetApplicationSettings
id: function-getapplicationsettings
related: GetApplicationMetaData()
categories:
---

Return a struct with information about the Application, as defined in Application.cfc or Application.cfm for the current running Application.  

Calling this function and passing `false` is equivalent to calling `getApplicationMetaData()`

The returned struct contains the following data:

| Key | Type | Default | Description |
| --- | --- | --- | --- |
|applicationTimeout| TimeSpan | | Application Scope timeout |
|clientCluster| Boolean | false | |
|clientManagement| Boolean | | |
|clientStorage| String | Cookie | Type of storage for the Client Scope |
|clientTimeout| TimeSpan | | Client Scope timeout |
|component| String | | Path to Application.cfc |
|customTagPaths| Array | | Paths in which custom tags are searched |
|datasource| String | | Name of the default datasource |
|datasources| Struct | | Datasources that are defined in the Application |
|defaultDatasource| String | | Alias for `datasource` |
|disablePlugins| Boolean | false | |
|invokeImplicitAccessor| Boolean | false | |
|javaSettings| Struct | | Settings that are used when creating a Java object |
|locale| String | | Name of the default Locale |
|localMode| Boolean | false | When `true`, functions use local mode and unscoped variables default to the Local Scope |
|loginStorage| String | Cookie | |
|mappings| Struct | | Application Mappings that map virtual directories to physical paths |
|name| String | | The Application's name |
|sameFormFieldAaAarray| Boolean | false | If true, when a Form field is passed more than once then it is returned as an array |
|sameUrlFieldsAsArray| Boolean | false | If true, when a URL field is passed more than once then it is returned as an array |
|scriptProtect| String | "none" | |
|secureJson| Boolean | false | |
|secureJsonPrefix| String | "//" | Prefix to be used with `secureJson` |
|serverSideFormValidation| Boolean | false | |
|sessionCluster| Boolean | false | |
|sessionManagement| Boolean | true | |
|sessionStorage| String | "memory" | |
|sessionTimeout| TimeSpan | | Session Scope timeout |
|sessionType| Boolean | "cfml" | Either "cfml" or "j2ee" |
|setClientCookies| Boolean | true | |
|setDomainCookies| Boolean | false | |
|source| String | | Alias for `component` |
|timezone| String | | Time Zone name, e.g. `America/Los_Angeles` |
|triggerDataMember| Boolean | false | |

