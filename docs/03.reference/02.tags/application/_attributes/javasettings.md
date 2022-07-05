A struct that enables loading of application-specific Java libraries from a custom path. The following keys are supported:

- **loadPaths:** An array of paths, or comma delimitered list of jar files, or directories containing jar files. This or Bundles is required.
- **bundles:** Any array of paths, or comma delimitered list of OSGI jar files, or directories containing OSGI jar files. This or LoadPaths is required.
- **loadCFMLClassPath (default:false):** Indicates whether underlying Lucee classes should be loaded.
- **reloadOnChange (default:false):** Indicates if loaded Java libraries should be watched and reloaded if they change, without needing to restart the server.
- **watchInterval (default:60):** The interval, in seconds, for checking the loaded Java libraries for changes. Only applicable if *reloadOnChange* is true.
- **watchExtensions (default:"class,jar"):** A list of the file extensions to monitor for changes.
