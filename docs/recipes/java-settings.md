<!--
{
  "title": "Java Settings in Application.cfc",
  "id": "java-settings",
  "description": "Guide on configuring Java settings in Lucee using Application.cfc",
  "keywords": [
    "Java settings",
    "Application.cfc",
    "javasettings",
    "cfapplication"
  ]
}
-->

# Java Settings in Application.cfc

This document provides information about configuring Java settings in Lucee using `Application.cfc` or the `<cfapplication>` tag.

## Introduction

The `this.javasettings` settings in `Application.cfc` allow you to define Java library paths, OSGi bundle paths, and other Java-related configurations. These settings cannot be configured through the Lucee admin or environment variables.

## Configuring Java Settings

You can configure Java settings in `Application.cfc` or using the `<cfapplication>` tag. Below are the details of each available setting.

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

### Load CFML Class Path

The setting `this.javasettings.loadCFMLClassPath` (an alias for compatibility with Adobe ColdFusion `this.javasettings.loadColdFusionClassPath`) indicates whether to load the classes from the main lib directory. The default value is `false`.

```cfml
this.javasettings.loadCFMLClassPath = false;
```

### Reload On Change

The setting `this.javasettings.reloadOnChange` indicates whether to reload the updated classes and JARs dynamically, without restarting ColdFusion. The default value is `false`.

```cfml
this.javasettings.reloadOnChange = false;
```

### Watch Interval

The setting `this.javasettings.watchInterval` defines the interval in seconds that Lucee looks for changes. The default value is `60`.

```cfml
this.javasettings.watchInterval = 60;
```

### Watch Extensions

The setting `this.javasettings.watchExtensions` defines the extensions Lucee looks for when you list a directory with `loadPaths` or `bundlePaths`. The default value is `["jar","class"]`.

```cfml
this.javasettings.watchExtensions = ["jar", "class"];
```

## Using `<cfapplication>` Tag

You can also configure these settings using the `<cfapplication>` tag.

```cfml
<cfapplication 
    action="update"
    javasettings="#{
        loadPaths: [
            '/my/local/path/to/whatever/lib/',
            '/my/local/path/to/whatever/lib/xyz.jar'
        ],
        bundlePaths: [
            '/my/local/path/to/whatever/lib/',
            '/my/local/path/to/whatever/lib/xyz.jar'
        ],
        loadCFMLClassPath: false,
        reloadOnChange: false,
        watchInterval: 60,
        watchExtensions: ['jar', 'class']
    }#"
/>
```

## Conclusion

Configuring Java settings in Lucee through `Application.cfc` or the `<cfapplication>` tag provides flexibility in managing Java libraries and bundles. By setting these configurations, you can ensure that your Lucee applications are properly integrated with the necessary Java dependencies and can dynamically respond to changes as needed.
