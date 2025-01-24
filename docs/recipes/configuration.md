
<!--
{
  "title": "Configuration - CFConfig.json",
  "id": "config",
  "categories": ["configuration"],
  "description": "Best practices for configuring Lucee in various environments.",
  "keywords": ["configuration", "config", ".CFConfig.json", "lucee-server.xml", "lucee-web.xml"],
  "categories":[
    "server"
  ],
  "related": [
    "function-configimport",
    "tag-application"
  ]
}
-->

# Configuration - How to Configure Lucee

This guide outlines best practices for configuring Lucee across different environments. While Lucee includes an 
administrator frontend (`<your-website>/lucee/admin.cfm`), this guide focuses on configuring Lucee using 
environment variables, configuration files, and `Application.cfc`. The goal is to explore various configuration 
possibilities rather than providing one definitive approach. Since Lucee 6, configuration has shifted to JSON 
files (`.CFConfig.json`), replacing the older XML-based configurations. This guide focuses on Lucee 6 and onwards.

## Single Mode vs Multi Mode

Lucee runs within a Servlet Engine (such as Tomcat), allowing you to manage multiple websites (or web contexts) 
within a single engine. For example, you can host `lucee.org` and `whatever.org` on one Servlet Engine, each 
in its own web context.

Lucee 6 provides two configuration modes:

- **Single Mode**: A single configuration for the entire Servlet Engine.
- **Multi Mode**: A global configuration for the engine, with separate configurations for each web context.

In **multi mode**, general configurations are made in the server configuration, while specific settings 
(e.g., datasources) can be defined for each web context. This was the only option up until Lucee 5.

Starting with **Lucee 6**, you can choose between single or multi mode. Single mode simplifies configuration 
by providing just one server configuration. Lucee 7 will exclusively support single mode.

### Single or Multi Mode?

- **Upgrading from Lucee 5**: Lucee will migrate your XML configuration to JSON and run in multi mode by default.
- **New Installations**: Lucee will run in single mode by default.

You can toggle between "multi" and "single" modes using the Lucee administrator or by adjusting the server 
configuration file (`.CFConfig.json`). In the administrator, you can merge all the settings from web contexts 
into a single server configuration. Simply switching the mode flag without merging will result in losing 
web context configurations (though Lucee keeps them in place).

```json
{
  "mode": "single|multi"
}
```

## Configuration Hierarchy

Lucee follows a configuration hierarchy:

1. **Environment variables/system properties**
2. **Server configuration JSON**
3. **Web configuration JSON**
4. **`Application.cfc`**
5. **Per Request**

Each level extends or overrides the previous one.

## Environment Variables / System Properties

The following document details all the possible system properties available in Lucee: 
[Environment Variables and System Properties](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/environment-variables-system-properties.md).

One commonly used property is `LUCEE_ADMIN_PASSWORD`, which allows you to set the server administrator password.

### Placeholders in JSON Configuration

Placeholders can be used in `.CFConfig.json` to substitute environment variables or system properties. This is 
useful for sensitive data or configurations that differ between servers.

Example:

```json
{
  "dataSources": {
    "myds": {
      "host": "localhost",
      "username": "{env:MYDS_USERNAME}",
      "password": "${MYDS_PASSWORD}",
      "url": "{system:myds.url}"
    }
  }
}
```

Three types of placeholders are supported:

- **`${MYDS_PASSWORD}`**: Can be an environment variable or system property.
- **`{env:MYDS_USERNAME}`**: Refers to an environment variable.
- **`{system:myds.url}`**: Refers to a system property.

## Server Configuration

The global server configuration is typically located at `<installation>/lucee-server/context/.CFConfig.json`. 
The location of the `lucee-server` directory can be customized using the `LUCEE_SERVER_DIR` environment 
variable or the `-Dlucee.server.dir` system property.

At startup, Lucee reads this configuration, applying the settings and resolving resources (e.g., extensions, 
Maven endpoints, etc.). A best practice is to configure Lucee through the administrator, then export the 
`.CFConfig.json` file as a base for future installations.

## Web Configurations

In **multi mode**, Lucee creates a web configuration for each web context, with settings overriding the global 
server configuration.

By default, web configurations are stored at `<web-context>/WEB-INF/lucee/.CFConfig.json`. You can customize 
this location using the `LUCEE_WEB_DIR` environment variable or the `-Dlucee.web.dir` system property.

To avoid conflicts between web contexts, using placeholders for each context is necessary:

```bash
LUCEE_WEB_DIR="{web-root-directory}/whatever"
LUCEE_WEB_DIR="<whatever>/config/web/{web-context-hash}/"
LUCEE_WEB_DIR="<whatever>/config/web/{web-context-label}/"
```

## Update Configuration

When starting a new Lucee version without an existing configuration, Lucee will automatically generate a base configuration. 
If you place a configuration in the server directory, Lucee will use that one instead.

In Lucee 6.0 (no longer the case for Lucee 6.1.1), placing an empty configuration file may cause problems because Lucee 
requires certain default settings to operate properly. For instance, Lucee needs the virtual filesystem for "zip" to 
read zip files.

Starting with Lucee 6.1.1, you can update existing configurations by placing a configuration file in the `lucee-server/deploy` 
folder. Lucee will automatically pick up the file at startup or within a minute after startup, applying the configuration 
updates. Only the configurations you add will be applied—Lucee does not overwrite the entire configuration. You can also 
change the location of the deploy folder using the `LUCEE_SERVER_DIR` environment variable. See the **Server Configuration** 
section for details.

## Pitfalls in Multi Mode Environments

### Logging in Server and Web Contexts

In **multi mode**, logs are created for both the server and each web context. Most logs are generated in 
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
- **Single Mode**: If you only have one website, use single mode to simplify management. Lucee 7 will remove multi mode.
- **Use Placeholders for Sensitive Data**: Store sensitive information such as passwords, API keys, and database credentials 
in environment variables or system properties using placeholders.
