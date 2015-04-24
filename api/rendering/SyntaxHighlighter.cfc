component {

	public string function renderHighlights( required string text ) {
		var rendered  = arguments.text;
		var highlight = "";

		do {
			highlight = _getNextHighlight( rendered );
			if ( !IsNull( highlight ) ) {
				rendered  = Replace( rendered, highlight.rawMatch, renderHighlight( highlight.code, highlight.language ), "all" );
			}
		} while( !IsNull( highlight ) );

		return rendered;
	}

	public string function renderHighlight( required string code, required string language ) {
		var jars      = [ "../lib/jygments/com.threecrickets.jygments.jar", "../lib/jygments/com.threecrickets.jygments.jar", "../lib/jygments/org.codehaus.jackson.jar", "../lib/jygments/org.codehaus.jackson.map.jar" ]
		var formatter = CreateObject( "java", "com.threecrickets.jygments.format.Formatter", jars ).getByName( "html" );
		var lexer     = CreateObject( "java", "com.threecrickets.jygments.grammar.Lexer", jars ).getByName( arguments.language );

		if ( IsNull( lexer ) ) {
			return arguments.code;
		}

		var tokens = lexer.getTokens( arguments.code );
		var stringWriter = CreateObject( "java", "java.io.StringWriter" ).init();
		formatter.format( tokens, stringWriter );

		var rendered = stringWriter.toString();
		    rendered = ReReplace( rendered, "^.*?<body>(.*?)</body>.*$", "\1" );
		    rendered = ReReplace( rendered, "^.*?<div>(.*?)</div>.*$", "\1" );
		    rendered = Replace( rendered, "<pre>", '<pre class="signature"><code>' );
		    rendered = Replace( rendered, "</pre>", '</code></pre>' );
		    rendered = ReReplace( rendered, "<code>\n+", '<code>' );

		return Trim( rendered );
	}

// PRIVATE HELPERS
	private any function _getNextHighlight( required string text ) {
		var referenceRegex  = "```([a-z]+)?\s(.*?)```";
		var regexFindResult = ReFind( referenceRegex, arguments.text, 1, true );
		var found           = regexFindResult.len[1] > 0;
		var result          = {};

		if ( !found ) {
			return;
		}

		result = {
			  rawMatch = Mid( arguments.text, regexFindResult.pos[1], regexFindResult.len[1] )
			, code     = Trim( Mid( arguments.text, regexFindResult.pos[3], regexFindResult.len[3] ) )
		}

		if ( regexFindResult.pos[2] ) {
			result.language = Mid( arguments.text, regexFindResult.pos[2], regexFindResult.len[2] );
		} else {
			result.language = "html"; // todo, plain?/text?
		}

		return result;
	}

}