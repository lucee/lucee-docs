<!--
{
  "title": "Single Mode vs Multi Mode",
  "id": "single-vs-multi-mode",
  "description": "Understanding the differences between Single mode and Multi mode in Lucee.",
  "keywords": [
    "Lucee",
    "Single Mode",
    "Multi Mode",
    "Configuration"
  ],
  "categories": [
    "server"
  ],
  ["related":
    "lucee_7_overview"
  ]
}
-->

# Single Mode vs Multi Mode in Lucee

Lucee offers two modes of operation: **Single Mode** and **Multi Mode**.

While Multi Mode has been the default in earlier versions, Single Mode presents several advantages, especially for setups that do not rely on multiple web contexts with individual configurations.

## History

Adobe Coldfusion has always been single mode and never supported multi mode.

- **Lucee 5**: Only supported Multi Mode.
- **Lucee 6**: Introduced Single Mode. New installations start in Single Mode by default. However, if upgrading from Lucee 5, the system remains in Multi Mode unless manually changed.
- **Lucee 7**: Only supports Single mode - [[lucee_7_overview]]

A long time ago, in a galaxy far, far away...

Servers were expensive, memory was also scarce, Docker didn't exist and it was quite common for shared hosting to run many clients on the same server, so Lucee solved this problem with Multi Mode.

Really should have been a Star Trek reference, as Ralio, the project Lucee was forked from, was named after [Rhylo](https://memory-alpha.fandom.com/wiki/Rhylo)

The name Lucee was inspired by the Film [Lucy](https://en.wikipedia.org/wiki/Lucy_(2014_film)), a machine which took over the world.

## What is Multi Mode?

Multi Mode allows for separate configurations for each web context.

This is beneficial when running multiple web applications on a single server that require different settings, however, this flexibility introduces complexity in configuration, logging, and maintenance.

For example, in multi-mode the Lucee Admins have colour themes, Red is the Server Admin, Blue is the Web Admin.

If you only every do configuration under the Red Server Admin, you are already quite close to using Lucee in single mode.

## What is Single Mode?

Single Mode consolidates all configurations into a single context.

This is ideal for environments where multiple web contexts are unnecessary.

Instead of maintaining separate configurations for each context, Single Mode simplifies operations by unifying them into one.

## Key Differences

- All hosts served by a Lucee instance share the same Application name space, so `myapp` on `host1` is the same as `myapp` on `host2`, consider using `cgi.http_host` etc as part of the application name, if required
- Mappings are the same across all hosts, so any application specific mappings should be done in `Application.cfc`, where as previously you might have done them in the Web Context Admin
- mod_cfml is still required in single mode when using multiple hosts with Apache
- Lower memory usage, as there is only one Lucee instance in single mode, less memory is required
- One single common log directory

### **Configuration**

- **Multi Mode**: Separate configurations exist for each web context and the server context. Some settings may overlap or conflict, leading to potential confusion.
- **Single Mode**: All configurations are unified in a single context. This eliminates ambiguity and simplifies administration, including having only one Lucee Administrator.

### **Scheduled tasks**

As there is only one namespace in single mode, check that the naming of scheduled tasks don't overlap when migrating to single mode.

### **Logging**

- **Multi Mode**: Logs are divided between web context logs (e.g., request logs) and server context logs (e.g., global actions like tasks).
- **Single Mode**: All logs are centralized under the server context, providing a clearer and more streamlined view of system activity.

### **Performance**

- **Multi Mode**: Startup times are longer due to the need to load configurations for multiple web contexts.
- **Single Mode**: Faster startup times as only a single configuration is loaded.

### **Future Compatibility**

- **Multi Mode**: Supported in Lucee 6.x, it was removed in Lucee 7.
- **Single Mode**: The default in Lucee 6.x and the only option with Lucee 7.0, making it the more future-proof choice.

## Switching Between Modes

You can easily switch between Single Mode and Multi Mode through the Lucee Administrator or directly in the configuration file.

### Using the Lucee Administrator

1. Go to the overview page.
2. At the top, you can see the current mode with an option to switch to the other mode below it. In Multi Mode, you can also choose to either merge all configurations into one or use only the server configuration.

### Using `.CFConfig.json`

- Add or modify the `mode` flag in the configuration file (.CFConfig.json):

```json
{
  "mode": "single"
}
```

```json
{
  "mode": "multi"
}
```

- Note: Switching via this method does not support merging configurations.

## Why Choose Single Mode?

For setups like ours, where multiple web contexts with individual configurations are not needed, Single Mode provides significant benefits:

- **Simplified Configuration**: Easier to manage and eliminates redundant settings.
- **Unified Logging**: Clearer and more efficient logging.
- **Better Performance**: Faster startup times.
- **Future-Proof**: Prepares for Lucee 7, which will no longer support Multi Mode.

## Conclusion

Single Mode simplifies the overall management of Lucee, reduces complexity, and aligns with the future direction of the platform.

Unless you explicitly need Multi Mode for multiple web contexts, Single Mode is the recommended approach for most environments.
