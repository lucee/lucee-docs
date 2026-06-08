# Docker Example

This repository contains various directories, each showcasing different configurations and setups for building Lucee Docker containers. These examples demonstrate the flexibility and possibilities available when setting up Lucee.

## basic

The simplest version possible. This setup uses the default configuration and includes no additional extensions or customizations.

## with-config

This version includes a custom configuration file (`lucee-config.json`). It demonstrates how to configure the Lucee server with specific settings tailored to your needs.

## with-extension

This version bundles custom extensions with the Lucee server. It shows how to include additional functionalities and features by integrating custom extensions.

## mcp

Lucee 7 with the [MCP Server extension](https://github.com/lucee/extension-mcp-server) and [Lucene Search extension](https://github.com/lucee/extension-lucene) installed at startup. Exposes JSON-RPC at `/lucee/mcp/` with function/tag lookup and Lucene search (recipes fetched live from GitHub). Interactive test console at `/test/`.

## s3-minio

Lucee 7 with the S3 extension working against a local MinIO instance.

# Usage

Each directory contains everything you need to build and run a Lucee server with the specified setup. Navigate to the desired directory and follow the instructions provided within to build and run the Docker container.

## Building the Docker Image

To build the Docker image for any setup, navigate to the corresponding directory and run:

```sh
docker build -t lucee-custom .
```
