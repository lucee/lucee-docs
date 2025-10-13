component {

	variables.syntaxHighlighter = "";
	variables.markdownParser = "";

	public string function render( required string template, struct args={}, string helpers="", boolean markdown=false ) {
		var rendered = "";

		_includeHelpers( arguments.helpers );

		savecontent variable="rendered" {
			include template=arguments.template;
		}

		rendered = _getSyntaxHighlighter().renderHighlights( rendered, arguments.markdown );

		return Trim( rendered );
	}

	public string function _markdownToHtml( required string markdown, required boolean stripParagraph=false ) {
		if ( !len( trim( arguments.markdown ) ) ) {
			return "";
		}

		var rendered = _getSyntaxHighlighter().renderHighlights( arguments.markdown );

		return _getMarkdownParser()._markdownToHtml( rendered, arguments.stripParagraph );
	}

	private void function _includeHelpers( required string helpers ) {
		if ( Len( Trim( arguments.helpers ) ) ) {
			var fullHelpersPath = ExpandPath( arguments.helpers );
			var files           = DirectoryList( fullHelpersPath, false, "path", "*.cfm" );

			for( var file in files ){
				var mappedPath = arguments.helpers & Replace( file, fullHelpersPath, "" );
				include template=mappedPath;
			}
		}
	}

	public string function toc( required string content ) {
		var toc      = "";
		var args     = {}

		args.tocItems = new api.parsers.TocGenerator().generateToc( arguments.content );

		if ( args.tocItems.len() && ( args.tocItems.len() != 1 || args.tocItems[1].children.len() ) ) {
			try {
				savecontent variable="toc" {
					include template="/builders/html/layouts/toc.cfm";
				}
			} catch( missinginclude e ) {}
		}

		return toc;
	}

	private any function _getSyntaxHighlighter() {
		if ( !isObject( variables.syntaxHighlighter ) ) {
			variables.syntaxHighlighter = new SyntaxHighlighter();
		}
		return variables.syntaxHighlighter;
	}

	private any function _getMarkdownParser() {
		if ( !isObject( variables.markdownParser ) ) {
			variables.markdownParser = new api.parsers.ParserFactory().getMarkdownParser();
		}
		return variables.markdownParser;
	}
}