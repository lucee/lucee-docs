# Lucee MCP Server — Docker Example

This example demonstrates running Lucee 7 with the [MCP Server extension](https://github.com/lucee/extension-mcp-server) installed at startup, exposing a JSON-RPC tool endpoint for AI clients such as Claude and Cursor.

## What's Included

- `Dockerfile` — Lucee server image with MCP Server extension registered via CFConfig
- `docker-compose.yml` — Single-service setup exposing HTTP and Tomcat ports
- `lucee-config.json` — Registers the extension by ID and Maven coordinates
- `www/index.cfm` — Landing page with link to the test console
- `www/test/index.cfm` — Interactive MCP test console

## Quick Start

```bash
docker compose up -d --build
```

- Landing page: [http://localhost:8056/](http://localhost:8056/)
- MCP test console: [http://localhost:8056/test/](http://localhost:8056/test/)

Lucee downloads the extension on first startup. The container needs network access to Maven / the Lucee extension provider.

## Ports

| Port   | Service           |
|--------|-------------------|
| `8056` | Nginx (main HTTP) |
| `8856` | Tomcat (direct)   |

## MCP Endpoint

Single JSON-RPC endpoint:

```
POST /lucee/mcp/
```

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
| `search_lucee_docs` | `query` (string), `maxResults` (int, optional) | Lucene search across docs (requires Lucene extension) |

The test console at `/test/` provides clickable buttons for every action, including error cases.

## Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `LUCEE_ADMIN_PASSWORD` | `qwerty` | Lucee Administrator password |

The MCP Server extension does not implement endpoint authentication.

## Example curl

```bash
# Initialize
curl -s -X POST http://localhost:8056/lucee/mcp/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"initialize","id":1,"params":{}}'

# List tools
curl -s -X POST http://localhost:8056/lucee/mcp/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/list","id":2}'

# Call a tool
curl -s -X POST http://localhost:8056/lucee/mcp/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","id":3,"params":{"name":"get_lucee_function","arguments":{"name":"arraySort"}}}'
```

## Extension Registration

`lucee-config.json` installs the extension by ID and Maven coordinates:

```json
{
    "extensions": [
        {
            "id": "B5059590-2112-49FB-AEDFB997252EDA18",
            "maven": "org.lucee:mcp-server-extension:1.0.0.7-BETA",
            "name": "MCP Server"
        }
    ]
}
```

## Cursor / Claude MCP client config

```json
{
    "mcpServers": {
        "lucee": {
            "url": "http://localhost:8056/lucee/mcp/"
        }
    }
}
```
