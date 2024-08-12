
# Lucee Docker Setup with Custom Extensions

This repository demonstrates how to build a Lucee Docker image with custom extensions bundled.

## Files

### Dockerfile

Defines the Docker image for the Lucee server. It includes steps to copy website files, a custom Lucee configuration, and extensions into the appropriate directories.

### lucee-config.json

Contains the Lucee server configuration, including the definition of extensions. Extensions can be defined in various ways:

#### Example with Local Path

The extensions array can specify the path to the extension file within the container.

```json
"extensions": [
    {
        "name": "Redis",
        "path": "/opt/lucee/web/lucee-server/context/extensions/redis.extension-3.0.0.51.lex"
    }
]
```

- **name**: Optional, makes it easier to read.
- **path**: Points to the local directory where the extension is located within the container.

#### Example with URL

The extensions array can also specify the URL from which to download the extension. Note that Lucee needs internet access to download the extension.

```json
"extensions": [
    {
        "url": "https://ext.lucee.org/redis.extension-3.0.0.51.lex"
    }
]
```

#### Example with Extension ID

You can define the extension by its ID. Lucee will download the extension from the Extension Provider or directly from Maven, depending on the Lucee version.

```json
"extensions": [
    {
        "id": "60772C12-F179-D555-8E2CD2B4F7428718"
    }
]
```

### extensions/redis.extension-3.0.0.51.lex

The extension file itself. Place any extensions you want to bundle in this directory.

## Directory Structure

Your project directory should look like this:

```
your-project-directory/
│
├── Dockerfile
├── docker-compose.yml
├── lucee-config.json
├── www/
│   └── [your website files]
└── extensions/
    └── redis.extension-3.0.0.51.lex
```

## Usage

### Building the Docker Image

To build the Docker image, navigate to the directory containing the `Dockerfile` and run:

```sh
docker build -t lucee-with-config .
```

### Running the Docker Container

To run the Docker container, use the following command:

```sh
docker run -d -p 8054:80 -p 8854:8888 -e LUCEE_ADMIN_PASSWORD=qwerty lucee-with-config
```

This command will start the container, exposing port 80 for Nginx and port 8888 for Tomcat, with the Lucee admin password set to `qwerty`.

### Using Docker Compose

If you prefer to use Docker Compose, you can define the services and configurations in `docker-compose.yml`. Here is an example:

```yaml
version: '3'
services:
  lucee:
    build: .
    environment:
      - LUCEE_ADMIN_PASSWORD=qwerty
    volumes:
      - "./www:/var/www"
      - "./extensions:/opt/lucee/web/lucee-server/context/extensions"
    ports:
      - "8054:80"   # nginx
      - "8854:8888" # tomcat
```

To start the services, navigate to the directory containing the `docker-compose.yml` file and run:

```sh
docker-compose up -d
```

This will build and start the services in detached mode, exposing the necessary ports and setting the Lucee admin password.

## Summary

This setup provides a flexible way to configure and extend the Lucee server using Docker and Docker Compose.
