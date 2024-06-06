# Lucee Docker Setup

This example shows how to build a Lucee Docker image with a custom configuration.

## Files

- `Dockerfile`: Defines the Docker image for the Lucee server.
- `lucee-config.json`: the Lucee configuration, modify it as you like.
- `docker-compose.yml`: Defines the services and configurations to run the Lucee server build using Docker Compose.

## Dockerfile

The `Dockerfile` uses the `lucee/lucee:6.1.0.175-BETA` image and sets up a Lucee server with some pages. It includes instructions to create the necessary directory structure and copy the website files into the container.

### How to Build

To build the Docker image defined by the `Dockerfile`, navigate to the directory containing the file and execute this command `docker build -t lucee-with-config .`.

### How to Run

To run the Docker container created from the image, use this Docker's run command `docker run -d -p 8054:80 -p 8854:8888 -e LUCEE_ADMIN_PASSWORD=qwerty lucee-with-config`. The container will expose ports for Nginx and Tomcat, and you can set the Lucee admin password through environment variables. You can also start it with `docker compose` (see below).

## docker-compose.yml

The `docker-compose.yml` file defines a service for running the Lucee server created with `Dockerfile`. It specifies the image to use, environment variables, volume mappings, and port configurations. This is useful to map an external drive you can access and modify.

### How to Run

To run the services defined in the `docker-compose.yml` file, navigate to the directory containing the file and use this Docker Compose's up command `docker-compose up -d`. This will start the services in detached mode, exposing the necessary ports and setting the Lucee admin password as specified.
