component accessors=true {

	property name="docTree";

	public string function renderLinks( required string text, required any builder ) {
		var rendered = arguments.text;
		var link     = "";
		var startPos = 1;
		do {
			link = _getNextLink( rendered, startPos );
			if ( !IsNull( link ) ) {
				rendered = Replace( rendered, link.rawMatch, arguments.builder.renderLink( link.page ?: NullValue(), link.title ), "all" );
				startPos = link.nextStartPos;
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

		var precedingContent = match.pos[1] == 1 ? "" : Trim( Left( arguments.text, match.pos[1]-1 ) );
		var matchIsWithinCodeBlock = precedingContent.endsWith( "<pre>" ) || precedingContent.endsWith( "<code>" );

		if ( matchIsWithinCodeBlock ) {
			return _getNextLink( arguments.text, match.pos[1]+match.len[1] );
		}

		var rawMatch  = Mid( arguments.text, match.pos[1], match.len[1] );
		var reference = ListToArray(Mid( arguments.text, match.pos[2], match.len[2] ), "|");
		var pageId    = reference[1];
		var page      = getDocTree().getPage( pageId );
		var title     = reference.len() > 1 ? reference.last() : ( IsNull( page ) ? pageId : page.getTitle() );

		return {
			  rawMatch = rawMatch
			, page     = page  ?: NullValue()
			, title    = title ?: pageId
			, nextStartPos: match.pos[2] // not exact but saves reparsing the whole text again
		};
	}
}
