component accessors=true {

	property name="docTree";

	public string function renderReferences( required string text, required any builder ) {
		var rendered  = arguments.text;
		var reference = "";

		do {
			reference = _getNextReference( rendered );
			if ( !IsNull( reference ) ) {
				if ( IsNull( reference.page ) ) {
					rendered = Replace( rendered, reference.rawMatch, ReReplace( reference.rawMatch, "\${", "{!refNotFound" ), "all" );
				} else {
					rendered = Replace( rendered, reference.rawMatch, arguments.builder.renderReference( reference.page ), "all" );
				}
			}
		} while( !IsNull( reference ) );

		return rendered;
	}

// PRIVATE HELPERS
	private any function _getNextReference( required string text ) {
		var referenceRegex  = "\{\{ref:(.*?)\}\}";
		var regexFindResult = ReFind( referenceRegex, arguments.text, 1, true );
		var found           = regexFindResult.len[1] > 0;

		if ( !found ) {
			return;
		}

		var rawMatch    = Mid( arguments.text, regexFindResult.pos[1], regexFindResult.len[1] );
		var referenceId = Mid( arguments.text, regexFindResult.pos[2], regexFindResult.len[2] );
		var page        = getDocTree().getPage( referenceId );

		return {
			  rawMatch = rawMatch
			, page     = page ?: NullValue()
		};
	}
}