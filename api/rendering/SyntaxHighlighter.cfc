component {

	variables.pygmentsInstance = "";

	public string function renderHighlights( required string text, boolean markdown=false ) {
		// For markdown mode, strip +trycf and normalize language names
		if ( arguments.markdown ) {
			var result = arguments.text.reReplace( "```([a-zA-Z]+)\+trycf\n", "```\1" & chr( 10 ), "all" );
			// Replace luceescript with cfml for better LLM compatibility
			result = result.reReplace( "```luceescript\n", "```cfml" & chr( 10 ), "all" );
			result = result.reReplace( "```lucee\n", "```cfml" & chr( 10 ), "all" );
			return result;
		}

		var rendered  = arguments.text;
		var highlight = "";
		var pos = 1;

		do {
			highlight = _getNextHighlight( rendered, pos );
			if ( !IsNull( highlight ) ) {
				rendered  = Replace( rendered, highlight.rawMatch, renderHighlight( highlight.code, highlight.language, arguments.markdown ), "all" );
				pos = highlight.pos;
			}
		} while( !IsNull( highlight ) );

		return rendered;
	}

	public string function renderHighlight( required string code, required string language, boolean markdown=false ) {
		// If markdown mode, just clean up the code block and return it as markdown
		if ( arguments.markdown ) {
			var cleanLanguage = arguments.language.reReplace( "\+trycf$", "" );

			// Normalize language names for markdown
			if ( cleanLanguage.reFindNoCase( "^(luceescript|cfs)" ) ) {
				cleanLanguage = "javascript";
			} else if ( cleanLanguage.reFindNoCase( "^(lucee|cfm|coldfusion)" ) ) {
				cleanLanguage = "html";
			} else if ( cleanLanguage eq "yml" ) {
				cleanLanguage = "yaml";
			}

			return "```" & cleanLanguage & chr( 10 ) & arguments.code & chr( 10 ) & "```";
		}

		var highlighter = _getPygmentsInstance();
		var useTryCf    = reFind( "\+trycf$", arguments.language ) > 0;

		// some code block types don't work, treat them as cfm for now
		var override = {
			"run" : "cfm",
			"plaintext": "text",
			"yml": "yaml"
		};

		if ( arguments.language.reFindNoCase( "^(luceescript|cfs)" ) ) {
			arguments.language = "cfs";
		} else if ( arguments.language.reFindNoCase( "^(lucee|cfm|coldfusion)" ) ) {
			arguments.language = "cfc";
		} else if (structKeyExists(override, arguments.language) ){
			arguments.language = override[ arguments.language ];
		}
		var highlighted = replaceNewLines( highlighter.highlight( arguments.code, arguments.language, "html" ) );

		if ( useTryCf ) {
			var hashId = "code-#LCase( Hash( highlighted ) )#";
			var rawCode = '<script type="text/template" id="#hashId#" data-trycf="true" data-script="#( arguments.language == 'cfs' )#">'
						&     arguments.code
						& '</script>' & Chr(10);
			var codeResult = getCodeResult(arguments.code, arguments.language)
			if ( isEmpty( codeResult ) )
				return rawCode & highlighted;
			var preview = '<div id="result-#hashId#" style="display:none;">#toBase64(codeResult)#</div>';
			return rawCode & highlighted & preview;
		}

		return highlighted;
	}

	private function getCodeResult(code, lang) output=false {
		var codeKey = createGUID();
		server["_luceeExamples_#codeKey#"] = arguments.code;

		// alas server.system is read only
		//var env = duplicate(server.system.environment);
		//var props = duplicate(server.system.properties);
		//server.system.properties = {}; 
		//server.system.environment = {}; 

		try {
			var res = _internalRequest(
				template: "/exampleRunner/index.cfm",
				form: {
					codeKey: codeKey,
					lang: arguments.lang
				}
			);
		} catch(e){
			//request.logger( e.message ); 
			//dump(arguments);
			//rethrow;
			return e.message;
		}

		//server.system.environment = env;
		//server.system.properties = props;

		if (!structKeyExists(res, "fileContent"))
			return "";
		return res.fileContent;
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
		//dump (local);		abort;
		return result;
	}

	private any function _getPygmentsInstance() {
		if ( !isObject( variables.pygmentsInstance ) ) {
			variables.pygmentsInstance = new Pygments();
		}
		return variables.pygmentsInstance;
	}

	private boolean function _isWindows(){
		return findNoCase("Windows", SERVER.os.name);
	}

	// the markdown parser will skip continuous blocks of html, so replace empty lines with a <br>
	function replaceNewLines( html ){
		var src = Replace(html, "#chr(10)##chr(13)#",chr(10), "all");
		var lines = ListToArray(src, chr(10), true);
		arrayEach( lines, function( el, idx, lines ) {
			if ( len( trim( arguments.el ) ) eq 0 ) {
				arguments.lines[ arguments.idx ] = "<br>";
			} else {
				arguments.lines[ arguments.idx ] &= chr(10);
			}
		});
		return arrayToList(lines, "");
	}

}
