component {

	public string function renderHighlights( required string text ) {
		var rendered  = arguments.text;
		var highlight = "";
		var pos = 1;

		do {
			highlight = _getNextHighlight( rendered, pos );
			if ( !IsNull( highlight ) ) {
				rendered  = Replace( rendered, highlight.rawMatch, renderHighlight( highlight.code, highlight.language ), "all" );
				pos = highlight.pos;
			}
		} while( !IsNull( highlight ) );

		return rendered;
	}

	public string function renderHighlight( required string code, required string language ) {
		// Strip +trycf suffix for markdown
		var cleanLanguage = arguments.language.reReplace( "\+trycf$", "" );

		// Normalize language names for markdown
		if ( cleanLanguage.reFindNoCase( "^(luceescript|cfs)" ) ) {
			cleanLanguage = "javascript"; // or "js" depending on your markdown renderer
		} else if ( cleanLanguage.reFindNoCase( "^(lucee|cfm|coldfusion)" ) ) {
			cleanLanguage = "html"; // or "cfml" if supported
		} else if ( cleanLanguage eq "yml" ) {
			cleanLanguage = "yaml";
		}

		// Return plain markdown code block
		return "```" & cleanLanguage & chr(10) & arguments.code & chr(10) & "```";
	}

// PRIVATE HELPERS
	private any function _getNextHighlight( required string text, required string startPos=1 ) {
		var referenceRegex  = "```([a-zA-Z\+]+)?\n(.*?)\n```";
		var match = ReFind( referenceRegex, arguments.text, arguments.startPos, true );
		var found           = match.len[1] > 0;
		var result          = {};

		if ( !found ) {
			return;
		}

		var precedingContent = match.pos[1] == 1 ? "" : Trim( Left( arguments.text, match.pos[1]-1 ) );
		var matchIsWithinCodeBlock = precedingContent.endsWith( "<pre>" ) || precedingContent.endsWith( "<code>" );

		if ( matchIsWithinCodeBlock ) {
			return _getNextHighlight( arguments.text, match.pos[1]+match.len[1] );
		}

		result = {
			  rawMatch = Mid( arguments.text, match.pos[1], match.len[1] )
			, code     = Mid( arguments.text, match.pos[3], match.len[3] )
			, pos = match.len[3]
		};

		if ( match.pos[2] ) {
			result.language = Mid( arguments.text, match.pos[2], match.len[2] );
		} else {
			result.language = "text";
		}

		return result;
	}

}
