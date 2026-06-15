<!--
{
  "title": "Model Context Protocol (MCP)",
  "id": "mcp",
  "since": "8.0",
  "categories": ["ai"],
  "description": "Guide to MCP in Lucee: what it is, how to configure AI connections, and the three MCP servers Lucee provides",
  "keywords": [
    "MCP",
    "Model Context Protocol",
    "AI",
    "Claude",
    "OpenAI",
    "Gemini",
    "tools",
    "passthrough",
    "admin",
    "configuration"
  ],
  "related": [
    "ai",
    "ai-augmentation-lucene"
  ]
}
-->

# Model Context Protocol (MCP)

The [Model Context Protocol (MCP)](https://modelcontextprotocol.io) is an open standard for connecting AI models to external **tools** — databases, APIs, documentation, configuration, or your own business logic.

Instead of hoping the model knows your environment, an MCP client discovers available tools, calls them over HTTP (JSON-RPC), and uses the results in its reply.

Lucee supports MCP in two ways:

1. **As a client** — forward MCP server references to Claude, OpenAI, or Gemini via the AI connection **passthrough** configuration
2. **As a server** — Lucee provides three MCP solutions you can expose to AI agents

This recipe explains both sides and the three MCP solutions Lucee ships.

## Configuring MCP in Lucee AI Connections

MCP is configured through the **passthrough** mechanism on AI connections. Any fields in the `custom` block that Lucee does not recognize are forwarded directly to the provider API. A `headers` key forwards custom HTTP headers.

You can configure passthrough in:

- **`.CFConfig.json`** — under `ai.<connectionName>.custom`
- **Lucee Administrator** — *Services → AI → Create/Edit connection → Passthrough configuration* (JSON textarea)

On the admin form, shortcut buttons insert predefined passthrough snippets (for example the public Lucee docs MCP server or the Admin MCP template).

Usage in CFML is unchanged — MCP is transparent to your application code:

```javascript
aiSession = createAISession(name: "myclaude");
answer = inquiryAISession(aiSession, "What Lucee functions can sort an array?");
writeOutput(answer);
```

The provider handles tool discovery, tool calls, and result handling. Lucee passes the configuration through.

### Claude (Anthropic)

Claude's remote MCP connector requires the `mcp-client-2025-11-20` beta header and `mcp_servers` / `mcp_toolset` fields in the request body.

```json
"ai": {
  "myclaude": {
    "class": "lucee.runtime.ai.anthropic.ClaudeEngine",
    "custom": {
      "apikey": "${CLAUDE_API_KEY}",
      "model": "claude-sonnet-4-6",
      "message": "You are a helpful Lucee assistant.",
      "headers": {
        "anthropic-beta": "mcp-client-2025-11-20"
      },
      "mcp_servers": [
        {
          "type": "url",
          "url": "https://mcp.lucee.org/",
          "name": "lucee"
        }
      ],
      "tools": [
        {
          "type": "mcp_toolset",
          "mcp_server_name": "lucee"
        }
      ]
    }
  }
}
```

For MCP servers that require authentication, add `authorization_token` to the server entry. Anthropic sends this when connecting to your MCP URL.

**Important:** Claude connects to MCP servers from Anthropic's cloud. The URL must be **publicly reachable over HTTPS**. `localhost` will not work.

### OpenAI

OpenAI-compatible endpoints use the Responses API MCP tool format in passthrough:

```json
"ai": {
  "myopenai": {
    "class": "lucee.runtime.ai.openai.OpenAIEngine",
    "custom": {
      "secretKey": "${OPENAI_API_KEY}",
      "model": "gpt-4o",
      "message": "You are a helpful Lucee assistant.",
      "tools": [
        {
          "type": "mcp",
          "server_label": "lucee",
          "server_url": "https://mcp.lucee.org/",
          "require_approval": "never"
        }
      ]
    }
  }
}
```

Optional headers (for example `Authorization: Bearer …`) can be added inside the MCP tool object. The Lucee OpenAI engine calls the Chat Completions API — MCP passthrough only works when your endpoint supports MCP on that API.

### Gemini (Google)

Gemini uses Google-specific field names for tools and MCP. There is no admin shortcut yet — configure passthrough manually from the [Google Gemini API documentation](https://ai.google.dev).

Structure (field names and nesting) differs from Claude and OpenAI. Add the MCP/tool blocks documented for your API version under `custom`; Lucee forwards them unchanged:

```json
"ai": {
  "mygemini": {
    "class": "lucee.runtime.ai.google.GeminiEngine",
    "custom": {
      "apikey": "${GEMINI_API_KEY}",
      "model": "gemini-2.0-flash",
      "message": "You are a helpful Lucee assistant."
    }
  }
}
```

Merge in the provider's MCP configuration keys alongside `apikey`, `model`, and `message` once you have the current format from Google.

### Passthrough notes

- Unknown body fields are merged into the provider request; Lucee never overwrites fields it sets itself (`model`, `messages`, etc.)
- Gemini and OpenAI return `400` for fields their API does not recognize — only forward documented fields
- The `anthropic-beta` header version may change as Anthropic promotes MCP out of beta
- See [[ai]] for the full passthrough reference and more AI connection examples

## Lucee MCP Servers

Lucee provides three MCP solutions for different use cases. All use JSON-RPC 2.0 over HTTP (`initialize`, `tools/list`, `tools/call`).

| Server | Endpoint | Good for |
|--------|----------|----------|
| Admin MCP | `{host}/lucee/admin/mcp.cfm` | Managing Lucee **server configuration** via AI |
| Public MCP (BETA) | `https://mcp.lucee.org/` | Lucee **docs**, functions, tags, CFML AST |
| Custom MCP (Extension) | `{host}/lucee/mcp/` (default) | **Your own tools** — data, APIs, business logic |

---

## Admin MCP Server

Built into Lucee 8. Exposes server configuration through `Administrator.cfc` so an AI agent can inspect and optionally update Lucee settings.

**Endpoint:** `POST {host}/lucee/admin/mcp.cfm`

**Access control** (no access by default):

| `LUCEE_ADMIN_MCP_ACCESS` | Behaviour |
|--------------------------|-----------|
| `none` (default) | Endpoint disabled (HTTP 503) |
| `read` | List sections and read configuration |
| `write` | Read + update configuration |

Set via environment variable or system property:

- `LUCEE_ADMIN_MCP_ACCESS` / `lucee.admin.mcp.access`

**Authentication:** `Authorization: Bearer <Server Administrator password>`

**Tools:**

| Tool | Description |
|------|-------------|
| `config_list_sections` | List available config areas and read/write capability |
| `config_get` | Read a section (optional `name` for datasources, mappings, etc.) |
| `config_update` | Update a section (write access only) |

**Example — enable access on the server:**

```json
// .CFConfig.json is not used for this flag — set via env or sysprop:
// LUCEE_ADMIN_MCP_ACCESS=read
```

**Example — connect from Claude via AI passthrough:**

Use the *Insert Lucee Admin MCP Server* shortcut on the AI connection form, or configure manually:

```json
"headers": {
  "anthropic-beta": "mcp-client-2025-11-20"
},
"mcp_servers": [
  {
    "type": "url",
    "url": "https://your-server.example.com/lucee/admin/mcp.cfm",
    "name": "lucee-config",
    "authorization_token": "${LUCEE_ADMIN_PASSWORD}"
  }
],
"tools": [
  {
    "type": "mcp_toolset",
    "mcp_server_name": "lucee-config"
  }
]
```

Replace `https://your-server.example.com` with your public HTTPS base URL. Remote MCP connectors cannot reach `localhost`.

**Guardrails:** restart, version change, run update, and password change are blocked via MCP.

**Good for:** AI-assisted server administration, inspecting datasources, mappings, scope settings, AI connections, and other admin configuration without clicking through every admin screen.

---

## Public MCP Server (BETA)

Hosted by Lucee at **https://mcp.lucee.org/**. Gives AI agents callable access to Lucee documentation and CFML analysis — not just static context.

No Lucee instance required on your side; point your AI connection passthrough at the public URL.

**Tools:**

| Tool | Description |
|------|-------------|
| `get_lucee_function` | Full descriptor for a built-in function |
| `get_lucee_tag` | Full descriptor for a tag |
| `search_lucee_docs` | Full-text search across functions, tags, and recipes |
| `parse_cfml_ast` | Parse CFML source into an AST (Lucee 7.0.0.296+) |
| `query_cfml_ast` | Query an AST by type, name, or line number |

**Example — Claude passthrough:**

```json
"headers": {
  "anthropic-beta": "mcp-client-2025-11-20"
},
"mcp_servers": [
  {
    "type": "url",
    "url": "https://mcp.lucee.org/",
    "name": "lucee"
  }
],
"tools": [
  {
    "type": "mcp_toolset",
    "mcp_server_name": "lucee"
  }
]
```

Use the *Insert Lucee MCP Server* shortcut on the Claude or OpenAI AI connection form for a ready-made snippet.

**Good for:** CFML development assistance, accurate function/tag lookups, doc search, and code analysis without hallucinating API details.

---

## Custom MCP Server (Extension)

Install the [MCP Server extension](https://github.com/lucee/extension-mcp-server) to run your own MCP server inside Lucee. Expose your functions, data, and business logic as tools AI agents can call.

**Default endpoint:** `POST {host}/lucee/mcp/`

You can remap the URL via `.CFConfig.json` mappings (for example to `POST /mcp/` or the webroot). See the extension README for mapping examples and a [Docker setup example](https://github.com/lucee/lucee-docs/tree/lucee/examples/docker/mcp).

**Built-in tools** (same family as the public server):

- `get_lucee_function`, `get_lucee_tag`, `search_lucee_docs` (requires Lucene extension)
- `parse_cfml_ast`, `query_cfml_ast`

**Extend with your own tools** — drop components in the extension's `tools/` folder:

```
{lucee-server}/context/components/org/lucee/extension/mcp/tools/
```

Each tool extends the base `Tool` component and implements `exec()`. The extension README includes a template. The repository is structured for AI-assisted development.

**Example — install via `.CFConfig.json`:**

```json
"extensions": [
  {
    "name": "MCP Server",
    "id": "org.lucee:mcp-server-extension:1.0.1.3-SNAPSHOT"
  }
]
```

**Example — Claude passthrough to your instance:**

```json
"mcp_servers": [
  {
    "type": "url",
    "url": "https://your-server.example.com/lucee/mcp/",
    "name": "my-tools",
    "authorization_token": "${MCP_TOKEN}"
  }
],
"tools": [
  {
    "type": "mcp_toolset",
    "mcp_server_name": "my-tools"
  }
]
```

**Good for:** Private tools on your network, domain-specific APIs, database queries, internal business logic, and full control over deployment and authentication.

---

## Choosing the Right MCP Server

| Need | Use |
|------|-----|
| Help writing CFML, look up tags/functions | Public MCP or Custom MCP extension |
| Analyze CFML source code (AST) | Public MCP or Custom MCP extension |
| Read or change Lucee server settings | Admin MCP (`LUCEE_ADMIN_MCP_ACCESS=read` or `write`) |
| Custom tools for your application | Custom MCP extension |
| No Lucee server to host | Public MCP at `mcp.lucee.org` |

For local testing of MCP endpoints without an AI provider, POST JSON-RPC requests directly:

```bash
curl -s -X POST https://mcp.lucee.org/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'
```

Admin MCP requires the Bearer header:

```bash
curl -s -X POST https://your-server.example.com/lucee/admin/mcp.cfm \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your-admin-password" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'
```
