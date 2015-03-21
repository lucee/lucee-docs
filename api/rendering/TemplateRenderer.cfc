component {

	public string function render( required string template, struct args={} ) {
		var rendered = "";

		savecontent variable="rendered" {
			include template=arguments.template;
		}

		return Trim( rendered );
	}

	public string function markdownToHtml( required string markdown ) {
		var rendered = new SyntaxHighlighter().renderHighlights( arguments.markdown );

		return new api.parsers.ParserFactory().getMarkdownParser().markdownToHtml( rendered );
	}
}