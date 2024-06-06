# Docker Example

This repository contains various directories, each showcasing different configurations and setups for building Lucee Docker containers. These examples demonstrate the flexibility and possibilities available when setting up Lucee.

## Directories

### 1. basic

The simplest version possible. This setup uses the default configuration and includes no additional extensions or customizations.

### 2. with-config

This version includes a custom configuration file (`lucee-config.json`). It demonstrates how to configure the Lucee server with specific settings tailored to your needs.

### 3. with-extension

This version bundles custom extensions with the Lucee server. It shows how to include additional functionalities and features by integrating custom extensions.

## Usage

Each directory contains everything you need to build and run a Lucee server with the specified setup. Navigate to the desired directory and follow the instructions provided within to build and run the Docker container.

### Building the Docker Image

To build the Docker image for any setup, navigate to the corresponding directory and run:

```sh
docker build -t lucee-custom .
```
