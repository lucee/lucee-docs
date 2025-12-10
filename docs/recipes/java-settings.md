<!--
{
  "title": "JavaSettings in Application.cfc, Components and CFConfig.json",
  "id": "java-settings",
  "since": "6.2",
  "description": "Guide on configuring Java settings in Lucee using Application.cfc, including loading Java libraries from Maven",
  "keywords": [
    "Java settings",
    "Application.cfc",
    "javasettings",
    "cfapplication"
  ],
  "categories": [
    "java",
    "application"
  ],
  "related": [
    "tag-application",
    "tag-component",
    "function-createobject"
  ]
}
-->

# Java Settings

The `javasettings` configuration tells Lucee where to find Java libraries. You can load JARs from local paths, pull dependencies from Maven automatically, or use OSGi bundles for advanced modular deployments.

Configure it in `Application.cfc` (app-wide), on individual components (isolated), in `.CFConfig.json` (server-wide), or inline with `createObject`.

## Application.cfc

The most common approach - makes libraries available to your entire application:

```cfml
this.javasettings = {
	"maven": [
		{
			"groupId": "org.quartz-scheduler",
			"artifactId": "quartz",
			"version": "2.3.2"
		}
	],
	"loadPaths": [
		"/my/local/path/to/libs/",
		"/my/local/path/to/libs/example.jar"
	],
	"reloadOnChange": true,
	"watchInterval": 60,
	"watchExtensions": ["jar", "class"]
};
```

## Maven Dependencies (6.2+)

Pull libraries from Maven Central automatically - no manual JAR management:

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

### Shorthand Syntax

Use `group:artifact:version` strings for brevity:

```cfml
this.javasettings.maven = [
	"org.quartz-scheduler:quartz:2.3.2",
	"commons-beanutils:commons-beanutils:1.9.4"
];
```

Omit `version` for latest (e.g., `"commons-beanutils:commons-beanutils"`).

## Load Paths

Point to local JAR files or directories containing JARs:

```cfml
this.javasettings.loadPaths = [
	"/my/local/path/to/whatever/lib/",
	"/my/local/path/to/whatever/lib/xyz.jar"
];
```

## Bundle Paths

For OSGi bundles (modular JARs with explicit dependency metadata). Most applications don't need this - use `loadPaths` for regular JARs:

```cfml
this.javasettings.bundlePaths = [
	"/my/local/path/to/whatever/lib/",
	"/my/local/path/to/whatever/lib/xyz.jar"
];
```

## Component-Level

Isolate libraries to a single component. The attribute value must be a JSON string:

```cfml
component javasettings='{
	"maven": ["commons-beanutils:commons-beanutils:1.9.4"]
}' {
	// Only this component has access to beanutils
}
```

See [[java-libraries]] for more on using Maven dependencies in components.

## createObject

Load a library inline when creating a Java object:

```cfml
obj = createObject( "java", "org.apache.commons.beanutils.BeanUtils", {
	"maven": ["commons-beanutils:commons-beanutils:1.9.4"]
});
```

## .CFConfig.json

Server-wide settings in your CFConfig file:

```json
{
	"javasettings": {
		"maven": [
			"org.quartz-scheduler:quartz:2.3.2",
			"commons-beanutils:commons-beanutils:1.9.4"
		],
		"loadPaths": [
			"/my/local/path/to/libs/"
		]
	}
}
```

## Additional Settings

- `reloadOnChange` - Reload updated classes/JARs without restart (default: `false`)
- `watchInterval` - Seconds between change checks (default: `60`)
- `watchExtensions` - Extensions to watch (default: `["jar", "class"]`)

Lucee pools classloaders based on settings hash for efficient reuse.
