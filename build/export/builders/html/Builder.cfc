component {
	public string function renderReference( required any reference ) {
		var ref = arguments.reference;
		switch( ref.getType() ) {
			case "function":
				return '<a href="function/#LCase( ref.getReference() )#.html">#ref.getReference()#</a>';
			case "tag":
				return '<a href="tag/#LCase( ref.getReference() )#.html">#ref.getReference()#</a>';
			case "external":
				return '<a href="#ref.getReference()#">#ref.getTitle()#</a>';

		}
		return "<a>!notfound</a>";
	}

	public void function build( documentation, buildDirectory ) {
		var functionNames = documentation.listFunctions();
		var functionDir   = _getFunctionsDirectory( buildDirectory );

		_copyStaticAssets( arguments.buildDirectory );

		for( var functionName in functionNames ){
			var renderedFunction = _renderFunction( documentation.getFunction( functionName ) );

			FileWrite( functionDir & "/#functionName#.html", Trim( renderedFunction ) );
		}
	}

// PRIVATE HELPERS
	private string function _renderFunction( required any LuceeFunction ){
		var renderedFunction = renderTemplate(
			  template = "templates/function.cfm"
			, args     = { LuceeFunction = arguments.LuceeFunction }
		);

		return renderTemplate(
			  template = "layouts/page.cfm"
			, args     = { title=LuceeFunction.getName(), body=Trim( renderedFunction ), base="../" }
		);
	}

	private string function _getFunctionsDirectory( required string buildDirectory ) {
		var functionsDir = buildDirectory & "/function";

		if ( !DirectoryExists( functionsDir ) ) {
			DirectoryCreate( functionsDir, true );
		}

		return functionsDir;
	}

	private void function _copyStaticAssets( required string buildDirectory ) {
		DirectoryCopy( GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/assets", arguments.buildDirectory & "/assets", true );
	}

}