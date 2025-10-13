component accessors=true {

	property name="docTree";

	public string function renderLinks( required string text, required any builder, required struct args, boolean markdown=false ) {
		var rendered = arguments.text;
		var link     = "";
		var startPos = 1;
		do {
			link = _getNextLink( rendered, startPos );
			if ( !IsNull( link ) ) {
				if ( link.type eq "content" ) {
					var content = arguments.builder.renderContent( getDocTree(), link.content, arguments.args, arguments.markdown );

					// If this is markdown and the link is on its own line, ensure proper spacing
					if ( arguments.markdown && link.isStandalone ) {
						content = chr(10) & chr(10) & content & chr(10) & chr(10);
					}

					rendered = Replace( rendered, link.rawMatch, content, "one" );
					//startPos = link.nextStartPos + len( content );
				} else {
					rendered = Replace( rendered, link.rawMatch,
						arguments.builder.renderLink( link.page ?: NullValue(), link.title, args, arguments.markdown, link.anchor ?: "" ), "all" );
					startPos = link.nextStartPos;
				}
			}
		} while( !IsNull( link ) );

		return rendered;
	}

// PRIVATE HELPERS
	private any function _getNextLink( required string text, required string startPos=1 ) {
		var referenceRegex  = "\[\[([^\[\]]*[^\[\]]?)\]\]";
		var match = ReFind( referenceRegex, arguments.text, arguments.startPos, true );
		var found			= match.len[1] > 0;

		if ( !found ) {
			return;
		}

		var precedingContent = match.pos[1] == 1 ? "" : Left( arguments.text, match.pos[1]-1 );

		// Check if we're inside an HTML code block by counting open/close tags
		var preOpenCount = ( len( precedingContent ) - len( replaceNoCase( precedingContent, "<pre", "", "all" ) ) ) / 4;
		var preCloseCount = ( len( precedingContent ) - len( replaceNoCase( precedingContent, "</pre>", "", "all" ) ) ) / 6;
		var codeOpenCount = ( len( precedingContent ) - len( replaceNoCase( precedingContent, "<code", "", "all" ) ) ) / 5;
		var codeCloseCount = ( len( precedingContent ) - len( replaceNoCase( precedingContent, "</code>", "", "all" ) ) ) / 7;

		var isInsidePreBlock = preOpenCount > preCloseCount;
		var isInsideCodeBlock = codeOpenCount > codeCloseCount;

		// Check if we're inside a markdown code block (triple backticks)
		var backtickGroups = reMatchNoCase( "```", precedingContent );
		var isInsideMarkdownCodeBlock = arrayLen( backtickGroups ) mod 2 == 1;

		if ( isInsidePreBlock || isInsideCodeBlock || isInsideMarkdownCodeBlock ) {
			return _getNextLink( arguments.text, match.pos[1]+match.len[1] );
		}

		var rawMatch  = Mid( arguments.text, match.pos[1], match.len[1] );
		var reference = ListToArray(Mid( arguments.text, match.pos[2], match.len[2] ), "|");
		var pageId    = reference[1];

		if (left( pageId, 9 ) eq "content::"){
			// special content link
			var content = mid( pageId, 10 );

			// Check if this link is standalone (on its own line with blank lines around it)
			var isStandalone = false;
			var beforeMatch = match.pos[1] > 1 ? left( arguments.text, match.pos[1] - 1 ) : "";
			var afterMatch = match.pos[1] + match.len[1] <= len( arguments.text ) ? mid( arguments.text, match.pos[1] + match.len[1] ) : "";

			// Check if there's nothing but whitespace/newlines before (or start of text)
			var beforeIsEmpty = len( trim( beforeMatch ) ) == 0 || reFind( "\n\s*$", beforeMatch );
			// Check if there's nothing but whitespace/newlines after (or end of text)
			var afterIsEmpty = len( trim( afterMatch ) ) == 0 || reFind( "^\s*\n", afterMatch );

			isStandalone = beforeIsEmpty || afterIsEmpty;

			return {
				type       = "content"
				, rawMatch = rawMatch
				, content  = content
				, isStandalone = isStandalone
				, nextStartPos: match.pos[2]
			};
		} else {
			// Split pageId and anchor if present
			var anchor = "";
			var pageSlug = pageId;
			if ( find( chr( 35 ), pageId ) ) {
				var parts = listToArray( pageId, chr( 35 ) );
				pageSlug = parts[ 1 ];
				anchor = parts.len() > 1 ? parts[ 2 ] : "";
			}

			var page      = getDocTree().getPage( pageSlug );
			var title     = reference.len() > 1 ? reference.last() : ( IsNull( page ) ? pageId : page.getTitle() );

			return {
				type       = "link"
				, rawMatch = rawMatch
				, page     = page  ?: NullValue()
				, anchor   = anchor
				, title    = title ?: pageId
				, nextStartPos: match.pos[2] // not exact but saves reparsing the whole text again
			};
		}
	}
}

