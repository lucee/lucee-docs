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
		this.definition = _resolveIncludes( this.definition, GetDirectoryFromPath( arguments.specificationJsonFile ) );
	}

	private any function _resolveIncludes( required any definition, required string rootDirectory ) {

		if ( IsSimpleValue( arguments.definition ) ) {
			return includeResolver.resolveIncludes( arguments.definition, arguments.rootDirectory );
		}

		if ( IsArray( arguments.definition ) ) {
			for( var i=1; i<=arguments.definition.len(); i++ ) {
				arguments.definition[ i ] = _resolveIncludes( arguments.definition[ i ], arguments.rootDirectory );
			}

			return arguments.definition;
		}

		if ( IsStruct( arguments.definition ) ) {
			for( var key in arguments.definition ) {
				arguments.definition[ key ] = _resolveIncludes( arguments.definition[ key ], arguments.rootDirectory );
			}

			return arguments.definition;
		}
	}
}