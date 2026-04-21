<!--
{
  "title": "onBuild Function in Server.cfc",
  "id": "onbuild-function",
  "related": [
    "startup-listeners-code",
    "warmup"
  ],
  "since": "6.1.1",
  "categories": [
    "server",
    "docker",
    "devops",
    "system"
  ],
  "description": "The onBuild function in Server.cfc is used for tasks during the build phase in Lucee, particularly useful in Docker environments.",
  "menuTitle": "onBuild Function",
  "keywords": [
    "onBuild",
    "Server.cfc",
    "build",
    "Docker",
    "server",
    "compile",
    "encrypt",
    "validate",
    "prewarm",
    "warmup",
    "startup",
    "hook",
    "event"
  ]
}
-->

# onBuild Function in Server.cfc

The `onBuild` function in `Server.cfc` executes tasks during the build phase - particularly useful in Docker environments for automating setup tasks when building your image.

## Server.cfc Lifecycle Events

Create `Server.cfc` in `lucee-server\context\context`:

- **onServerStart**: Triggered when Lucee starts
- **onBuild**: Triggered during build phase. Set `LUCEE_BUILD=true` or `-Dlucee.build` to activate

## Example Server.cfc

```lucee
// lucee-server\context\context\Server.cfc
component {
	public function onBuild() {
		systemOutput("------- Building Lucee (Docker) -----", true);
		// Example tasks during build
		validateConfiguration();
		copyFilesInPlace();
		compileSourceCode();
		encryptSourceCode();
	}

	private function validateConfiguration() {
		systemOutput("Validating server configuration...", true);
		// Add validation logic here
	}

	private function copyFilesInPlace() {
		systemOutput("Copying necessary files...", true);
		// Add file copying logic here
	}

	private function compileSourceCode() {
		systemOutput("Compiling source code...", true);
		// Add source code compilation logic here
	}

	private function encryptSourceCode() {
		systemOutput("Encrypting source code...", true);
		// Add source code encryption logic here
	}
}
```

## Dockerfile Example

```dockerfile
FROM lucee/lucee:latest

# Copy your Server.cfc into the appropriate directory
COPY Server.cfc /opt/lucee-server/context/context/Server.cfc

# Set the environment variable to trigger onBuild
ENV LUCEE_BUILD true

# Expose necessary ports
EXPOSE 8888

# Start Lucee server
COPY supporting/prewarm.sh /usr/local/tomcat/bin/
RUN chmod +x /usr/local/tomcat/bin/prewarm.sh
RUN /usr/local/tomcat/bin/prewarm.sh 6.1
```

You can find the `prewarm.sh` file [here](https://github.com/lucee/lucee-dockerfiles).
When the Docker container is built, the `onBuild` function will execute, performing any tasks you've defined in the function.

## Warming the Maven Cache at Build Time

> **Since 7.1.0.98** ([LDEV-6280](https://luceeserver.atlassian.net/browse/LDEV-6280))

If your app uses [[maven|Maven-loaded Java libraries]], by default those jars are downloaded on first use at **runtime**. That's fine for dev, but in Docker you want the jars baked into the image — no network on container start, no first-request latency while POI downloads.

`onBuild` is the hook for this. Three patterns, pick the one that fits:

### Pattern 1: Import from a committed pom

Snapshot your `/mvn/` cache once (on a dev machine), commit the pom, rehydrate during the Docker build:

```cfml
// dev machine, after loading everything your app needs:
mavenLoad( "org.apache.poi:poi-ooxml:5.2.5" );
mavenLoad( "com.google.guava:guava:32.1.3-jre" );
mavenExport( "/app/mvn-cache.xml" );
// commit /app/mvn-cache.xml
```

```cfml
// Server.cfc in the image
component {
    public function onBuild() {
        systemOutput( "Rehydrating Maven cache...", true );
        var q = mavenImport( "/app/mvn-cache.xml" );
        systemOutput( "Resolved " & q.recordcount & " dependencies", true );
    }
}
```

Round-trip is exact — the pom lists every cached jar including classifiers. See [[function-mavenexport]] / [[function-mavenimport]].

### Pattern 2: Explicit list, guarded by `mavenExists`

If you'd rather keep the dependency list in CFML (readable in the diff, no pom file to maintain):

```cfml
component {
    public function onBuild() {
        var deps = [
            "org.apache.poi:poi-ooxml:5.2.5",
            "com.google.guava:guava:32.1.3-jre",
            "org.quartz-scheduler:quartz:2.3.2"
        ];
        for ( var coord in deps ) {
            if ( !mavenExists( coord ) ) {
                systemOutput( "Loading " & coord, true );
                mavenLoad( coord );
            }
        }
    }
}
```

[[function-mavenexists]] is a cheap filesystem check — safe to call on every build without paying for tree resolution.

### Pattern 3: Let `javaSettings` do the work

If your `Application.cfc` / `.CFConfig.json` already declares `javaSettings.maven`, you can just trigger resolution once in `onBuild` by touching the components that use them — whatever Lucee resolves gets cached on disk and survives into the runtime image.

### Auditing the image

After the build, `mavenExport` against the image's `/mvn/` dir gives you an exact manifest of what shipped — useful for reproducible-build audits and for diffing between image versions:

```cfml
mavenExport( "/app/mvn-cache-actual.xml" );
// compare against the committed /app/mvn-cache.xml
```
