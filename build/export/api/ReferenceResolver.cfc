component {

// CONSTRUCTOR
	public any function init( required any builder ) {
		_setBuilder( arguments.builder );
		return this;
	}

// PUBLIC API METHODS
	public string function resolveAllReferences( required string text ) {
		var resolved  = arguments.text;
		var reference = "";

		do {
			reference = _getNextReference( resolved );
			if ( !IsNull( reference ) ) {
				resolved = Replace( resolved, reference.getRaw(), _getBuilder().renderReference( reference ), "all" );
			}
		} while( !IsNull( reference ) );

		return resolved;

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
		var reference          = new beans.Reference( type=referenceType, raw=rawMatch );

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

// GETTERS AND SETTERS
	private any function _getBuilder() output=false {
		return _builder;
	}
	private void function _setBuilder( required any builder ) output=false {
		_builder = arguments.builder;
	}

}