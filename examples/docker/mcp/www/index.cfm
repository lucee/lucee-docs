<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Lucee MCP Server — Docker Example</title>
	<style>
		:root {
			--bg: #f6f8fa;
			--card: #fff;
			--border: #d8dee4;
			--text: #1f2328;
			--muted: #656d76;
			--accent: #0969da;
			--accent-hover: #0550ae;
			--ok: #1a7f37;
			--ok-bg: #dafbe1;
			--warn: #9a6700;
			--warn-bg: #fff8c5;
			--err: #cf222e;
			--err-bg: #ffebe9;
		}
		* { box-sizing: border-box; }
		body {
			font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
			margin: 0;
			background: var(--bg);
			color: var(--text);
			line-height: 1.5;
		}
		header {
			background: var(--card);
			border-bottom: 1px solid var(--border);
			padding: 1.25rem 1.5rem;
		}
		header h1 { margin: 0 0 .35rem; font-size: 1.5rem; }
		header p { margin: 0; color: var(--muted); max-width: 42rem; }
		main {
			max-width: 720px;
			margin: 0 auto;
			padding: 1.25rem 1.5rem 2.5rem;
		}
		.panel {
			background: var(--card);
			border: 1px solid var(--border);
			border-radius: 8px;
			padding: 1rem 1.15rem;
			margin-bottom: 1rem;
		}
		.panel h2 {
			margin: 0 0 .75rem;
			font-size: .85rem;
			text-transform: uppercase;
			letter-spacing: .04em;
			color: var(--muted);
		}
		.panel p { margin: 0 0 .75rem; }
		.panel p:last-child { margin-bottom: 0; }
		.ext-grid {
			display: grid;
			gap: .75rem;
		}
		.ext-card {
			display: grid;
			grid-template-columns: 1fr auto;
			gap: .35rem 1rem;
			align-items: start;
			padding: .85rem 1rem;
			border: 1px solid var(--border);
			border-radius: 8px;
			background: var(--bg);
		}
		.ext-name {
			font-weight: 600;
			margin: 0;
		}
		.ext-version {
			margin: 0;
			font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
			font-size: .9rem;
			color: var(--muted);
		}
		.ext-note {
			grid-column: 1 / -1;
			margin: .35rem 0 0;
			font-size: .85rem;
			color: var(--muted);
		}
		.badge {
			display: inline-block;
			padding: .2rem .55rem;
			border-radius: 999px;
			font-size: .75rem;
			font-weight: 600;
			white-space: nowrap;
		}
		.badge.ok { background: var(--ok-bg); color: var(--ok); }
		.badge.warn { background: var(--warn-bg); color: var(--warn); }
		.badge.err { background: var(--err-bg); color: var(--err); }
		.meta {
			font-size: .85rem;
			color: var(--muted);
			margin-bottom: 1rem;
		}
		.meta strong { color: var(--text); font-weight: 600; }
		code {
			background: #eef1f4;
			padding: .12rem .35rem;
			border-radius: 4px;
			font-size: .9em;
		}
		a { color: var(--accent); }
		a.button {
			display: inline-block;
			margin-top: .25rem;
			padding: .65rem 1.2rem;
			background: var(--accent);
			color: #fff;
			text-decoration: none;
			border-radius: 6px;
			font-weight: 500;
		}
		a.button:hover { background: var(--accent-hover); color: #fff; }
		ul.compact {
			margin: 0;
			padding-left: 1.2rem;
			color: var(--muted);
			font-size: .92rem;
		}
		ul.compact li { margin-bottom: .35rem; }
	</style>
</head>
<body>
<cfscript>
	MCP_EXT_ID    = "B5059590-2112-49FB-AEDFB997252EDA18";
	LUCENE_EXT_ID = "EFDEB172-F52E-4D84-9CD1A1F561B3DFC8";
	MCP_SEARCH_MIN_VERSION = "1.0.0.8";
	MCP_AST_MIN_VERSION    = "1.0.1.0";

	function getExtensionStatus(required string id) {
		var status = {
			installed = extensionExists(arguments.id),
			name      = "",
			version   = "",
			note      = ""
		};

		if ( !status.installed ) {
			status.note = "Not installed — check lucee-config.json and extension download logs.";
			return status;
		}

		var info = extensionInfo(arguments.id);
		status.name    = info.name ?: "Extension";
		status.version = info.version ?: "unknown";
		return status;
	}

	function normalizeVersion(required string version) {
		return listToArray(reReplace(arguments.version, "[^0-9.].*$", ""), ".");
	}

	function versionAtLeast(required string version, required string minimum) {
		var a = normalizeVersion(arguments.version);
		var b = normalizeVersion(arguments.minimum);
		var len = max(arrayLen(a), arrayLen(b));

		for (var i = 1; i <= len; i++) {
			var av = i <= arrayLen(a) ? val(a[i]) : 0;
			var bv = i <= arrayLen(b) ? val(b[i]) : 0;
			if ( av > bv ) return true;
			if ( av < bv ) return false;
		}
		return true;
	}

	mcp    = getExtensionStatus(MCP_EXT_ID);
	lucene = getExtensionStatus(LUCENE_EXT_ID);

	astSupported = structKeyExists( getFunctionList(), "astFromString" );

	mcpSearchReady = mcp.installed
		&& lucene.installed
		&& versionAtLeast(mcp.version, MCP_SEARCH_MIN_VERSION)
		&& val(listFirst(lucene.version, ".")) >= 3;

	mcpAstReady = mcp.installed
		&& versionAtLeast(mcp.version, MCP_AST_MIN_VERSION)
		&& astSupported;

	if ( mcp.installed && !versionAtLeast(mcp.version, MCP_AST_MIN_VERSION) ) {
		mcp.note = "Installed, but AST tools need MCP Server #MCP_AST_MIN_VERSION# or later.";
	} else if ( mcp.installed ) {
		mcp.note = "Provides get_lucee_function, get_lucee_tag, search_lucee_docs, parse_cfml_ast, and query_cfml_ast.";
	}

	if ( lucene.installed && val(listFirst(lucene.version, ".")) < 3 ) {
		lucene.note = "Installed, but search_lucee_docs requires Lucene 3 or later.";
	} else if ( lucene.installed ) {
		lucene.note = "Indexes functions, tags, and recipes for search_lucee_docs.";
	}

	luceneMajor = lucene.installed ? val(listFirst(lucene.version, ".")) : 0;
	mcpVersionOk = mcp.installed && versionAtLeast(mcp.version, MCP_SEARCH_MIN_VERSION);
	luceneVersionOk = lucene.installed && luceneMajor >= 3;

	if ( !mcp.installed ) {
		mcpBadgeClass = "err";
		mcpBadgeLabel = "Missing";
	} else if ( mcpVersionOk ) {
		mcpBadgeClass = "ok";
		mcpBadgeLabel = "Ready";
	} else {
		mcpBadgeClass = "warn";
		mcpBadgeLabel = "Update needed";
	}

	if ( !lucene.installed ) {
		luceneBadgeClass = "err";
		luceneBadgeLabel = "Missing";
	} else if ( luceneVersionOk ) {
		luceneBadgeClass = "ok";
		luceneBadgeLabel = "Ready";
	} else {
		luceneBadgeClass = "warn";
		luceneBadgeLabel = "Lucene 3+ required";
	}

	searchBadgeClass = mcpSearchReady ? "ok" : "warn";
	searchBadgeLabel = mcpSearchReady ? "search_lucee_docs available" : "search_lucee_docs not available yet";

	astBadgeClass = mcpAstReady ? "ok" : "warn";
	astBadgeLabel = mcpAstReady
		? "parse_cfml_ast and query_cfml_ast available"
		: ( astSupported ? "AST tools need MCP Server #MCP_AST_MIN_VERSION#+" : "AST tools need Lucee 7.0.0.296+" );

	mcpVersionLine = mcp.installed ? htmlEditFormat(mcp.name) & " " & htmlEditFormat(mcp.version) : "&mdash;";
	luceneVersionLine = lucene.installed ? htmlEditFormat(lucene.name) & " " & htmlEditFormat(lucene.version) : "&mdash;";
</cfscript>

<header>
	<h1>Lucee MCP Server</h1>
	<p>
		Docker example with JSON-RPC at <code>POST /lucee/mcp/</code> for AI clients.
		Recipes are fetched live from GitHub when search runs.
	</p>
</header>

<main>
	<cfoutput>
	<p class="meta">
		<strong>Lucee</strong> #server.lucee.version# &middot;
		<strong>Java</strong> #server.java.version#
	</p>

	<div class="panel">
		<h2>Installed extensions</h2>
		<div class="ext-grid">
			<div class="ext-card">
				<div>
					<p class="ext-name">MCP Server</p>
					<p class="ext-version">#mcpVersionLine#</p>
				</div>
				<span class="badge #mcpBadgeClass#">#mcpBadgeLabel#</span>
				<p class="ext-note">#htmlEditFormat(mcp.note)#</p>
			</div>

			<div class="ext-card">
				<div>
					<p class="ext-name">Lucene Search</p>
					<p class="ext-version">#luceneVersionLine#</p>
				</div>
				<span class="badge #luceneBadgeClass#">#luceneBadgeLabel#</span>
				<p class="ext-note">#htmlEditFormat(lucene.note)#</p>
			</div>
		</div>
	</div>

	<div class="panel">
		<h2>Tool readiness</h2>
		<p>
			<span class="badge #searchBadgeClass#">#searchBadgeLabel#</span>
			<span class="badge #astBadgeClass#">#astBadgeLabel#</span>
		</p>
		<p>
			Function and tag lookups work with the MCP Server extension alone.
			Full-text search also needs Lucene 3+ and MCP Server #MCP_SEARCH_MIN_VERSION#+.
			AST tools need MCP Server #MCP_AST_MIN_VERSION#+ and Lucee 7.0.0.296+.
		</p>
		<ul class="compact">
			<li><code>get_lucee_function</code> &mdash; FLD lookup by name</li>
			<li><code>get_lucee_tag</code> &mdash; TLD lookup by name</li>
			<li><code>search_lucee_docs</code> &mdash; Lucene search across functions, tags, and recipes</li>
			<li><code>parse_cfml_ast</code> &mdash; parse CFML into an AST tree or compact summary</li>
			<li><code>query_cfml_ast</code> &mdash; find AST nodes by type, name, line, or built-in status</li>
		</ul>
	</div>
	</cfoutput>

	<div class="panel">
		<h2>Try it</h2>
		<p>
			Use the test console to run <code>initialize</code>, <code>tools/list</code>, and tool calls interactively.
		</p>
		<a class="button" href="/test/">Open MCP Test Console</a>
	</div>
</main>
</body>
</html>
