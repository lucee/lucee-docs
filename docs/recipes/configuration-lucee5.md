
<!--
{
  "title": "Configuration Lucee 5",
  "id": "config",
  "categories": ["configuration"],
  "description": "Best practices for configuring Lucee 5 environments.",
  "keywords": ["configuration", "config", "lucee-server.xml", "lucee-web.xml", "Lucee 5"]
}
-->

# Configuration - Lucee 5

This guide provides best practices for configuring Lucee 5. While we highly recommend updating to Lucee 6 or above, 
you can refer to the [Lucee 6 Configuration Guide](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/configuration.md) for guidance. 

If an update is not feasible, this document outlines how to configure Lucee 5 effectively.

## Multiple Configurations

Lucee runs within a Servlet Engine (such as Tomcat), allowing you to manage multiple websites (or web contexts) within a single engine.
For example, you can host `lucee.org` and `whatever.org` on one Servlet Engine, each in its own web context.

Lucee 5 supports both a **global configuration** for the entire Servlet Engine and **separate configurations** for each web context.

- **Global configuration**: General settings for the engine.
- **Web context configuration**: Specific settings for each website (e.g., datasources).

## Configuration Hierarchy

Lucee follows a layered configuration hierarchy where each level extends or overrides the previous one:

1. **Environment variables/system properties**
2. **Server configuration (lucee-server.xml)**
3. **Web configuration (lucee-web.xml.cfm)**
4. **`Application.cfc`**

Each layer can modify the behavior of the lower layers.

## Environment Variables / System Properties

Lucee allows you to configure settings using environment variables or system properties. 
You can refer to the [Environment Variables and System Properties Documentation](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/environment-variables-system-properties.md) for details on available options.

A commonly used property is `LUCEE_ADMIN_PASSWORD`, which lets you set the server administrator password.

> **Note**: Some environment variables and system properties were introduced in Lucee 6 and may not be supported in Lucee 5.

### Placeholders in the XML Configuration

In Lucee 5, placeholders can be used in the configuration files to substitute environment variables or system properties. This is useful for sensitive data or configurations that vary between servers.

Example:

```xml
<data-sources>
  <data-source 
    host="localhost"
    username="{env:MYDS_USERNAME}"
    password="{system:myds.password}" 
    .../>
</data-sources>
```

Two types of placeholders are supported:

- **`{env:MYDS_USERNAME}`**: Refers to an environment variable.
- **`{system:myds.password}`**: Refers to a system property.

## Server Configuration

The global server configuration is typically located at `<installation>/lucee-server/context/lucee-server.xml`. 
The location of the `lucee-server` directory can be customized using the `LUCEE_SERVER_DIR` environment 
variable or the `-Dlucee.server.dir` system property.

At startup, Lucee reads this configuration, applying the settings. 
A best practice is to configure Lucee through the administrator, then export the 
`lucee-server.xml` file as a base for future installations.

Please have in mind that Lucee 5 is not able to resolve external resources like extensions like Lucee 6 is able to do.
You need to install extensions along with this configuration, for example by defining them as environment variables or placing them into the `lucee-server/deploy` folder.

## Web Configurations

Lucee creates a web configuration for each web context, with settings overriding the global 
server configuration.

By default, web configurations are stored at `<web-context>/WEB-INF/lucee/lucee-web.xml.cfm`. You can customize 
this location using the `LUCEE_WEB_DIR` environment variable or the `-Dlucee.web.dir` system property.

To avoid conflicts between web contexts, using placeholders for each context is necessary:

```bash
LUCEE_WEB_DIR="{web-root-directory}/whatever"
LUCEE_WEB_DIR="<whatever>/config/web/{web-context-hash}/"
LUCEE_WEB_DIR="<whatever>/config/web/{web-context-label}/"
```

## Pitfalls

### Logging in Server and Web Contexts

Logs are created for both the server and each web context. Most logs are generated in 
the web context, but some global logs may appear in the server context. Log configurations in the server config 
are not inherited by web contexts and must be set separately.

### Event Gateway

Event gateways can only be defined in the web context.

## Runtime Configuration (`Application.cfc`)

Lucee allows many settings to be defined dynamically at runtime via `Application.cfc`. These settings can include 
datasources, caches, and other configurations.

For every setting available in the Lucee administrator, there is often an equivalent setting in `Application.cfc`. 
If so, the Lucee administrator shows this below the setting as a "tip". You can also export an `Application.cfc` file 
with the administrator settings that are supported.

## Startup Listener

Lucee also supports startup listeners, which are triggered at startup. These listeners allow you to manipulate 
the configuration of your environment further. For example, you can use the `ConfigImport` function to dynamically 
import configurations during startup.

For more details, consult [Lucee Startup Listeners](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/startup-listeners-code.md).

## Best Practices

- **Early Configuration**: Set configurations in the server configuration rather than at runtime in `Application.cfc` 
whenever possible.
- **Use Placeholders for Sensitive Data**: Store sensitive information such as passwords, API keys, and database credentials 
in environment variables or system properties using placeholders.
