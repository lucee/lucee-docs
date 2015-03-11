component {

// CONSTRUCTOR
	public any function init( required any builder ) {
		_setBuilder( arguments.builder );
		return this;
	}

// PUBLIC API METHODS
	public string function resolveAllReferences( required string text ) {

	}

// PRIVATE HELPERS

// GETTERS AND SETTERS
	private any function _getBuilder() output=false {
		return _builder;
	}
	private void function _setBuilder( required any builder ) output=false {
		_builder = arguments.builder;
	}

}