/**
 * Properties that inform the build about where to get things, etc.
 *
 * @accessors true
 */
component {

	public any function init() {
		var buildDir = GetDirectoryFromPath( GetCurrentTemplatePath() );
		var dataDir  = ExpandPath( buildDir & "/../data/" );

		properties = {
			  importDirectoy     = dataDir & "imported/"
			, editorialDirectory = dataDir & "editorial/"
			, versions           = StructNew( "linked" )
		};

		properties.versions[ "4.5.1" ] = {
		 	  functionReferenceUrl = "https://bitbucket.org/lucee/lucee/raw/a6b37ad6463707576ec03f03e1a3493f1e366a12/lucee-java/lucee-core/src/resource/fld/web-cfmfunctionlibrary_1_0"
		 	, tagReferenceUrl      = "https://bitbucket.org/lucee/lucee/raw/a6b37ad6463707576ec03f03e1a3493f1e366a12/lucee-java/lucee-core/src/resource/tld/web-cfmtaglibrary_1_0"
		};


		return this;
	}

	public array function listVersions() {
		return properties.versions.keyArray();
	}

	public any function getProperty( required string property, string version="", any defaultValue="" ) {
		if ( Len( Trim( arguments.version ) ) ) {
			return properties.versions[ arguments.version ][ arguments.property ] ?: arguments.defaultValue;
		}

		return properties[ arguments.property ] ?: arguments.defaultValue;
	}
}