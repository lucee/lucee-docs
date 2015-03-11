component accessors=true {

	property name="rootDocsDirectory" type="string";

// PUBLIC API
	public array function listFunctions() {
		// perhaps ditch this file in favour of just reading directories under /functions
		return DeserializeJson( FileRead( getRootDocsDirectory() & "/reference/functions.json" ) );
	}

	public array function listTags() {
		// perhaps ditch this file in favour of just reading directories under /tags
		return DeserializeJson( FileRead( getRootDocsDirectory() & "/reference/tags.json" ) );
	}

	public LuceeFunction function getFunction( required string functionName ) {
		var specFilePath = getRootDocsDirectory() & "/reference/functions/#LCase( arguments.functionName )#/specification.json";
		var definition   = new StructuredDataFileReader().readDataFile( specFilePath );

		return new LuceeFunction( definition=definition );
	}

	public LuceeTag function getTag( required string tagName ) {
		var specFilePath = getRootDocsDirectory() & "/reference/tags/#LCase( arguments.tagName )#/specification.json";
		var definition   = new StructuredDataFileReader().readDataFile( specFilePath );

		return new LuceeTag( definition=definition );
	}
}