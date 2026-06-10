<cfscript>
	tagPrefix="cf";
</cfscript>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>MCP Server Test</title>
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
			--err: #cf222e;
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
			padding: 1rem 1.5rem;
		}
		header h1 { margin: 0 0 .25rem; font-size: 1.4rem; }
		header p { margin: 0; color: var(--muted); font-size: .95rem; }
		main {
			display: grid;
			grid-template-columns: 340px 1fr;
			gap: 1rem;
			padding: 1rem 1.5rem 2rem;
			max-width: 1400px;
			margin: 0 auto;
		}
		@media (max-width: 900px) {
			main { grid-template-columns: 1fr; }
		}
		.panel {
			background: var(--card);
			border: 1px solid var(--border);
			border-radius: 8px;
			padding: 1rem;
		}
		.panel h2 {
			margin: 0 0 .35rem;
			font-size: 1rem;
			text-transform: uppercase;
			letter-spacing: .04em;
			color: var(--muted);
		}
		.section-desc {
			margin: 0 0 .85rem;
			font-size: .85rem;
			color: var(--muted);
		}
		.section-desc strong { color: var(--text); }
		.ai-hint {
			margin: 0 0 .65rem;
			padding: .5rem .65rem;
			background: #f0f6ff;
			border-left: 3px solid var(--accent);
			border-radius: 0 4px 4px 0;
			font-size: .82rem;
			color: #424a53;
		}
		.ai-hint code { font-size: .8rem; }
		.panel + .panel { margin-top: 1rem; }
		label {
			display: block;
			font-size: .85rem;
			font-weight: 600;
			margin-bottom: .35rem;
		}
		input, textarea, select {
			width: 100%;
			padding: .5rem .65rem;
			border: 1px solid var(--border);
			border-radius: 6px;
			font: inherit;
			margin-bottom: .75rem;
		}
		textarea { min-height: 80px; font-family: ui-monospace, monospace; font-size: .85rem; }
		.actions { display: flex; flex-wrap: wrap; gap: .5rem; }
		button, .btn {
			appearance: none;
			border: 1px solid var(--border);
			background: var(--card);
			color: var(--text);
			padding: .45rem .75rem;
			border-radius: 6px;
			font: inherit;
			cursor: pointer;
		}
		button:hover, .btn:hover { border-color: var(--accent); color: var(--accent); }
		button.primary {
			background: var(--accent);
			border-color: var(--accent);
			color: #fff;
		}
		button.primary:hover { background: var(--accent-hover); border-color: var(--accent-hover); color: #fff; }
		button.danger:hover { border-color: var(--err); color: var(--err); }
		.tool-block {
			border-top: 1px solid var(--border);
			padding-top: .75rem;
			margin-top: .75rem;
		}
		.tool-block:first-of-type { border-top: 0; padding-top: 0; margin-top: 0; }
		.tool-block h3 { margin: 0 0 .5rem; font-size: .95rem; }
		.tool-block p { margin: 0 0 .5rem; font-size: .85rem; color: var(--muted); }
		#status {
			font-size: .9rem;
			margin-bottom: .75rem;
			padding: .5rem .65rem;
			border-radius: 6px;
			background: var(--bg);
		}
		#status.ok { color: var(--ok); }
		#status.err { color: var(--err); }
		pre {
			background: #0d1117;
			color: #e6edf3;
			padding: 1rem;
			border-radius: 8px;
			overflow: auto;
			font-size: .82rem;
			line-height: 1.45;
			min-height: 200px;
			margin: 0;
		}
		.meta {
			display: flex;
			gap: 1rem;
			flex-wrap: wrap;
			font-size: .85rem;
			color: var(--muted);
			margin-bottom: .75rem;
		}
		.history {
			max-height: 160px;
			overflow: auto;
			font-size: .8rem;
		}
		.history button {
			display: block;
			width: 100%;
			text-align: left;
			margin-bottom: .35rem;
		}
		a { color: var(--accent); }
	</style>
