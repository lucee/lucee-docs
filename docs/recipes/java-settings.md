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
    "function-createobject",
    "maven",
    "java-libraries",
    "java-class-interaction"
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

### Limiting Transitive Dependencies (9.0+)

By default Lucee downloads a Maven dependency together with everything it depends on. Some libraries pull in a large tree of dependencies you don't need (for example Apache Tika 3). Two optional keys on a Maven entry limit what is downloaded:

- `transitive` - set to `false` to download only that artifact and none of its dependencies (default: `true`)
- `exclusions` - an array of `groupId:artifactId` entries that are skipped during resolution. `*` is a wildcard in either part, so `org.apache.logging.*:*` or `*:*-test` also work. A comma separated list is accepted as well.

An excluded artifact is not downloaded and neither are the dependencies only it would have brought in. Exclusions apply to the whole dependency tree of that entry, including dependencies inherited from a parent POM.

```cfml
// Application.cfc
this.javasettings.maven = [
	// only tika-core itself
	{
		"groupId": "org.apache.tika",
		"artifactId": "tika-core",
		"version": "3.0.0",
		"transitive": false
	},
	// everything except the excluded artifacts
	{
		"groupId": "org.apache.tika",
		"artifactId": "tika-parsers-standard-package",
		"version": "3.0.0",
		"exclusions": [ "org.bouncycastle:*", "org.apache.logging.log4j:*" ]
	}
];
```

The same keys work in the component `javasettings` attribute:

```cfml
component javasettings='{
	"maven": [
		{ "groupId": "org.apache.tika", "artifactId": "tika-core", "version": "3.0.0", "transitive": false }
	]
}' {
	// ...
}
```

and in `.CFConfig.json`:

```json
{
	"javasettings": {
		"maven": [
			{
				"groupId": "org.apache.tika",
				"artifactId": "tika-parsers-standard-package",
				"version": "3.0.0",
				"exclusions": [ "org.bouncycastle:*" ]
			}
		]
	}
}
```

They are also supported by [[function-mavenload]]. When you exclude or skip a dependency, you are responsible for providing any class the library needs at runtime, a missing class shows up as a `ClassNotFoundException` when it is first used. An invalid `transitive` value or exclusion that is not in the `groupId:artifactId` format throws an error.

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
