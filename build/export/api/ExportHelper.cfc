/**
 * This service provides helper methods for getting at the RAW documentation
 * found in this repository in a structured way. Use it in your documentation
 * builders to query the documents in readiness for outputting into various
 * formats.
 *
 */
component {

// CONSTRUCTOR
	public any function init( required string rootDocsDirectory ) {
		_setRootDocsDirectory( arguments.rootDocsDirectory );

		return this;
	}

// PUBLIC API
	public array function listFunctions() {
		return DeserializeJson( FileRead( _getRootDocsDirectory() & "/reference/functions.json" ) );
	}

	public array function listTags() {
		return DeserializeJson( FileRead( _getRootDocsDirectory() & "/reference/tags.json" ) );
	}

	public LuceeFunction function getFunction( required string functionName ) {
		return new beans.LuceeFunction(
			  specificationJsonFile = _getRootDocsDirectory() & "/reference/functions/#LCase( arguments.functionName )#/specification.json"
			, includeResolver       = new IncludeResolver()
		);
	}

	public LuceeTag function getTag( required string tagName ) {
		return new beans.LuceeTag( _getRootDocsDirectory() & "/reference/functions/#LCase( arguments.functionName )#/specification.json" );
	}


// PRIVATE GETTERS AND SETTERS
	private any function _getRootDocsDirectory() output=false {
		return _rootDocsDirectory;
	}
	private void function _setRootDocsDirectory( required any rootDocsDirectory ) output=false {
		_rootDocsDirectory = arguments.rootDocsDirectory;
	}
}