</head>
<body>
<header>
	<h1>MCP Server Test Console</h1>
	<p>Interactive tester for the <a href="https://github.com/lucee/extension-mcp-server" target="_blank" rel="noopener">Lucee MCP Server extension</a> at <code>POST /mcp/</code></p>
</header>

<main>
	<div>
		<div class="panel">
			<h2>Endpoint</h2>
			<p class="section-desc">
				<strong>For AI:</strong> Base URL for all JSON-RPC requests. Use <code>POST</code> with
				<code>Content-Type: application/json</code>. Change only if the MCP server is behind a proxy or alternate mapping.
			</p>
			<label for="endpoint">MCP URL</label>
			<input id="endpoint" type="text" value="/mcp/">
			<div class="actions">
				<button class="primary" id="btnCustom">Send custom request</button>
			</div>
			<label for="customBody" style="margin-top:.75rem">Custom JSON-RPC body</label>
			<textarea id="customBody">{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {}
}</textarea>
		</div>

		<div class="panel">
			<h2>Protocol</h2>
			<p class="section-desc">
				<strong>For AI:</strong> MCP handshake and discovery. Call <code>initialize</code> first when connecting a new
				MCP client session, then <code>tools/list</code> to discover available tools and their <code>inputSchema</code>.
			</p>
			<div class="actions">
				<button data-action="initialize">initialize</button>
				<button data-action="tools/list">tools/list</button>
			</div>
		</div>

		<div class="panel">
			<h2>Tools</h2>
			<p class="section-desc">
				<strong>For AI:</strong> Callable capabilities exposed via <code>tools/call</code>. Use function/tag tools when you
				know the exact name; use <code>search_lucee_docs</code> for exploratory questions or how-to queries.
			</p>

			<div class="tool-block">
				<h3>get_lucee_function</h3>
				<p class="ai-hint">
					<strong>Function Index</strong> — Use when you know a function name and need its full descriptor: arguments,
					types, defaults, return type, and docs URL. Equivalent to reading one entry from the Lucee FLD.
				</p>
				<label for="fnName">Function name</label>
				<input id="fnName" type="text" value="arraySort">
				<div class="actions">
					<button data-tool="get_lucee_function" data-arg-source="fnName">Call tool</button>
					<button data-preset="get_lucee_function" data-args='{"name":"writeOutput"}'>writeOutput</button>
					<button data-preset="get_lucee_function" data-args='{"name":"dateAdd"}'>dateAdd</button>
				</div>
			</div>

			<div class="tool-block">
				<h3>get_lucee_tag</h3>
				<p class="ai-hint">
					<strong>Tag Index</strong> — Use when you know a tag name and need its full descriptor: attributes, types,
					allowed values, and docs URL. Accepts <code>query</code> or <code>cfquery</code>; prefix is optional.
				</p>
				<label for="tagName">Tag name</label>
				<input id="tagName" type="text" value="query">
				<div class="actions">
					<button data-tool="get_lucee_tag" data-arg-source="tagName">Call tool</button>
					<button data-preset="get_lucee_tag" data-args='{"name":"cfloop"}'>cfloop</button>
					<button data-preset="get_lucee_tag" data-args='{"name":"http"}'>http</button>
				</div>
			</div>

			<div class="tool-block">
				<h3>parse_cfml_ast</h3>
				<p class="ai-hint">
					<strong>AST Parser</strong> — Parse CFML source into a JSON Abstract Syntax Tree. Use <code>summary: true</code>
					for a compact digest of functions, tags, and calls. Requires Lucee 7.0.0.296+ and MCP Server 1.0.1.0+.
				</p>
				<label for="astSource">CFML source</label>
				<textarea id="astSource"></textarea>
				<label><input id="astSummary" type="checkbox"> summary (compact digest)</label>
				<div class="actions">
					<button data-tool="parse_cfml_ast" data-arg-map='{"source":"astSource","summary":"astSummary"}'>Call tool</button>
					<button data-preset="parse_cfml_ast" data-preset-id="simple-summary">simple summary</button>
					<button data-preset="parse_cfml_ast" data-preset-id="max-depth">maxDepth 2</button>
				</div>
			</div>

			<div class="tool-block">
				<h3>query_cfml_ast</h3>
				<p class="ai-hint">
					<strong>AST Query</strong> — Search parsed CFML for nodes by <code>nodeType</code>, <code>name</code>,
					<code>line</code>, or <code>builtInOnly</code>. Useful for finding function calls, tags, or UDF definitions.
				</p>
				<label for="queryAstSource">CFML source</label>
				<textarea id="queryAstSource"></textarea>
				<label for="queryNodeType">nodeType (optional)</label>
				<input id="queryNodeType" type="text" value="CallExpression">
				<label for="queryNodeName">name (optional)</label>
				<input id="queryNodeName" type="text" value="len">
				<div class="actions">
					<button data-tool="query_cfml_ast" data-arg-map='{"source":"queryAstSource","nodeType":"queryNodeType","name":"queryNodeName"}'>Call tool</button>
					<button data-preset="query_cfml_ast" data-preset-id="find-len">find len()</button>
					<button data-preset="query_cfml_ast" data-preset-id="find-cfloop">find cfloop</button>
					<button data-preset="query_cfml_ast" data-preset-id="builtin-calls">built-in calls only</button>
				</div>
			</div>

			<div class="tool-block">
				<h3>search_lucee_docs</h3>
				<p class="ai-hint">
					<strong>Recipe Index + Function Index + Tag Index</strong> — Use for natural-language or keyword search when
					you do not know the exact function/tag name. Searches three Lucene indexes:
				</p>
				<ul class="section-desc" style="margin-top:0;padding-left:1.2rem">
					<li><strong>Function Index</strong> — built-in function names and FLD summaries</li>
					<li><strong>Tag Index</strong> — CFML tag names and TLD summaries</li>
					<li><strong>Recipe Index</strong> — lucee-docs how-to guides (configuration, patterns, migration)</li>
				</ul>
				<p class="section-desc">Requires the Lucene 3 extension. Returns ranked passages with source URLs.</p>
				<label for="searchQuery">Query</label>
				<input id="searchQuery" type="text" value="arraySort">
				<label for="maxResults">maxResults (1–10)</label>
				<input id="maxResults" type="number" min="1" max="10" value="3">
				<div class="actions">
					<button data-tool="search_lucee_docs" data-arg-sources="searchQuery,maxResults">Call tool</button>
					<button data-preset="search_lucee_docs" data-args='{"query":"how to read a file","maxResults":3}'>read a file</button>
					<button data-preset="search_lucee_docs" data-args='{"query":"Application.cfc session management","maxResults":3}'>Application.cfc</button>
					<button data-preset="search_lucee_docs" data-args='{"query":"cfquery","maxResults":5}'>cfquery</button>
				</div>
			</div>
		</div>

		<div class="panel">
			<h2>Error cases</h2>
			<p class="section-desc">
				<strong>For AI:</strong> Negative tests for protocol validation. Expected JSON-RPC error codes:
				<code>-32600</code> invalid request, <code>-32601</code> method not found, <code>-32602</code> invalid params,
				<code>-32700</code> parse error.
			</p>
			<div class="actions">
				<button class="danger" data-error="get">GET request</button>
				<button class="danger" data-error="empty">Empty body</button>
				<button class="danger" data-error="unknown">Unknown method</button>
				<button class="danger" data-error="missing-name">tools/call without name</button>
			</div>
		</div>

		<div class="panel">
			<h2>History</h2>
			<p class="section-desc">
				<strong>For AI:</strong> Replays recent requests from this session. Useful to compare responses after server or
				extension changes.
			</p>
			<div class="history" id="history"></div>
		</div>
	</div>

	<div class="panel">
		<h2>Response</h2>
		<p class="section-desc">
			<strong>For AI:</strong> Raw JSON-RPC response. Successful <code>tools/call</code> results are in
			<code>result.content[].text</code> — markdown for function/tag lookups, JSON array for search results.
		</p>
		<div id="status">Ready.</div>
		<div class="meta">
			<span id="metaMethod">—</span>
			<span id="metaStatus">—</span>
			<span id="metaTime">—</span>
		</div>
		<pre id="output">Click an action to send a JSON-RPC request.</pre>
	</div>
