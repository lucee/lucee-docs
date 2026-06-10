# Lucee MCP Server — Docker Example

Minimal Docker image running Lucee 7.1 with the [MCP Server extension](https://github.com/lucee/extension-mcp-server). The MCP JSON-RPC endpoint is mapped to the webroot — there is no separate landing page or test UI.

## What's Included

- `Dockerfile` — Lucee 7.1 image with CFConfig and a bundled MCP Server `.lex`
- `docker-compose.yml` — Exposes Tomcat (`8856`) and Nginx (`8056`)
- `lucee-config.json` — Maps `/` to the MCP extension context
- `extensions/` — MCP Server extension package (update after building a new release)

## Quick Start

```bash
cd examples/docker/mcp
docker compose up -d --build
```

## Ports

| Port   | Service           |
|--------|-------------------|
| `8056` | Nginx (main HTTP) |
| `8856` | Tomcat (direct)   |

Use Tomcat (`8856`) if Nginx is not responding in your environment.

## MCP Endpoint

The webroot serves the MCP server directly:

```
POST /
```

`GET /` returns a JSON-RPC error (`only POST is supported`). The extension’s default path `/lucee/mcp/` also remains available.

### JSON-RPC methods

| Method | Description |
|--------|-------------|
| `initialize` | MCP handshake |
| `tools/list` | Lists available tools |
| `tools/call` | Executes a tool |

### Tools

| Tool | Arguments | Description |
|------|-----------|-------------|
| `get_lucee_function` | `name` (string) | FLD descriptor for a built-in function |
| `get_lucee_tag` | `name` (string) | TLD descriptor for a tag |
| `parse_cfml_ast` | `source` or `path`, `mode`, `summary`, `maxDepth` | Parse CFML into an AST tree or compact summary |
| `query_cfml_ast` | `source` or `path`, `nodeType`, `name`, `line`, `builtInOnly` | Find matching AST nodes in parsed CFML |

The AST tools require Lucee 7.0.0.296+ (`astFromString` / `astFromPath`) and MCP Server 1.0.1.0+.

## Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `LUCEE_ADMIN_PASSWORD` | `qwerty` | Lucee Administrator password |

The MCP Server extension does not implement endpoint authentication.

## Example curl

```bash
# Initialize
curl -s -X POST http://localhost:8856/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"initialize","id":1,"params":{}}'

# List tools (expect 4)
curl -s -X POST http://localhost:8856/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/list","id":2}'

# Look up a function
curl -s -X POST http://localhost:8856/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","id":3,"params":{"name":"get_lucee_function","arguments":{"name":"arraySort"}}}'

# Parse CFML into a compact AST summary
curl -s -X POST http://localhost:8856/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","id":4,"params":{"name":"parse_cfml_ast","arguments":{"source":"<cfset x = 1>","summary":true}}}'
```

Replace `8856` with `8056` when using the Nginx port.

## Updating the bundled extension

Build a new `.lex` from the [MCP Server extension](https://github.com/lucee/extension-mcp-server) and replace `extensions/mcp-server-extension-1.0.1.1-BETA.lex`. Update `lucee-config.json` and the Dockerfile `COPY` line if the version changes.

## CFConfig

The MCP extension `.lex` is bundled in the image and registered via CFConfig:

```json
{
    "mappings": {
        "/": {
            "physical": "{lucee-config}/context/mcp/"
        }
    },
    "extensions": [
        {
            "id": "B5059590-2112-49FB-AEDFB997252EDA18",
            "name": "MCP Server",
            "path": "/opt/lucee/server/lucee-server/context/deploy/mcp-server-extension-1.0.1.1-BETA.lex"
        }
    ]
}
```

## Cursor / Claude MCP client config

```json
{
    "mcpServers": {
        "lucee": {
            "url": "http://localhost:8856/"
        }
    }
}
```

Use `get_lucee_function` / `get_lucee_tag` for exact API lookups. Use `parse_cfml_ast` and `query_cfml_ast` to analyze CFML source structure.
