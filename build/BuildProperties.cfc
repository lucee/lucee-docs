/**
 * Properties that inform the build about where to get things, etc.
 *
 * @accessors true
 */
component {
	globalProperties = {
		  importDirectoy     = ExpandPath( "/data/imported" )
		, editorialDirectory = ExpandPath( "/data/editorial" )
	};

	versionSpecificProperties = {};
	versionSpecificProperties[ "4.5.1.005" ] = {
		//  functionReferenceUrl = "https://bitbucket.org/lucee/lucee/raw/a6b37ad6463707576ec03f03e1a3493f1e366a12/lucee-java/lucee-core/src/resource/fld/web-cfmfunctionlibrary_1_0"
		//, tagReferenceUrl      = "https://bitbucket.org/lucee/lucee/raw/a6b37ad6463707576ec03f03e1a3493f1e366a12/lucee-java/lucee-core/src/resource/tld/web-cfmtaglibrary_1_0"
		  functionReferenceUrl = "/build/sampleFunctionRef.xml"
		, tagReferenceUrl      = "/build/sampleTagRef.xml"
	};

	public array function listVersions() {
		var versions = versionSpecificProperties.keyArray();

		versions.sort( "textnocase" );

		return versions;
	}

	public any function getProperty( required string property, string version="", any defaultValue="" ) {
		if ( Len( Trim( arguments.version ) ) ) {
			return versionSpecificProperties[ arguments.version ][ arguments.property ] ?: arguments.defaultValue;
		}

		return globalProperties[ arguments.property ] ?: arguments.defaultValue;
	}
}