</main>

<cfoutput>
<script>
(() => {
	const PRESETS = {
		"parse_cfml_ast:simple-summary": {
			source: "<#tagPrefix#set x = 1>",
			summary: true
		},
		"parse_cfml_ast:max-depth": {
			source: "<#tagPrefix#set x = 1>",
			maxDepth: 2
		},
		"query_cfml_ast:find-len": {
			source: '<#tagPrefix#script>len("a");writeOutput("x");</#tagPrefix#script>',
			nodeType: "CallExpression",
			name: "len"
		},
		"query_cfml_ast:find-cfloop": {
			source: '<#tagPrefix#loop from="1" to="2" index="i"></#tagPrefix#loop>',
			nodeType: "CFMLTag",
			name: "cfloop"
		},
		"query_cfml_ast:builtin-calls": {
			source: '<#tagPrefix#script>len("a");</#tagPrefix#script>',
			builtInOnly: true
		}
	};

	const DEFAULT_SOURCES = {
		astSource: '<#tagPrefix#script>\nfunction greet(name) {\n    return "Hello, " & name;\n}\nwriteOutput(greet("Lucee"));\n</#tagPrefix#script>\n<#tagPrefix#loop from="1" to="2" index="i">\n\t<#tagPrefix#set arrayAppend(items, i)>\n</#tagPrefix#loop>',
		queryAstSource: '<#tagPrefix#script>\nlen("test");\nwriteOutput(dateFormat(now(), "yyyy-mm-dd"));\n</#tagPrefix#script>\n<#tagPrefix#loop from="1" to="3" index="i"></#tagPrefix#loop>'
	};
	let requestId = 1;
	const endpointEl = document.getElementById("endpoint");
	const outputEl = document.getElementById("output");
	const statusEl = document.getElementById("status");
	const historyEl = document.getElementById("history");
	const metaMethod = document.getElementById("metaMethod");
	const metaStatus = document.getElementById("metaStatus");
	const metaTime = document.getElementById("metaTime");

	function nextId() {
		return requestId++;
	}

	function setStatus(text, ok) {
		statusEl.textContent = text;
		statusEl.className = ok === true ? "ok" : (ok === false ? "err" : "");
	}

	function showResult(label, status, ms, data) {
		metaMethod.textContent = "Action: " + label;
		metaStatus.textContent = "HTTP " + status;
		metaTime.textContent = ms + " ms";
		outputEl.textContent = typeof data === "string" ? data : JSON.stringify(data, null, 2);
	}

	function addHistory(label) {
		const btn = document.createElement("button");
		btn.type = "button";
		btn.textContent = label;
		btn.addEventListener("click", () => {
			const entry = btn.dataset.payload;
			if (entry) sendRequest(JSON.parse(entry), label, btn.dataset.method || "POST", btn.dataset.raw === "1");
		});
		historyEl.prepend(btn);
		while (historyEl.children.length > 12) {
			historyEl.removeChild(historyEl.lastChild);
		}
		return btn;
	}

	async function sendRequest(body, label, method, rawBody) {
		const url = endpointEl.value.trim();
		const started = performance.now();
		setStatus("Sending " + label + "…", null);

		try {
			const options = {
				method: method || "POST",
				headers: {}
			};
			if (method !== "GET") {
				options.headers["Content-Type"] = "application/json";
				options.body = rawBody ? body : JSON.stringify(body);
			}

			const res = await fetch(url, options);
			const text = await res.text();
			const ms = Math.round(performance.now() - started);
			let parsed = text;

			try {
				parsed = JSON.parse(text);
			} catch (e) {}

			const ok = res.ok && (!parsed.error);
			setStatus(ok ? "Success" : "Error or JSON-RPC failure", ok);
			showResult(label, res.status, ms, parsed);

			const histBtn = addHistory(label);
			histBtn.dataset.payload = JSON.stringify(body);
			histBtn.dataset.method = method || "POST";
			histBtn.dataset.raw = rawBody ? "1" : "0";
		} catch (err) {
			const ms = Math.round(performance.now() - started);
			setStatus("Request failed: " + err.message, false);
			showResult(label, "—", ms, String(err));
		}
	}

	function rpc(method, params, label) {
		const body = {
			jsonrpc: "2.0",
			id: nextId(),
			method: method
		};
		if (params !== undefined) body.params = params;
		return sendRequest(body, label || method);
	}

	function callTool(name, args, label) {
		return rpc("tools/call", { name: name, arguments: args }, label || ("tools/call → " + name));
	}

	document.querySelectorAll("[data-action]").forEach((btn) => {
		btn.addEventListener("click", () => {
			const action = btn.dataset.action;
			if (action === "initialize") rpc("initialize", {}, "initialize");
			else if (action === "tools/list") rpc("tools/list", {}, "tools/list");
		});
	});

	document.querySelectorAll("[data-tool]").forEach((btn) => {
		btn.addEventListener("click", () => {
			const tool = btn.dataset.tool;
			const args = {};

			if (btn.dataset.argSource) {
				args.name = document.getElementById(btn.dataset.argSource).value.trim();
			}
			if (btn.dataset.argSources) {
				const ids = btn.dataset.argSources.split(",");
				if (ids[0]) args.query = document.getElementById(ids[0].trim()).value.trim();
				if (ids[1]) args.maxResults = parseInt(document.getElementById(ids[1].trim()).value, 10) || 3;
			}
			if (btn.dataset.argMap) {
				const map = JSON.parse(btn.dataset.argMap);
				for (const [argKey, elId] of Object.entries(map)) {
					const el = document.getElementById(elId);
					if (!el) continue;
					if (el.type === "checkbox") {
						if (el.checked) args[argKey] = true;
					} else {
						const value = el.value.trim();
						if (value.length) args[argKey] = value;
					}
				}
			}

			callTool(tool, args);
		});
	});

	document.querySelectorAll("[data-preset]").forEach((btn) => {
		btn.addEventListener("click", () => {
			let args;
			if (btn.dataset.presetId) {
				args = PRESETS[ btn.dataset.preset + ":" + btn.dataset.presetId ];
			} else {
				args = JSON.parse(btn.dataset.args);
			}
			callTool(btn.dataset.preset, args, btn.dataset.preset + " preset");
		});
	});

	for (const [id, value] of Object.entries(DEFAULT_SOURCES)) {
		const el = document.getElementById(id);
		if (el) el.value = value;
	}

	document.querySelectorAll("[data-error]").forEach((btn) => {
		btn.addEventListener("click", async () => {
			const kind = btn.dataset.error;
			if (kind === "get") {
				return sendRequest(null, "GET (expect error)", "GET");
			}
			if (kind === "empty") {
				return sendRequest("", "Empty body", "POST", true);
			}
			if (kind === "unknown") {
				return rpc("does/not/exist", {}, "Unknown method");
			}
			if (kind === "missing-name") {
				return rpc("tools/call", { arguments: {} }, "tools/call without name");
			}
		});
	});

	document.getElementById("btnCustom").addEventListener("click", () => {
		try {
			const body = JSON.parse(document.getElementById("customBody").value);
			sendRequest(body, "Custom request");
		} catch (err) {
			setStatus("Invalid JSON in custom body", false);
			showResult("Custom request", "—", 0, err.message);
		}
	});
})();
</script>
</cfoutput>
</body>
</html>
