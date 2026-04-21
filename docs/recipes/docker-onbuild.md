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

Snapshot your `/mvn/` cache on a dev machine, commit the pom, rehydrate during the Docker build:

```cfml
// dev machine, after loading everything your app needs:
fileWrite( "/app/pom.xml", mavenExport() );
// commit /app/pom.xml
```

```cfml
// Server.cfc in the image
component {
    public function onBuild() {
        var q = mavenImport( "/app/pom.xml" );
        systemOutput( "Resolved " & q.recordcount & " dependencies", true );
    }
}
```

Round-trip is exact — the pom lists every cached jar including classifiers. See [[function-mavenexport]] / [[function-mavenimport]].

## Compiling a Mapping at Build Time

Precompiling every `.cfm` / `.cfc` under a mapping bakes bytecode into the image so first-hit requests don't pay compile cost. It also surfaces syntax errors in code paths your tests don't reach.

The `compileMapping` admin action does this. Against the web mapping `/`:

```cfml
component {
    public function onBuild() {
        admin
            action="compileMapping"
            type="web"
            password=request.adminPassword
            virtual="/"
            stoponerror="false";
    }
}
```

- `type="web"` compiles under a specific web context; `type="server"` walks the server-level mappings.
- `virtual="/"` is the mapping name — pass a specific virtual path (e.g. `/app`) to limit the scope.
- `stoponerror="false"` logs compile errors and continues. Set `true` to fail the build on the first bad file.

Same pattern as the [script-runner](https://github.com/lucee/script-runner) `-Dcompile=true` flag, which uses this exact admin action to smoke-test a webroot against a given Lucee version. See [[cfadmin-docs]] for the full list of admin actions.
