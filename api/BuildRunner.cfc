component {

// CONSTRUCTOR
	public any function init() {
		variables.buildersDir = ExpandPath( "/builders" );
		variables.buildsDir   = ExpandPath( "/builds" );
		variables.docTree     = new data.DocTree( ExpandPath( "/docs" ) );

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

		builder.build( docTree, buildDir );
	}

	public array function listBuilders() {
		var dirs     = DirectoryList( buildersDir, false, "query" );
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
		var rootPathForRenderer = "../../builders/#arguments.builderName#/";

		builder.injectMethod = this.injectMethod;

		builder.injectMethod( "renderReferences", function( required string text ){
			return new rendering.ReferenceRenderer( docTree=docTree ).renderReferences( text=arguments.text, builder=builder );
		} );
		builder.injectMethod( "renderTemplate", function( required string template, struct args={} ){
			var renderer = new rendering.TemplateRenderer();
			var rendered = renderer.render( template=rootPathForRenderer & arguments.template, args=arguments.args );

			return builder.renderReferences( rendered );
		} );

		StructDelete( builder, "injectMethod" );
	}

	public void function injectMethod( required string methodName, required any method ) {
		this[ methodName ] = variables[ methodName ] = arguments.method;
	}
}