<!--
{
  "title": "Lucee Skill for AI Assistants",
  "id": "lucee-skill",
  "since": "7.0",
  "categories": ["ai", "documentation"],
  "description": "What the Lucee skill file is, how it helps AI assistants answer CFML questions accurately, and how to configure it with Cursor, Claude, OpenAI, and Gemini",
  "keywords": [
    "skill",
    "lucee.skill",
    "AI",
    "Claude",
    "OpenAI",
    "Gemini",
    "Cursor",
    "documentation",
    "agent",
    "assistant"
  ],
  "related": [
    "mcp",
    "ai",
    "ai-for-documentation",
    "config-schema"
  ]
}
-->

# Lucee Skill for AI Assistants

Large language models do not reliably know Lucee-specific behaviour — function signatures change between versions, configuration moved from XML to `.CFConfig.json`, and many features exist only in Lucee, not other CFML Engines.

A **skill** solves that by giving the assistant persistent instructions: what Lucee is, when to look things up, where to fetch docs, and what not to guess.

## What Is a Skill?

A skill is a markdown file with YAML frontmatter that an AI agent loads into its context. The frontmatter tells the agent **when** to use the skill (`name`, `description`); the body tells it **how** to work.

Typical layout (Cursor, Claude Code, and similar tools):

```
skill-name/
└── SKILL.md    ← required
```

Skills are not a full copy of the documentation. They are a **routing guide** — an index plus rules so the agent fetches the right source on demand instead of inventing answers.

## The Lucee Skill (`lucee.skill`)

Lucee publishes a ready-made skill at:

**https://docs.lucee.org/lucee.skill**

