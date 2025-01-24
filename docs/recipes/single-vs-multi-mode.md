<!--
{
  "title": "Single Mode vs Multi Mode",
  "id": "single-vs-multi-mode",
  "description": "Understanding the differences between single mode and multi mode in Lucee.",
  "keywords": [
    "Lucee",
    "Single Mode",
    "Multi Mode",
    "Configuration"
  ],
  "categories": [
    "server"
  ]
}
-->

# Single Mode vs Multi Mode in Lucee

Lucee offers two modes of operation: **Single Mode** and **Multi Mode**. While Multi Mode has been the default in earlier versions, Single Mode presents several advantages, especially for setups that do not rely on multiple web contexts with individual configurations. 

## History

- **Lucee 5**: Only supported Multi Mode.
- **Lucee 6**: Introduced Single Mode. New installations start in Single Mode by default. However, if upgrading from Lucee 5, the system remains in Multi Mode unless manually changed.

## What is Multi Mode?

Multi Mode allows for separate configurations for each web context. This is beneficial when running multiple web applications on a single server that require different settings. However, this flexibility introduces complexity in configuration, logging, and maintenance.

## What is Single Mode?

Single Mode consolidates all configurations into a single context. This is ideal for environments where multiple web contexts are unnecessary. Instead of maintaining separate configurations for each context, Single Mode simplifies operations by unifying them into one.

## Key Differences

### **Configuration**

- **Multi Mode**: Separate configurations exist for each web context and the server context. Some settings may overlap or conflict, leading to potential confusion.
- **Single Mode**: All configurations are unified in a single context. This eliminates ambiguity and simplifies administration, including having only one Lucee Administrator.

### **Logging**

- **Multi Mode**: Logs are divided between web context logs (e.g., request logs) and server context logs (e.g., global actions like tasks).
- **Single Mode**: All logs are centralized under the server context, providing a clearer and more streamlined view of system activity.

### **Performance**

- **Multi Mode**: Startup times are longer due to the need to load configurations for multiple web contexts.
- **Single Mode**: Faster startup times as only a single configuration is loaded.

### **Future Compatibility**

- **Multi Mode**: While supported in Lucee 6.x, it will be deprecated in Lucee 7.
- **Single Mode**: Fully supported in Lucee 6.x and required in Lucee 7, making it the more future-proof choice.

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

- Note: Switching via this method does not support merging configurations.

## Why Choose Single Mode?

For setups like ours, where multiple web contexts with individual configurations are not needed, Single Mode provides significant benefits:

- **Simplified Configuration**: Easier to manage and eliminates redundant settings.
- **Unified Logging**: Clearer and more efficient logging.
- **Better Performance**: Faster startup times.
- **Future-Proof**: Prepares for Lucee 7, which will no longer support Multi Mode.

## Conclusion

Single Mode simplifies the overall management of Lucee, reduces complexity, and aligns with the future direction of the platform. Unless you explicitly need Multi Mode for multiple web contexts, Single Mode is the recommended approach for most environments.
