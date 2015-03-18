component {

	public string function render( required string template, struct args={} ) {
		var rendered = "";

		savecontent variable="rendered" {
			include template=arguments.template;
		}

		rendered = new SyntaxHighlighter().renderHighlights( rendered );

		return Trim( rendered );
	}

	public string function markdownToHtml( required string markdown ) {
		return new api.parsers.ParserFactory().getMarkdownParser().markdownToHtml( arguments.markdown );
	}
}