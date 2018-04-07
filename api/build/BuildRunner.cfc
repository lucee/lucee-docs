component accessors=true {
	property name="buildersDir" type="string";
	property name="buildsDir"   type="string";
	property name="docTree"     type="any";

// CONSTRUCTOR
	public any function init() {
		setBuildersDir( ExpandPath( "/builders" ) );
		setBuildsDir( ExpandPath( "/builds" ) );
		setDocTree( new api.data.DocTree( ExpandPath( "/docs" ) ) );
		var logger = new api.build.Logger();
		return this;
	}

// PUBLIC API
	public void function buildAll() {
		lock name="buildAll" timeout="1" type ="Exclusive" throwontimeout="true" {
			listBuilders().each( function( builderName ){
				build( builderName );
			} );
		}
	}

	public void function build( required string builderName ) {
		var builder  = getBuilder( arguments.builderName );
		var buildDir = _getBuilderBuildDirectory( arguments.builderName );
		var startTime = getTickCount();

		lock name="build#buildername#" timeout="1" type ="Exclusive" throwontimeout="true" {
			request.logger (text="Start builder: #arguments.builderName# #cgi.script_name#");
			builder.build( docTree, buildDir );
			request.logger (text="Finished builder: #arguments.builderName#, in #NumberFormat( getTickCount()-startTime)#ms");
		}
	}

	public array function listBuilders() {
		var dirs     = DirectoryList( buildersDir, false, "query" );
		var builders = [];

		for( var dir in dirs ){
			if ( dir.type == "dir" && FileExists( dir.directory & "/#dir.name#/Builder.cfc" ) ) {
				builders.append( dir.name );
			}
		}

		return builders.sort( "text", "desc" );
	}

	public any function getBuilder( required string builderName ) {
		var builder = new "builders.#arguments.builderName#.Builder"();

		_decorateBuilderWithHelpers( builder, builderName );

		return builder;
	}

// PRIVATE HELPERS
	private string function _getBuilderBuildDirectory( required string builderName ) {
		var buildDirectory = buildsDir & "/" & arguments.builderName;

		if ( !DirectoryExists( buildDirectory ) ) {
			DirectoryCreate( buildDirectory, true );
		}

		return buildDirectory;
	}

	private void function _decorateBuilderWithHelpers( required any builder, required string builderName ) {
		var rootPathForRenderer = "../../builders/#arguments.builderName#/";

		builder.injectMethod = this.injectMethod;

		builder.injectMethod( "renderLinks", function( required string text ){
			return new api.rendering.WikiLinksRenderer( docTree=docTree ).renderLinks( text=arguments.text, builder=builder );
		} );
		builder.injectMethod( "renderTemplate", function( required string template, struct args={} ){
			var renderer = new api.rendering.TemplateRenderer();
			var rendered = renderer.render( argumentCollection=arguments, template=rootPathForRenderer & arguments.template );

			return builder.renderLinks( rendered );
		} );

		StructDelete( builder, "injectMethod" );
	}

	public void function injectMethod( required string methodName, required any method ) {
		this[ methodName ] = variables[ methodName ] = arguments.method;
	}
}