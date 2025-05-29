---
title: CreateObject
id: function-createobject
categories:
- component
- core
- java
- object
- webservice
description: 'The CreateObject function takes different arguments depending on the
  value of the first argument:'
---

Creates and returns a reference to objects of various types including Java classes, components, web services, and COM objects.

## Type: "java"

Creates a Java object instance. As of Lucee 6.2, this supports Maven dependency management and enhanced Java settings.

```
CreateObject('java', className [, classpath|bundleName|javasettings] [, delimiter|bundleVersion])
```

You can provide Java libraries in four ways:

- Using classpath: Specify directories or JAR files
- Using OSGi bundles: Provide a bundle name and version
- Using loadPaths: Define non-OSGi JAR paths directly
- Using Maven: Define Maven artifacts via a javasettings structure

### Using Classpath

```cfml
// Using directories and JAR files with a classpath
createObject("java", "com.example.MyClass", "/path/to/libs/,/path/to/specific.jar");

// Using an array of paths
createObject("java", "com.example.MyClass", ["/path/to/libs/", "/path/to/specific.jar"]);
```

### OSGi Bundle Support

```cfml
createObject(
  type: "java", 
  class: "org.lucee.mockup.osgi.Test", 
  bundleName: "lucee.mockup", 
  bundleVersion: "1.0.0.0"
);
```

### Maven Support (Lucee 6.2+)

```cfml
createObject(
  type: "java",
  class: "org.apache.commons.beanutils.BeanUtils",
  javasettings: {
    "maven": [
      {
        "groupId": "commons-beanutils",
        "artifactId": "commons-beanutils",
        "version": "1.9.4"
      }
    ]
  }
);
```

### Java Settings Structure

The javasettings structure can contain:

- maven: Array of Maven dependency structures (groupId, artifactId, version)
- loadPaths: Array of paths to non-OSGi JAR files or directories
- bundlePaths: Array of paths to OSGi bundle files or directories
- reloadOnChange: Boolean indicating whether to reload updated classes dynamically (default: false)
- watchInterval: Number of seconds between checks for changes (default: 60)
- watchExtensions: Array of file extensions to monitor (default: ["jar", "class"])

## Type: "component"

Creates a CFC instance without calling the init method.

```
CreateObject('component', componentName)
```

## Type: "webservice"

Creates a web service client from a WSDL.

```
CreateObject('webservice', urlToWsdl [, portName] [, options])
```

## Type: "com"

Creates a COM object (Windows only).

```
CreateObject('com', class, context, serverName)
```