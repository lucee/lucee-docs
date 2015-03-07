component {

	import "../";

// CONSTRUCTOR
	public any function init( required string specificationJsonFile, required any includeResolver ) {
		variables.includeResolver = arguments.includeResolver;

		_readDataFromFile( arguments.specificationJsonFile );
		return this;
	}

	public string function onMissingMethod( required string methodName, required any methodArguments ) {
		if ( arguments.methodName.startsWith( "get" ) ) {
			var propertyName = ReReplaceNoCase( arguments.methodName, "^get", "" );

			return this.definition[ propertyName ] ?: "";
		}
	}

// HELPERS
	private function _readDataFromFile( required string specificationJsonFile ) {
		this.definition = DeSerializeJson( FileRead( arguments.specificationJsonFile ) );
		this.definition = includeResolver.resolveAllIncludes( this.definition, GetDirectoryFromPath( arguments.specificationJsonFile ) );
	}
}