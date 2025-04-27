
<!--
{
  "title": "JavaSettings in Application.cfc, Components and CFConfig.json",
  "id": "java-settings",
  "since": "6.2",
  "description": "Guide on configuring Java settings in Lucee using Application.cfc, including loading Java libaries from Maven",
  "keywords": [
    "Java settings",
    "Application.cfc",
    "javasettings",
    "cfapplication"
  ],
  "categories": [
    "java"
  ],
  "related": [
    "tag-application",
    "tag-component",
    "function-createobject"
  ]
}
-->

# Java Settings in Application.cfc (Now with Maven Support)

This document provides information about configuring Java settings in Lucee using `Application.cfc`, and other new places like `.CFConfig.json`, `createObject`, and components.

## Introduction

The `this.javasettings` settings in `Application.cfc` allow you to define Java library paths, OSGi bundle paths, Maven libraries, and other Java-related configurations. These settings cannot be configured through the Lucee admin or environment variables.

Starting with Lucee 6.2, we’ve extended Java settings to support Maven libraries and expanded their use in additional contexts, including `.CFConfig.json`, `createObject`, and individual components.

## Configuring Java Settings

You can configure Java settings in `Application.cfc`, `.CFConfig.json`, within components, or using the `createObject` function.

### Load Paths

You can define regular JARs (not OSGi) by specifying the path to a directory or the JAR file itself.

```cfml
this.javasettings.loadPaths = [
    "/my/local/path/to/whatever/lib/",
    "/my/local/path/to/whatever/lib/xyz.jar"
];
```

### Bundle Paths

You can load local OSGi bundles in a similar way.

```cfml
this.javasettings.bundlePaths = [
    "/my/local/path/to/whatever/lib/",
    "/my/local/path/to/whatever/lib/xyz.jar"
];
```

### Maven Support

Starting in Lucee 6.2, Maven support has been added to `this.javasettings`, allowing you to define Maven dependencies directly. Maven manages libraries by automatically handling their retrieval and versioning.

```cfml
this.javasettings.maven = [
    {
      "groupId": "org.quartz-scheduler",
      "artifactId": "quartz",
      "version": "2.3.2"
    },
    {
      "groupId": "commons-beanutils",
      "artifactId": "commons-beanutils",
      "version": "1.9.4"
    }
];
```

If the `version` is omitted, Lucee will use the latest available version of the Maven artifact.

## Java Settings in `.CFConfig.json`

You can also define Java settings globally for all applications through the `.CFConfig.json` configuration file. This is especially useful when managing Docker environments.

```json
{
  "javasettings": {
    "maven": [
      {
        "groupId": "org.quartz-scheduler",
        "artifactId": "quartz",
        "version": "2.3.2"
      },
      {
        "groupId": "commons-beanutils",
        "artifactId": "commons-beanutils",
        "version": "1.9.4"
      }
    ],
    "loadPaths": [
      "/my/local/path/to/whatever/lib/",
      "/my/local/path/to/whatever/lib/xyz.jar"
    ],
    "bundlePaths": [
      "/my/local/path/to/whatever/lib/",
      "/my/local/path/to/whatever/lib/xyz.jar"
    ]
  }
}
```

### Using Java Settings in `Application.cfc`

In your [[tag-Application]], you can define or override Java settings specific to your application. 

This is the primary way to configure Java dependencies at the application level.

```cfml
this.javasettings = {
  "maven": [
    {
      "groupid": "commons-beanutils",
      "artifactid": "commons-beanutils",
      "version": "1.9.4"
    }
  ],
  "loadPaths": [
    "/my/local/path/to/libs/",
    "/my/local/path/to/libs/example.jar"
  ],
  "bundlePaths": [
    "/my/local/path/to/bundles/"
  ],
  "reloadOnChange": true,
  "watchInterval": 60,
  "watchExtensions": ["jar", "class"]
};
```

This method gives you flexibility to handle specific Java dependencies within each application, ensuring that classloaders are configured per application.

### Using Java Settings in a Component

Maven dependencies and other Java settings can also be defined as part of a [[tag-component]]. 

This ensures that only the classes loaded within that component will use the specified settings, isolating it from the rest of the application and avoiding conflicts.

```cfml
component javaSettings = '{
  "maven": [
    {
      "groupId": "commons-beanutils",
      "artifactId": "commons-beanutils",
      "version": "1.9.4"
    }
  ]
}' {
  // Component logic
}
```

This method is useful for encapsulating components with specific versions of libraries, preventing conflicts with other parts of the application.

### Using Java Settings in `createObject`

Java settings can also be defined dynamically when creating Java objects using the [[function-createObject]] function.

```cfml
createObject("java", "org.apache.commons.beanutils.BeanUtils", {
  "maven": [
    {
      "groupId": "commons-beanutils",
      "artifactId": "commons-beanutils",
      "version": "1.9.4"
    }
  ]
});
```

This approach provides the flexibility to load Java classes and dependencies at runtime.

## Classloader Recycling

Lucee automatically generates a unique hash based on the defined Java settings and maintains a pool of corresponding classloaders. This means that classloaders are reused efficiently, reducing resource consumption and improving performance.

## Reload On Change

The setting `this.javasettings.reloadOnChange` indicates whether to reload updated classes and JARs dynamically, without restarting Lucee. The default value is `false`.

```cfml
this.javasettings.reloadOnChange = false;
```

## Watch Interval

The setting `this.javasettings.watchInterval` defines the interval in seconds that Lucee looks for changes. The default value is `60`.

```cfml
this.javasettings.watchInterval = 60;
```

## Watch Extensions

The setting `this.javasettings.watchExtensions` defines the extensions Lucee looks for when you list a directory with `loadPaths` or `bundlePaths`. The default value is `["jar", "class"]`.

```cfml
this.javasettings.watchExtensions = ["jar", "class"];
```

## Conclusion

With the introduction of Maven support and the ability to define Java settings in multiple contexts such as `.CFConfig.json`, `Application.cfc`, components, and `createObject`, Lucee provides enhanced flexibility for integrating and managing Java libraries. These features help avoid conflicts and ensure that your Java dependencies are managed efficiently across various parts of your application.
