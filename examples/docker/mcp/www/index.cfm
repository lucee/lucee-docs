<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Lucee MCP Server — Docker Example</title>
	<style>
		body { font-family: sans-serif; max-width: 700px; margin: 60px auto; padding: 0 20px; line-height: 1.6; }
		a.button {
			display: inline-block;
			margin-top: 1rem;
			padding: .65rem 1.2rem;
			background: #0969da;
			color: #fff;
			text-decoration: none;
			border-radius: 6px;
		}
		a.button:hover { background: #0550ae; }
		code { background: #f4f4f4; padding: 2px 5px; border-radius: 3px; }
	</style>
</head>
<body>
	<h1>Lucee MCP Server</h1>
	<p>
		This Docker example runs Lucee 7 with the
		<a href="https://github.com/lucee/extension-mcp-server">MCP Server extension</a>
		installed at startup. The MCP JSON-RPC endpoint is available at
		<code>POST /lucee/mcp/</code>.
	</p>
	<p>
		Use the test console to try every protocol action and tool interactively.
	</p>
	<a class="button" href="/test/">Open MCP Test Console</a>
</body>
</html>
