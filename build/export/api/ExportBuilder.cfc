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
		var builder = new "builders.#arguments.builderName#.Builder"();

		_decorateBuilderWithHelpers( builder, builderName );

		return builder;
	}

	private string function _getBuilderBuildDirectory( required string builderName ) {
		var buildDirectory = buildsDir & "/" & arguments.builderName;

		if ( !DirectoryExists( buildDirectory ) ) {
			DirectoryCreate( buildDirectory, true );
		}

		return buildDirectory;
	}

	private void function _decorateBuilderWithHelpers( required any builder, required string builderName ) {
		var rootPathForRenderer = "../builders/#arguments.builderName#/";

		builder.renderTemplate = function(){
			return new TemplateRenderer( rootPathForRenderer ).render( argumentCollection=arguments );
		};
	}
}