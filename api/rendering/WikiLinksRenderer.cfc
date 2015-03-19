component accessors=true {

	property name="docTree";

	public string function renderLinks( required string text, required any builder ) {
		var rendered = arguments.text;
		var link     = "";

		do {
			link = _getNextLink( rendered );
			if ( !IsNull( link ) ) {
				rendered = Replace( rendered, link.rawMatch, arguments.builder.renderLink( link.page ?: NullValue(), link.title ), "all" );
			}
		} while( !IsNull( link ) );

		return rendered;
	}

// PRIVATE HELPERS
	private any function _getNextLink( required string text ) {
		var referenceRegex  = "\[\[(.*?)\]\]";
		var regexFindResult = ReFind( referenceRegex, arguments.text, 1, true );
		var found           = regexFindResult.len[1] > 0;

		if ( !found ) {
			return;
		}

		var rawMatch  = Mid( arguments.text, regexFindResult.pos[1], regexFindResult.len[1] );
		var reference = Mid( arguments.text, regexFindResult.pos[2], regexFindResult.len[2] );
		var slug      = ListFirst( reference, "|" );
		var page      = getDocTree().getPageBySlug( slug );
		var title     = ListLen( reference, "|" ) > 1 ? ListRest( reference, "|" ) : ( IsNull( page ) ? slug : page.getTitle() );

		return {
			  rawMatch = rawMatch
			, page     = page ?: NullValue()
			, title    = title
		};
	}
}