component {

	public string function renderHighlights( required string text ) {
		var rendered  = Replace(arguments.text, "#chr(13)##chr(10)#", chr(10), "all"); // standardise on unix line endings
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
		var jars        = [ "../lib/pyg-in-blankets-1.0-SNAPSHOT-jar-with-dependencies.jar" ];
		var highlighter = CreateObject( 'java', 'com.dominicwatson.pyginblankets.PygmentsWrapper', jars );
		var useTryCf    = reFind( "\+trycf$", arguments.language ) > 0;

		if ( arguments.language.reFindNoCase( "^(luceescript|cfs)" ) ) {
			arguments.language = "cfs";
		} else if ( arguments.language.reFindNoCase( "^(lucee|cfm|coldfusion)" ) ) {
			arguments.language = "cfm";
		}

		var highlighted = highlighter.highlight( arguments.code, arguments.language, false );

		if ( useTryCf ) {
			// Lucee's tag island syntax conflicts with markdown syntax, support escaped tag island syntax
			var safeTagIslands = Replace(arguments.code, "\`\`\`", "```", "all");
			var rawCode = '<script type="text/template" id="code-#LCase( Hash( highlighted ) )#" data-trycf="true" data-script="#( arguments.language == 'cfs' )#">'
						&  safeTagIslands
						& '</script>' & Chr(10);
			return rawCode & highlighted;
		}

		return highlighted;
	}

// PRIVATE HELPERS
	private any function _getNextHighlight( required string text, required string startPos=1 ) {
		//var referenceRegex  = "```([a-z\+]+)?\n(.*?)\n```";		
		var referenceRegex  = "\`{3}([a-z\+]+\n)([\s\S]*?(?=\n\`{3}))(\n\`{3})"; // https://regex101.com/r/CpVjpL/1/
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
		//dump (local);		abort;
		return result;
	}

	private boolean function _isWindows(){
		return findNoCase("Windows", SERVER.os.name);
	}

}
