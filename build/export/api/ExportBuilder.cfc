/**
 * Class for running export builds using a simple
 * convention of /build/export/builders/{buildername}/Builder.cfc
 *
 */
component {

	import "../builders";

// CONSTRUCTOR
	public any function init() {
		var cwd = GetDirectoryFromPath( GetCurrentTemplatePath() );

		variables.buildersDir  = ExpandPath( cwd & "../builders" );
		variables.buildsDir    = ExpandPath( cwd & "../builds"   );
		variables.exportHelper = new ExportHelper( ExpandPath( cwd & "../../../docs" ) );

		return this;
	}

// PUBLIC API
	public void function buildAll() {
		listBuilders().each( function( builderName ){
			build( builderName );
		} );
	}

	public void function build( required string builderName ) {
		var builder  = _getBuilder( arguments.builderName );
		var buildDir = _getBuilderBuildDirectory( arguments.builderName );

		builder.build( exportHelper, buildDir );
	}

	public array function listBuilders() {
		var dirs = DirectoryList( buildersDir, false, "query" );
		var builders = [];

		for( var dir in dirs ){
			if ( dir.type == "dir" && FileExists( dir.directory & "/#dir.name#/Builder.cfc" ) ) {
				builders.append( dir.name );
			}
		}

		return builders.sort( "text" );
	}

// PRIVATE HELPERS
	private any function _getBuilder( required string builderName ) {
		return new "builders.#arguments.builderName#.Builder"()
	}

	private string function _getBuilderBuildDirectory( required string builderName ) {
		var buildDirectory = buildsDir & "/" & arguments.builderName;

		if ( !DirectoryExists( buildDirectory ) ) {
			DirectoryCreate( buildDirectory, true );
		}

		return buildDirectory;
	}
}