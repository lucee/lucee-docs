<!--
{
  "title": "Extension Installation",
  "id": "extension-installation",
  "since": "6.1",
  "description": "A comprehensive guide on how to install extensions in Lucee.",
  "keywords": [
    "extension",
    "install",
    "lucee administrator",
    "deploy directory",
    "CFConfig.json",
    "environment variable",
    "system property",
    "hot deployment",
    "automation"
  ]
}
-->

# Extension Installation

In Lucee, there are multiple ways to install an extension. This recipe will show you all the possibilities along with their pros and cons.

## Lucee Administrator

You can install an extension in the Lucee Administrator by navigating to Extensions/Applications in the Lucee (Server) Administrator and installing or uninstalling the extension you need.

### Pros

- No physical access to the server needed
- User-friendly interface
- Immediate feedback on the installation process

### Cons

- Manual process that is not easily repeatable
- Requires access to the Lucee Administrator interface

## `deploy` Directory

Simply copy the extension you want to install into the folder `{lucee-installation}/lucee-server/deploy`. Lucee will pick it up at startup or within a minute after startup and install it. You can find extensions to install under [download.lucee.org](https://download.lucee.org).

### Pros

- Hot deployment on a running server possible with no restart needed (except for some extensions)
- Can be automated with scripts

### Cons

- Requires physical or SSH access to the server
- Some extensions may require a restart to work properly

## `.CFConfig.json` Configuration (Lucee 6 Only)

With Lucee 6, you can define the extensions you need in the `.CFConfig.json` file that holds all your configurations.

```json
{
    "extensions": [
        {
            "name": "Websocket",
            "id": "07082C66-510A-4F0B-B5E63814E2FDF7BE",
            "version": "1.0.0.11"
        },
        {
            "name": "Redis",
            "path": "/opt/lucee/extensions/redis.extension-3.0.0.51.lex",
            "id": "60772C12-F179-D555-8E2CD2B4F7428718"
        },
        {
            "name": "S3 Resource Extension",
            "id": "17AB52DE-B300-A94B-E058BD978511E39E",
            "path": "https://ext.lucee.org/s3-extension-2.0.1.25.lex"
        }
    ]
}
```

You can define the `id` and `version` like in the first example (name is always optional), or provide a local path to the extension. Lucee supports virtual filesystems, so you can also define a virtual filesystem path, such as "https", "s3", or "ftp".

On a fresh install of Lucee, Lucee will install the [bundled extensions](https://github.com/lucee/Lucee/blob/6.1/core/src/main/java/META-INF/MANIFEST.MF#L364) in addition to these extensions and update the `.CFConfig.json` file. On an existing installation, Lucee will remove all extensions installed that are not on this list.

With Lucee 6.1, the "id" attribute is no longer necessary when you define a path.

### Important Notes for Multi-Mode (Server and Web Admin Enabled)

- If you run Lucee in Multi-Mode (Server and Web Admin enabled), you need to add the extension configuration to the root of the server context JSON file located at `{lucee-installation}/lucee-server/context/.CFConfig.json` and not in the web context JSON file.

### Pros

- You can automate the process
- Easy to manage configurations and extensions in one place

### Cons

- No hot deployment
- Requires configuration file management

## Environment Variable / System Property

You can also define the extension in an environment variable or system property. This option is similar to the `.CFConfig.json` option.

Define a comma-separated list of Lucee extensions to install when starting up. This can be a simple list of IDs, in which case the latest versions will be installed:

```plaintext
99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6,
671B01B8-B3B3-42B9-AC055A356BED5281,
2BCD080F-4E1E-48F5-BEFE794232A21AF6
```

Or with more specific information like version and label (for better readability):

```plaintext
99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6;name=MSSQL;label=MS SQL Server;version=12.2.0.jre8,
671B01B8-B3B3-42B9-AC055A356BED5281;name=PostgreSQL;label=PostgreSQL;version=42.7.3,
2BCD080F-4E1E-48F5-BEFE794232A21AF6;name=JDTsSQL;label=jTDS (MSSQL);version=1.3.1
```

You can also define a path to the extension in the same way as with `.CFConfig.json`:

```plaintext
60772C12-F179-D555-8E2CD2B4F7428718;name=Redis;path=/opt/lucee/extensions/redis.extension-3.0.0.51.lex,
17AB52DE-B300-A94B-E058BD978511E39E;name=S3 Resource Extension;path=https://ext.lucee.org/s3-extension-2.0.1.25.lex
```

### Setting System Property

To set a system property for Lucee extensions, you can use the `-D` option with the Java command that starts your Lucee server.

Example command to start Lucee with system properties:

```plaintext
java -Dlucee.extensions="99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6;name=MSSQL;version=12.2.0.jre8,671B01B8-B3B3-42B9-AC055A356BED5281;name=PostgreSQL;version=42.7.3" -jar lucee.jar
```

### Pros

- Can be used in various deployment environments (e.g., Docker, cloud services)
- Supports automation and infrastructure as code practices

### Cons

- No hot deployment
- Requires setting environment variables or system properties, which might be complex in some environments

## Logging and Troubleshooting

If you encounter issues while installing extensions, you can check the log at `{lucee-installation}/lucee-server/context/logs/deploy.log` not only for any errors reported but also to see what actions were performed. This log is by default set to info level and should contain all details about the installation process.

## Conclusion

Lucee offers several methods to install extensions, each with its own advantages and disadvantages. Choose the method that best fits your deployment and management workflow:

- **Lucee Administrator**: Best for manual, ad-hoc installations.
- **`deploy` Directory**: Good for automated deployments with script support.
- **`.CFConfig.json` Configuration**: Ideal for managing configurations and extensions together.
- **Environment Variable / System Property**: Suitable for modern deployment environments like Docker and cloud services.

By understanding the pros and cons of each method, you can effectively manage Lucee extensions in your environment.
