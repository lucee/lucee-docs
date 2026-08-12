<!--
{
  "title": "Serving CFML Files from a Lucee Extension",
  "id": "serving-cfml-from-extensions",
  "related": [
    "custom-tags-via-extensions",
    "mappings-component-mappings",
    "mappings-how-to-define-a-reg-mapping",
    "extension-installation",
    "mcp"
  ],
  "categories": [
    "extensions",
    "server",
    "components"
  ],
  "description": "How to ship CFML templates and components inside a Lucee extension and make them reachable in the webroot via a mapping.",
  "keywords": [
    "Extensions",
    "LEX",
    "Mapping",
    "Component Mapping",
    "lucee-server context",
    "lucee-config",
    "webroot",
    "CFConfig",
    "MCP"
  ]
}
-->

# Serving CFML Files from a Lucee Extension

A Lucee extension (`.lex` file) can ship complete CFML applications — both templates (`.cfm`) and components (`.cfc`) — that deploy straight into the Lucee server context when the extension is installed. Once the files are on disk, a single mapping makes them reachable at whatever URL fits your application: the webroot (`/`), a dedicated path (`/mcp`), or a namespaced component path.

This recipe uses the [MCP Server extension](https://github.com/lucee/extension-mcp-server) as its running example. The extension ships an `index.cfm` endpoint plus a package of CFCs, and a small amount of mapping configuration exposes them — no application code needs to be copied into your webroot.

## How Extensions Copy Files into the Context

A `.lex` file is a ZIP archive. Lucee inspects specific top-level folders inside it and copies their contents into the running server when the extension is installed. Two of those folders matter here:

| Folder in the extension | Deployed to | Purpose |
|---|---|---|
| `context/` | `{lucee-server}/context/` | Templates and any files you want under the server context |
| `components/` | `{lucee-server}/context/components/` | CFC packages, kept separate so a component mapping can target them cleanly |

This is automatic — you do not write any install logic. Dropping a file in the extension's `context/` folder guarantees it lands under `lucee-server/context/` on every server the extension is installed on.

### Example: the MCP Server extension source

The extension keeps its deployable files under `source/` ([browse on GitHub](https://github.com/lucee/extension-mcp-server/tree/main/source)):

```
source/
├── context/
│   └── mcp/
│       ├── Application.cfc
│       └── index.cfm
└── components/
    └── org/
        └── lucee/
            └── extension/
                └── mcp/
                    ├── MCPServer.cfc
                    ├── MCPSupport.cfc
                    └── tools/
                        └── ...
```

After the extension is installed, those files are available on disk at:

```
{lucee-server}/context/mcp/Application.cfc
{lucee-server}/context/mcp/index.cfm
{lucee-server}/context/components/org/lucee/extension/mcp/MCPServer.cfc
{lucee-server}/context/components/org/lucee/extension/mcp/tools/...
```

The shipped `index.cfm` is intentionally tiny — it instantiates the component (found via the component mapping described below) and delegates to it:

```cfml
<cfscript>
    if ( !structKeyExists( application, "mcpServer" ) ) {
        application.mcpServer = new org.lucee.extension.mcp.MCPServer();
    }
    application.mcpServer.handle();
</cfscript>
```

## The `{lucee-config}` Placeholder

In `.CFConfig.json` (and the Lucee Administrator), the placeholder `{lucee-config}` resolves to the Lucee configuration directory — for the server context that is `{lucee-server}/context/`. This is exactly where the extension deployed its files, so you can reference them portably without hardcoding an absolute path:

- `{lucee-config}/components/` → `{lucee-server}/context/components/`
- `{lucee-config}/context/mcp/` → `{lucee-server}/context/mcp/`

Using the placeholder means the same config works across environments (local, Docker, production) regardless of where Lucee is installed.

## Step 1 — Mapping the Components

For CFML code to instantiate the shipped CFCs with `new org.lucee.extension.mcp.MCPServer()`, Lucee needs a component mapping whose root is `{lucee-config}/components/`.

Lucee already has a built-in component mapping pointing there, so in most cases this works out of the box. Still, **declaring it explicitly is good practice** — it documents the dependency, and lets you pin `inspectTemplate` so the extension's CFCs are never re-scanned for changes at runtime:

```json
"componentMappings": [
    {
        "physical": "{lucee-config}/components/",
        "archive": "",
        "primary": "physical",
        "inspectTemplate": "never"
    }
]
```

With this in place, `org.lucee.extension.mcp.MCPServer` resolves anywhere in your application, because `org/lucee/extension/mcp/MCPServer.cfc` sits under the mapped `components/` root.

## Step 2 — Mapping the Templates to a URL

The component mapping makes the *CFCs* callable, but the extension's shipped `index.cfm` still lives under the server context, not in your webroot. To expose it at a public URL, add a **regular mapping** pointing at the extension's context folder.

Map it to the webroot so the endpoint answers at `POST /index.cfm`:

```json
"mappings": {
    "/": {
        "physical": "{lucee-config}/context/mcp/"
    }
}
```

Or map it to a dedicated path so it answers at `/mcp/index.cfm` and leaves your webroot free:

```json
"mappings": {
    "/mcp": {
        "physical": "{lucee-config}/context/mcp/"
    }
}
```

A request to the mapped path now serves the extension's own `index.cfm` (and its sibling `Application.cfc`) directly — you never copy those files into your project.

> **Important — call the CFML file directly, no welcome file**: Lucee mappings are resolved inside Lucee only. The servlet engine in front of Lucee (Tomcat, etc.) knows nothing about them, so its **welcome-file list does not apply** to a mapped path. You must request the CFML file by name. For the `/` mapping above, `https://localhost/` will **not** serve the extension's `index.cfm` — call `https://localhost/index.cfm` explicitly. Likewise use `https://localhost/mcp/index.cfm` for the `/mcp` mapping.

### Restoring the welcome file with a thin webroot `index.cfm`

If you want the bare URL (`https://localhost/`) to work, put a **real** `index.cfm` in your physical webroot. Tomcat's welcome-file list *does* find a physical file, and that file simply hands off to whatever you mapped. Because it is one server-side request, the HTTP method and request body are preserved — important for a `POST`-based endpoint like MCP.

Include the mapped template (uses the Lucee mapping, keeps the original request intact):

```cfml
<!--- webroot/index.cfm --->
<cfinclude template="/mcp/index.cfm">
```

This is the most robust option for an endpoint. A client-side redirect works too when you only need to reach a `GET` page (it does not carry a `POST` body):

```cfml
<!--- webroot/index.cfm --->
<cflocation url="/mcp/index.cfm" addtoken="false">
```

Either way you keep a single, small file in your project; all the real logic still lives in the extension.

## Putting It Together

A minimal `.CFConfig.json` that installs the extension and exposes it at the webroot:

```json
{
    "mode": "single",
    "componentMappings": [
        {
            "physical": "{lucee-config}/components/",
            "archive": "",
            "primary": "physical",
            "inspectTemplate": "never"
        }
    ],
    "mappings": {
        "/": {
            "physical": "{lucee-config}/context/mcp/"
        }
    },
    "extensions": [
        {
            "id": "B5059590-2112-49FB-AEDFB997252EDA18",
            "maven": "org.lucee:mcp-server-extension:1.0.1.3-SNAPSHOT",
            "name": "MCP Server",
            "version": "1.0.1.3-SNAPSHOT"
        }
    ]
}
```

> **Note**: CFConfig `extensions` are applied on a fresh server install. When running in Docker, recreate the container after changing the config (for example `docker compose down && docker compose up -d --build`) so the extension is picked up.

## Two Ways to Consume the Shipped Files

The two mappings support two complementary usage styles — you can use either or both:

1. **Serve the extension's own template** — map a URL to `{lucee-config}/context/mcp/` (Step 2). The extension's `index.cfm` is served as-is. Nothing but config lives in your project. This is the fastest way to stand the endpoint up.

2. **Call the components from your own template** — rely only on the component mapping (Step 1) and write your own webroot `index.cfm` that instantiates the shipped CFCs. This is what the [Docker MCP example](https://github.com/lucee/extension-mcp-server-docker) does: its own `index.cfm` builds the `MCPServer` once in the `server` scope and adds a branded landing page, while still delegating request handling to the extension's component:

```cfml
<cfscript>
    // in the project's own webroot index.cfm
    if ( cgi.request_method == "POST" ) {
        server.mcpServer.handle();  // MCPServer instantiated via the component mapping
        abort;
    }
    // ...render a landing page for GET requests...
</cfscript>
```

Approach 1 keeps your project empty; approach 2 gives you full control over routing and presentation while reusing the extension's logic.

## Verifying

After installing the extension and applying the config, confirm the files deployed and the mapping resolves:

```cfml
// The template mapping resolves to the extension's context folder
writeDump( expandPath( "/index.cfm" ) );        // .../lucee-server/context/mcp/index.cfm

// The component mapping resolves to the shipped CFCs
writeDump( getComponentMetaData( "org.lucee.extension.mcp.MCPServer" ) );
```

If `expandPath()` still points at your project webroot, the extension has not been installed yet (or the server has not restarted to apply the CFConfig extension list).

## Related Documentation

- **[Deploying Custom Tags via Extensions](custom-tags-via-extensions.md)** — the same context-copying mechanism, applied to custom tags
- **[Component Mappings](component-mappings.md)** — how component mappings resolve CFC package paths
- **[Define a regular Mapping](mappings-how-to-define-a-reg-mapping.md)** — regular mappings for templates and includes
- **[Extension Installation](extension-installation.md)** — building and installing Lucee extensions
- **[Model Context Protocol (MCP)](mcp.md)** — the extension used as the example throughout this recipe