It is auto-generated from the lucee-docs repository whenever the recipe index is rebuilt. Do not edit the published file by hand — add or change recipes in [lucee-docs](https://github.com/lucee/lucee-docs); the skill updates on the next docs deploy.

The skill contains:

| Section | Purpose |
|---------|---------|
| **Recipe Index** | How-to guides — `https://docs.lucee.org/recipes/<id>.md` |
| **Guide Index** | Long-form guides — `https://docs.lucee.org<path>.md` |
| **Examples Index** | Runnable Docker/examples on GitHub |
| **Technical Specs** | Java/API internals (AST, hooks, monitors, …) |

Core rule baked into the skill: **fetch before answering** — never guess at Lucee-specific behaviour.

### Skill vs MCP

| | **Skill (`lucee.skill`)** | **MCP ([[mcp]])** |
|--|---------------------------|-------------------|
| Best for | Recipes, guides, configuration patterns | Built-in function/tag lookup, doc search, AST |
| How it works | Agent reads index, fetches markdown URLs | Agent calls JSON-RPC tools on a server |
| Setup | Install one file in your AI tool | Configure MCP server URL + credentials |

Use both when you can: the skill for narrative how-tos, MCP for exact function descriptors and `search_lucee_docs`.

---

## Cursor

Cursor discovers skills from `SKILL.md` files in skill directories.

### Personal (all projects)

```sh
mkdir -p ~/.cursor/skills/lucee-docs
curl -fsSL https://docs.lucee.org/lucee.skill -o ~/.cursor/skills/lucee-docs/SKILL.md
```

### Project (shared via git)

```sh
mkdir -p .cursor/skills/lucee-docs
curl -fsSL https://docs.lucee.org/lucee.skill -o .cursor/skills/lucee-docs/SKILL.md
git add .cursor/skills/lucee-docs/SKILL.md
```

Cursor loads the skill automatically when your question matches the description (Lucee, CFML, configuration, tags, etc.). Re-run `curl` periodically to pick up new recipes.

**Optional:** add the [Lucee MCP server](https://mcp.lucee.org/) in Cursor MCP settings for live function/tag search alongside the skill.

---

## Claude (Anthropic)

Claude uses the same `SKILL.md` format in several places.

### Claude Code / Claude Desktop

```sh
mkdir -p ~/.claude/skills/lucee-docs
curl -fsSL https://docs.lucee.org/lucee.skill -o ~/.claude/skills/lucee-docs/SKILL.md
```

For a single repository, use `.claude/skills/lucee-docs/SKILL.md` instead. Claude discovers skills at startup and invokes them when relevant, or you can type `/lucee-docs` if the tool exposes skill commands.

### Claude.ai (uploaded skills)

1. Download the skill file (or save the URL content as `SKILL.md`).
2. Place it in a folder named `lucee-docs` (folder name should match the `name` field in the frontmatter).
3. ZIP the folder: `lucee-docs/SKILL.md` inside the archive.
4. In Claude.ai go to **Settings → Capabilities → Skills** and upload the ZIP.
5. Enable the skill and test with a Lucee-specific prompt (for example *"How do I define a datasource in Application.cfc?"*).

### Claude Projects

Projects do not use the skill mechanism directly, but you can attach the same file as **project knowledge**:

1. Create or open a Project.
2. Under **Project knowledge**, upload `lucee.skill` (or the downloaded `SKILL.md`).
3. Add a short instruction in the project custom instructions:

```
Use the attached Lucee skill as your routing guide. For any Lucee or CFML question,
find the matching recipe ID in the index and fetch https://docs.lucee.org/recipes/<id>.md
before answering. Do not guess.
```

### Claude API + MCP

For API integrations running on Lucee itself, you can combine passthrough MCP with a system message derived from the skill. See [[mcp]] for `mcp_servers` configuration on Claude connections.

---

## OpenAI (ChatGPT / Custom GPT)

OpenAI does not use the `SKILL.md` filename convention, but Custom GPTs support the same idea via **Instructions** and **Knowledge**.

### Custom GPT

1. Go to [ChatGPT → Explore GPTs → Create](https://chatgpt.com/gpts/editor).
2. **Name:** `Lucee Assistant`
3. **Description:** *Expert help for Lucee CFML — configuration, tags, functions, and migration.*
4. **Instructions** — paste the `description` block from the skill frontmatter, plus:

```
You have a Lucee documentation index in your knowledge files.

Rules:
1. Search the knowledge index for a matching recipe ID or guide path.
2. When the user needs current detail, use web browsing to fetch:
   https://docs.lucee.org/recipes/<id>.md
   or https://docs.lucee.org<guide-path>.md
3. Never invent Lucee function signatures or configuration keys.
4. Prefer official docs over training data.
```

5. **Knowledge** — upload the downloaded `lucee.skill` file (or `SKILL.md` renamed from it). One file is enough; the index lists all recipe IDs.
6. **Capabilities** — enable **Web Browsing** so the GPT can fetch live recipe markdown when the index entry points to a URL not fully inlined in the upload.

> Custom GPTs cache uploaded knowledge at upload time. Enable web browsing (or re-upload after major Lucee releases) so answers stay current.

### OpenAI API

Pass the skill's core instructions as the `system` message (or `instructions` on the Assistants / Responses API). For function-level lookup, attach MCP as described in [[mcp]]:

```json
"tools": [
  {
    "type": "mcp",
    "server_label": "lucee",
    "server_url": "https://mcp.lucee.org/",
    "require_approval": "never"
  }
]
```

---

## Gemini (Google)

Gemini **Gems** map to the same pattern: **Instructions** + **Knowledge**.

### Create a Lucee Gem

1. Open [Gemini](https://gemini.google.com) → **Gem manager** → **New Gem**.
2. **Name:** `Lucee Assistant`
3. **Instructions:**

```
You are a Lucee CFML expert.

The attached knowledge file is an index of official Lucee documentation.
For every Lucee-specific question:
1. Find the best matching recipe or guide in the index.
2. Fetch the live document from docs.lucee.org when you need full detail.
3. Treat docs.lucee.org as authoritative over your training data.
4. Say when you are unsure rather than guessing function behaviour.
```

4. Under **Knowledge**, click **Add files** and upload `lucee.skill` (download from https://docs.lucee.org/lucee.skill first).
5. Save the Gem and test with a concrete question.

If you store the skill in Google Drive, attach it from Drive so updates to the file propagate when you replace it.

### Gemini API

Set `system_instruction` to the same instruction block. Add Google's MCP/tool configuration under your Lucee `GeminiEngine` `custom` passthrough when you need live tool calls — see [[mcp]].

---

## Keeping the Skill Up to Date

The published skill is rebuilt on every [lucee-docs](https://github.com/lucee/lucee-docs) deploy. Refresh your local copy:

```sh
curl -fsSL https://docs.lucee.org/lucee.skill -o ~/.cursor/skills/lucee-docs/SKILL.md
# or your Claude path:
curl -fsSL https://docs.lucee.org/lucee.skill -o ~/.claude/skills/lucee-docs/SKILL.md
```

For Custom GPTs and Gems, re-upload the file after major Lucee releases or when you notice missing recipes in the index.

## See Also

- [Model Context Protocol (MCP)](mcp.md) — live function/tag search and Lucee MCP servers
- [AI](ai.md) — AI connections and passthrough configuration in Lucee
- [AI in Documentation (Experimental)](ai-for-documentation.md) — AI assistance inside the Lucee Monitor
