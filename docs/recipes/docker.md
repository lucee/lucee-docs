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
  ]
}
-->

# Docker Information

This document provides information about Docker and how to use it to run Lucee.

## Introduction to Docker

Docker is a platform that enables developers to automate the deployment, scaling, and management of applications using containerization. Containers are lightweight, standalone, and executable packages that include everything needed to run an application, such as the code, runtime, libraries, and system tools. This ensures consistency across multiple development and release cycles, as well as across diverse environments. By isolating applications in containers, Docker helps to avoid conflicts, streamline development workflows, and enhance the efficiency of resource utilization.

## What are the benefits of running Lucee in Docker

Running Lucee in Docker provides several key benefits:

- **Consistency and Portability**: Docker containers ensure that Lucee and its dependencies are packaged together, eliminating compatibility issues and reducing setup time. This makes it easier to develop, test, and deploy applications consistently across different environments.
- **Scalability**: Docker's lightweight nature allows for efficient scaling of Lucee applications. You can quickly scale up or down based on demand, making it ideal for both small and large-scale deployments.
- **Resource Efficiency**: Docker containers share the host system's kernel, which leads to efficient utilization of system resources and improved performance compared to traditional virtual machines.
- **Isolation**: By isolating applications in containers, Docker helps avoid conflicts between different applications running on the same host. This ensures that Lucee runs in a clean and controlled environment.

## Lucee Docker Images

The Lucee Docker images are built on top of Tomcat, providing a reliable and efficient environment to run Lucee applications. You can easily build your own images using the official Lucee images as a base.

### Example Dockerfile

```dockerfile
FROM lucee/lucee:latest

COPY config/lucee/ /opt/lucee/web/
COPY www /var/www
```

This example Dockerfile shows how to extend the official Lucee image by copying custom configuration files and web content into the container.

For more examples, you can visit the [Lucee Docker examples repository](https://github.com/lucee/lucee-docs/tree/master/examples/docker).

## Using Lucee Docker Images

The official Lucee Docker images are available on Docker Hub. You can find more details on how to use them and the available tags [here](https://hub.docker.com/r/lucee/lucee/).

### Pulling the Latest Lucee Image

To pull the latest Lucee image from Docker Hub, use the following command:

```sh
docker pull lucee/lucee:latest
```

### Running Lucee in a Docker Container

To run Lucee in a Docker container, use the following command:

```sh
docker run -d -p 8888:8888 lucee/lucee:latest
```

This command runs a new container in detached mode, mapping port 8888 of the container to port 8888 on the host machine.

### Customizing Your Lucee Container

You can customize your Lucee container by creating your own Dockerfile and adding your configurations and web files as shown in the example Dockerfile above.

### Advanced Usage with Docker Compose

For more complex setups, consider using Docker Compose to manage multiple services and their dependencies. Below is an example `docker-compose.yml` file to run Lucee with an Nginx reverse proxy:

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

This setup defines two services: `lucee` and `nginx`. The `lucee` service runs the Lucee server, while the `nginx` service runs Nginx as a reverse proxy.

## Conclusion

Using Docker to run Lucee simplifies the deployment process, ensures consistency across environments, and provides a scalable and efficient way to manage your Lucee applications. With the official Lucee Docker images and the ability to customize your own images, you can easily set up and manage your Lucee environment to meet your specific needs.
