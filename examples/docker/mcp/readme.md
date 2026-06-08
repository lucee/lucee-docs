# Lucee MCP Server — Docker Example

This example demonstrates running Lucee 7 with the [MCP Server extension](https://github.com/lucee/extension-mcp-server) and [Lucene Search extension](https://github.com/lucee/extension-lucene) installed at startup. It exposes a JSON-RPC tool endpoint for AI clients such as Claude and Cursor, including full-text search across functions, tags, and lucee-docs recipes.

## What's Included

- `Dockerfile` — Lucee server image with MCP Server + Lucene extensions registered via CFConfig
- `docker-compose.yml` — Single-service setup exposing HTTP and Tomcat ports
- `lucee-config.json` — Registers both extensions by ID and Maven coordinates
- `www/index.cfm` — Landing page with link to the test console
- `www/test/index.cfm` — Interactive MCP test console

## Quick Start

This example is self-contained — run everything from this directory:

```bash
cd examples/docker/mcp
docker compose up -d --build
```

When developing, `./www` is mounted for live edits.

- Landing page: [http://localhost:8056/](http://localhost:8056/)
- MCP test console: [http://localhost:8056/test/](http://localhost:8056/test/)

Lucee downloads the extensions on first startup. The container needs network access to Maven / the Lucee extension provider and to GitHub (for recipe indexing).

On first `search_lucee_docs` call, the MCP extension builds a Lucene index from built-in function/tag metadata and recipes fetched from [docs/recipes/index.json](https://raw.githubusercontent.com/lucee/lucee-docs/refs/heads/master/docs/recipes/index.json). This can take a few seconds.

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
| `search_lucee_docs` | `query` (string), `maxResults` (int, optional) | Lucene search across functions, tags, and recipes |

The `search_lucee_docs` tool requires Lucene 3+ and indexes three sources:

- **Function Index** — built-in function names and FLD summaries
- **Tag Index** — CFML tag names and TLD summaries
- **Recipe Index** — lucee-docs how-to guides (configuration, Docker, Application.cfc, migration, etc.)

The test console at `/test/` provides clickable buttons for every action, including recipe search presets.

## Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `LUCEE_ADMIN_PASSWORD` | `qwerty` | Lucee Administrator password |
| `LUCEE_DOC_RECIPES_PATH` | `https://raw.githubusercontent.com/lucee/lucee-docs/refs/heads/master` | Base URL for fetching `docs/recipes/index.json` and recipe markdown files |

Recipes are loaded live from the lucee-docs GitHub repo — no local copy is bundled in this example.

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

# Look up a function
curl -s -X POST http://localhost:8056/lucee/mcp/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","id":3,"params":{"name":"get_lucee_function","arguments":{"name":"arraySort"}}}'

# Search docs (functions, tags, and recipes)
curl -s -X POST http://localhost:8056/lucee/mcp/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","id":4,"params":{"name":"search_lucee_docs","arguments":{"query":"Application.cfc session management","maxResults":3}}}'
```

## Extension Registration

`lucee-config.json` installs both extensions by ID and Maven coordinates:

```json
{
    "extensions": [
        {
            "id": "B5059590-2112-49FB-AEDFB997252EDA18",
            "maven": "org.lucee:mcp-server-extension",
            "name": "MCP Server"
        },
        {
            "id": "EFDEB172-F52E-4D84-9CD1A1F561B3DFC8",
            "maven": "org.lucee:lucene-search-extension",
            "name": "Lucene Search"
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

Use `search_lucee_docs` for how-to questions (recipes) and `get_lucee_function` / `get_lucee_tag` when you know the exact name.
