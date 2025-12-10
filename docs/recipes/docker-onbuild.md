<!--
{
  "title": "onBuild Function in Server.cfc",
  "id": "onbuild-function",
  "related": [
    "startup-listeners-code"
  ],
  "since": "6.1.1",
  "categories": [
    "server",
    "docker",
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
