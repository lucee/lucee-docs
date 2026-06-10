# Lucee MCP Server — Docker Example

Minimal Docker image running Lucee 7.1 with the [MCP Server extension](https://github.com/lucee/extension-mcp-server) and [Lucene Search extension](https://github.com/lucee/extension-lucene). The MCP JSON-RPC endpoint is mapped to the webroot — there is no separate landing page or test UI.

## What's Included

- `Dockerfile` — Lucee 7.1 image; CFConfig only (no `www` content)
- `docker-compose.yml` — Exposes Tomcat (`8856`) and Nginx (`8056`)
- `lucee-config.json` — Maps `/` to the MCP extension context; installs MCP Server 1.0.1.0-BETA and Lucene

## Quick Start

```bash
cd examples/docker/mcp
docker compose up -d --build
```

Lucee downloads the extensions on first startup. The container needs network access to Maven / the Lucee extension provider and to GitHub (for recipe indexing).

On first `search_lucee_docs` call, the MCP extension builds a Lucene index from built-in function/tag metadata and recipes fetched from [docs/recipes/index.json](https://raw.githubusercontent.com/lucee/lucee-docs/refs/heads/master/docs/recipes/index.json). This can take a few seconds.

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
| `search_lucee_docs` | `query` (string), `maxResults` (int, optional) | Lucene search across functions, tags, and recipes |
| `parse_cfml_ast` | `source` or `path`, `mode`, `summary`, `maxDepth` | Parse CFML into an AST tree or compact summary |
| `query_cfml_ast` | `source` or `path`, `nodeType`, `name`, `line`, `builtInOnly` | Find matching AST nodes in parsed CFML |

The `search_lucee_docs` tool requires Lucene 3+ and indexes three sources:

- **Function Index** — built-in function names and FLD summaries
- **Tag Index** — CFML tag names and TLD summaries
- **Recipe Index** — lucee-docs how-to guides (configuration, Docker, Application.cfc, migration, etc.)

The AST tools require Lucee 7.0.0.296+ (`astFromString` / `astFromPath`) and MCP Server 1.0.1.0+.

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
curl -s -X POST http://localhost:8856/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"initialize","id":1,"params":{}}'

# List tools (expect 5)
curl -s -X POST http://localhost:8856/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/list","id":2}'

# Look up a function
curl -s -X POST http://localhost:8856/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","id":3,"params":{"name":"get_lucee_function","arguments":{"name":"arraySort"}}}'

# Search docs (functions, tags, and recipes)
curl -s -X POST http://localhost:8856/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","id":4,"params":{"name":"search_lucee_docs","arguments":{"query":"Application.cfc session management","maxResults":3}}}'

# Parse CFML into a compact AST summary
curl -s -X POST http://localhost:8856/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","id":5,"params":{"name":"parse_cfml_ast","arguments":{"source":"<cfset x = 1>","summary":true}}}'

# Query AST for function calls named len
curl -s -X POST http://localhost:8856/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","id":6,"params":{"name":"query_cfml_ast","arguments":{"source":"<cfscript>len(\"a\");writeOutput(\"x\");</cfscript>","nodeType":"CallExpression","name":"len"}}}'
```

Replace `8856` with `8056` when using the Nginx port.

## CFConfig

`lucee-config.json` maps the webroot to the MCP extension and installs both extensions:

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
            "maven": "org.lucee:mcp-server-extension:1.0.1.0-BETA",
            "name": "MCP Server",
            "version": "1.0.1.0-BETA"
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
            "url": "http://localhost:8856/"
        }
    }
}
```

Use `search_lucee_docs` for how-to questions (recipes) and `get_lucee_function` / `get_lucee_tag` when you know the exact name. Use `parse_cfml_ast` and `query_cfml_ast` to analyze CFML source structure.
