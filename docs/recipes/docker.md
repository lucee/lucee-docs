<!--
{
  "title": "Docker",
  "id": "Docker",
  "description": "Guide on using and running Lucee with Docker",
  "keywords": [
    "Docker",
    "commandbox",
    "installation",
    "kubernetes"
  ],
  "categories": [
    "server"
  ]
}
-->

# Docker

Guide on running Lucee with Docker.

## Benefits

- **Consistency**: Lucee and dependencies packaged together - works the same everywhere
- **Scalability**: Lightweight containers scale quickly based on demand
- **Resource Efficiency**: Containers share host kernel - better performance than VMs
- **Isolation**: No conflicts between applications on same host

## Lucee Docker Images

Official images are built on Tomcat. Extend them for your own apps:

```dockerfile
FROM lucee/lucee:latest

COPY config/lucee/ /opt/lucee/web/
COPY www /var/www
```

More examples: [Lucee Docker examples repository](https://github.com/lucee/lucee-docs/tree/master/examples/docker).

## Using Lucee Docker Images

Available on [Docker Hub](https://hub.docker.com/r/lucee/lucee/).

### Pull

```sh
docker pull lucee/lucee:latest
```

### Run

```sh
docker run -d -p 8888:8888 lucee/lucee:latest
```

Runs detached, mapping container port 8888 to host port 8888.

### Docker Compose

Example with Nginx reverse proxy:

```yaml
version: "3"

services:
  lucee:
    image: lucee/lucee:latest
    ports:
      - "8888:8888"
    volumes:
      - ./www:/var/www
      - ./config/lucee:/opt/lucee/web

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - lucee
```

Defines two services: `lucee` runs the server, `nginx` runs as reverse proxy.

## LUCEE_BUILD Environment Variable

Set `LUCEE_BUILD=true` to prewarm Lucee during image build - loads configurations and prepares for deployment. The `onBuild` function in `Server.cfc` runs during this phase for setup tasks (validating configs, copying files, compiling/encrypting source).

### Example Dockerfile

```dockerfile
FROM lucee/lucee:latest

# Copy your Server.cfc into the appropriate directory
COPY Server.cfc /opt/lucee-server/context/context/Server.cfc

# Set the environment variable to trigger onBuild
ENV LUCEE_BUILD=true

# Expose necessary ports
EXPOSE 8888

# Start Lucee server
COPY supporting/prewarm.sh /usr/local/tomcat/bin/
RUN chmod +x /usr/local/tomcat/bin/prewarm.sh
RUN /usr/local/tomcat/bin/prewarm.sh 6.1
```

Get `prewarm.sh` from [lucee-dockerfiles](https://github.com/lucee/lucee-dockerfiles).

### Example Server.cfc

```lucee
// lucee-server\context\context\Server.cfc
component {
	public function onBuild() {
		systemOutput("------- Building Lucee (Docker) -----", true);
	}
}
```

## Redirecting Logs to Docker Console

Since Lucee 6.2, redirect logs to Docker console:

```dockerfile
ENV LUCEE_LOGGING_FORCE_APPENDER=console
ENV LUCEE_LOGGING_FORCE_LEVEL=info
```

Or use symlinks:

```dockerfile
RUN ln -sf /proc/1/fd/1 /opt/lucee/server/lucee-server/context/logs/application.log \
&& ln -sf /proc/1/fd/1 /opt/lucee/server/lucee-server/context/logs/deploy.log \
&& ln -sf /proc/1/fd/1 /opt/lucee/server/lucee-server/context/logs/exception.log
```

Or configure via Lucee Admin (Settings > Logging) and select Console appender.

## Performance Tips

Avoid configuring directories under `lucee-server` as docker volumes - the host filesystem overhead causes performance problems.
