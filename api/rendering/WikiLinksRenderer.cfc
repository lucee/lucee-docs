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
					var content = arguments.builder.renderContent( getDocTree(), link.content, arguments.markdown );
					rendered = Replace( rendered, link.rawMatch, content, "one" );
					//startPos = link.nextStartPos + len( content );
				} else {
					rendered = Replace( rendered, link.rawMatch,
						arguments.builder.renderLink( link.page ?: NullValue(), link.title, args, arguments.markdown ), "all" );
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

		var precedingContent = match.pos[1] == 1 ? "" : Trim( Left( arguments.text, match.pos[1]-1 ) );
		var matchIsWithinCodeBlock = precedingContent.endsWith( "<pre>" ) || precedingContent.endsWith( "<code>" );

		if ( matchIsWithinCodeBlock ) {
			return _getNextLink( arguments.text, match.pos[1]+match.len[1] );
		}

		var rawMatch  = Mid( arguments.text, match.pos[1], match.len[1] );
		var reference = ListToArray(Mid( arguments.text, match.pos[2], match.len[2] ), "|");
		var pageId    = reference[1];

		if (left( pageId, 9 ) eq "content::"){
			// special content link
			var content = mid( pageId, 10 );
			return {
				type       = "content"
				, rawMatch = rawMatch
				, content  = content
				, nextStartPos: match.pos[2]
			};
		} else {
			var page      = getDocTree().getPage( pageId );
			var title     = reference.len() > 1 ? reference.last() : ( IsNull( page ) ? pageId : page.getTitle() );

			return {
				type       = "link"
				, rawMatch = rawMatch
				, page     = page  ?: NullValue()
				, title    = title ?: pageId
				, nextStartPos: match.pos[2] // not exact but saves reparsing the whole text again
			};
		}
	}
}

