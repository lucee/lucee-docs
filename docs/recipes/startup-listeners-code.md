<!--
{
  "title": "Startup Listeners: Server.cfc and Web.cfc",
  "id": "startup-listeners-code",
  "related": [
    "function-configimport"
  ],
  "categories": [
    "server",
    "system"
  ],
  "description": "Lucee supports two types of Startup Listeners: Server.cfc and Web.cfc.",
  "menuTitle": "Startup Listeners",
  "keywords": [
    "startup",
    "warmup",
    "prewarm",
    "Server.cfc",
    "Web.cfc",
    "onServerStart",
    "onWebStart",
    "onBuild",
    "initialization",
    "bootstrap",
    "configuration",
    "initialization",
    "events",
    "hooks"
  ]
}
-->

# Startup Listeners - Server.cfc and Web.cfc

Lucee supports two types of startup listeners:

- **Server.cfc**: Executes when the Lucee Server starts up. This file is unique to each Lucee instance.
- **Web.cfc**: Executes for each web context.

## Server.cfc

Create a `Server.cfc` file in the `lucee-server\context\context` directory.

```lucee
// lucee-server\context\context\Server.cfc
component {
	public function onServerStart( reload ) {
		if ( !arguments.reload ) {
			systemOutput("------- Server Context started -----", true);
			// This runs when the server starts for the first time.
			// Example: Import a .cfConfig.json setting file
			var config_server = "/www/config/lucee_server_cfConfig.json";
			configImport(
				type: "server",
				data: deserializeJSON(fileRead(config_server)),
				password: "your_lucee_server_admin_password"
			);
		} else {
			// Runs each time the server config is reloaded, such as when an extension is installed or the config is updated
			systemOutput("------- Server Context config reloaded -----", true);
		}
	}

	public function onBuild() {
		systemOutput("------- Building Lucee (Docker?) -----", true);
	}
}
```

Start the Lucee Server, and the server console should display the above system outputs, indicating that `Server.cfc` has executed.

### Functions in Server.cfc

#### onServerStart

`onServerStart` is called when you start Lucee. The `reload` argument is set to `false` on the first start, and `true` when any configuration in the Lucee Administrator is updated or an extension is installed.

#### onBuild (since Lucee 6.1.1)

`onBuild` is called when you start Lucee with the environment variable `LUCEE_BUILD` (or the older variable `LUCEE_ENABLE_WARMUP`) set to `true`. You can also use the system property `-Dlucee.build` (or `-dlucee-enable.warmup`). This feature got indroduced in Lucee 6.1.1.

## Web.cfc

Create a `Web.cfc` file in the `webapps\ROOT\WEB-INF\lucee\context\` directory, or in the context webroot.

```lucee
// webapps\ROOT\WEB-INF\lucee\context\Web.cfc
component {
	public function onWebStart( reload ) {
		if ( !arguments.reload ) {
			systemOutput("------- Web Context started -----", true);
			// This runs when the web context starts for the first time.
			// Example: Import a .cfConfig.json setting file
			var config_web = "/www/config/lucee_web_cfConfig.json";
			configImport(
				type: "web",
				data: deserializeJSON(fileRead(config_web)),
				password: "your_lucee_web_context_admin_password"
			);
		} else {
			// Runs each time the web context config is reloaded, such as when an extension is installed or the config is updated
			systemOutput("------- Web Context config reloaded -----", true);
		}
	}
}
```

`Web.cfc` has one function: `onWebStart()`, with an argument `reload` that indicates if the web context is a new startup.

### Behavior with reload Argument

When `reload` is `true`, the web context is reloaded. When `reload` is `false`, it indicates a fresh start of the web context.

## How to Test

1. **Start your Lucee server.**
   - You will see the server context output first, followed by the web context output, indicating that both listeners are triggered by Lucee.

2. **Change a Setting in Web Admin.**
   - For example, change **Settings -> Charset** for the web charset to "UTF-8" in the web admin.
   - After changing the charset, only the web context is reloaded; the server context is not affected.

This feature helps to prevent unnecessary reloading of the server context, ensuring smoother operations.

## Footnotes

Watch the detailed video on [Lucee Startup Listeners](https://youtu.be/b1MWLwkKdLE).
