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

The `onBuild` function in `Server.cfc` is designed for executing specific tasks during the build phase of a Lucee server, which is particularly useful in Docker environments. This function allows you to automate various setup tasks that need to be completed when building your Lucee server image.

## Understanding Server.cfc

`Server.cfc` is a component that can be created in the `lucee-server\context\context` directory. It contains lifecycle event functions that are triggered during the startup of the Lucee server. The `onBuild` function within this component is called when you start Lucee with specific flags or environment variables indicating a build phase.

### When is Server.cfc Triggered?

- **onServerStart**: Triggered when the Lucee server starts.
- **onBuild**: Triggered during the build phase, particularly useful in Docker environments. Set the environment variable `LUCEE_BUILD` to `true` or use the system property `-Dlucee.build` to activate this function.

## Creating the Server.cfc File

To use the `onBuild` function, create a `Server.cfc` file in the `lucee-server\context\context` directory.

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

## Using onBuild with Docker

To leverage the `onBuild` function in a Docker environment, set the environment variable `LUCEE_BUILD` to `true` or use the system property `-Dlucee.build`.

### Dockerfile Example

Here's an example of how you might configure your Dockerfile to use the `onBuild` function:

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

## Footnotes

For more information on configuring and using Lucee with Docker, refer to the [Lucee Docker documentation](https://docs.lucee.org/guides/running-lucee/docker.html).
