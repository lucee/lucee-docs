component accessors=true {
	property name="buildersDir" type="string";
	property name="buildsDir"   type="string";
	property name="docTree"     type="any";
	property name="threads"     type="numeric";

// CONSTRUCTOR
	public any function init(numeric threads=1) {
		setThreads(arguments.threads);
		setBuildersDir( ExpandPath( "/builders" ) );
		setBuildsDir( ExpandPath( "/builds" ) );
		setDocTree( new api.data.DocTree( ExpandPath( "/docs" ), getThreads() ) );
		new api.build.Logger();
		return this;
	}

// PUBLIC API
	public void function buildAll() {
		lock name="buildAll" timeout="1" type ="Exclusive" throwontimeout="true" {
			setDocTree( new api.data.DocTree( ExpandPath( "/docs" ), getThreads() ) );
			listBuilders().each( function( builderName ){
				build( builderName, getThreads() );
			} );
			buildDictionary();
		}
	}

	public any function getDocTree(boolean checkfiles="false") {
		if (arguments.checkfiles)
			variables.docTree.updateTree();
		return variables.docTree;
	};

	public void function build( required string builderName, required numeric threads ) {
		var builder  = getBuilder( arguments.builderName );
		var buildDir = _getBuilderBuildDirectory( arguments.builderName );
		var startTime = getTickCount();

		lock name="build#buildername#" timeout="1" type ="Exclusive" throwontimeout="true" {
			request.logger (text="Start builder: #arguments.builderName# with #threads# thread(s)");
			builder.build( docTree, buildDir, threads );
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

		_decorateBuilderWithHelpers( builder, arguments.builderName );

		return builder;
	}

	public any function buildDictionary() {
		new api.spelling.DictionaryWriter(getBuildsDir() & "/html/dictionaries/").build();
	};

// PRIVATE HELPERS
	private string function _getBuilderBuildDirectory( required string builderName ) {
		var buildDirectory = buildsDir & "/" & arguments.builderName;

		if ( !DirectoryExists( buildDirectory ) ) {
			DirectoryCreate( buildDirectory, true );
		}

		return buildDirectory;
	}

	private void function _decorateBuilderWithHelpers( required any builder, required string builderName ) {
		var _rootPathForRenderer = "../../builders/#arguments.builderName#/";
		var _builder = arguments.builder;
		var _builderName = arguments.builderName;

		arguments.builder.injectMethod = this.injectMethod;

		arguments.builder.injectMethod( "renderLinks", function( required string text ){
			return new api.rendering.WikiLinksRenderer( docTree=variables.docTree ).renderLinks( text=arguments.text, builder=variables._builder );
		} );
		arguments.builder.injectMethod( "renderTemplate", function( required string template, struct args={} ){
			var renderer = new api.rendering.TemplateRenderer();
			var rendered = renderer.render( argumentCollection=arguments, template=_rootPathForRenderer & arguments.template );

			return builder.renderLinks( rendered );
		} );

		StructDelete( arguments.builder, "injectMethod" );
	}

	public void function injectMethod( required string methodName, required any method ) {
		this[ arguments.methodName ] = variables[ arguments.methodName ] = arguments.method;
	}

}