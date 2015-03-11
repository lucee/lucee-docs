component {

	import "../../";

	public string function renderReferences( required string text, required any builder ) {
		var rendered  = arguments.text;
		var reference = "";

		do {
			reference = _getNextReference( rendered );
			if ( !IsNull( reference ) ) {
				rendered = Replace( rendered, reference.getRaw(), arguments.builder.renderReference( reference ), "all" );
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

		var rawMatch           = Mid( arguments.text, regexFindResult.pos[1], regexFindResult.len[1] );
		var referenceSubstring = Mid( arguments.text, regexFindResult.pos[2], regexFindResult.len[2] );
		var referenceType      = ListFirst( referenceSubstring, ":" );
		var referenceLink      = ListRest( referenceSubstring, ":" );
		var reference          = new api.data.Reference( type=referenceType, raw=rawMatch );

		switch( referenceType ) {
			case "function":
				reference.setReference( referenceLink );
			break;
			case "tag":
				reference.setReference( referenceLink );
			break;
			case "external":
				if ( ListLen( referenceLink, "|" ) > 1 ) {
					reference.setReference( ListFirst( referenceLink, "|" ) );
					reference.setTitle( ListRest( referenceLink, "|" ) );
				} else {
					reference.setReference( referenceLink );
					reference.setTitle( referenceLink );
				}
			break;

			default:
				return;
		}

		return reference;
	}
}