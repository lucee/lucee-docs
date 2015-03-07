component {
	public void function build( exportHelper, buildDirectory ) {
		var functionNames = exportHelper.listFunctions();
		var functionDir   = _getFunctionsDirectory( buildDirectory );

		_copyStaticAssets( arguments.buildDirectory );

		for( var functionName in functionNames ){
			var renderedFunction = _renderFunction( exportHelper.getFunction( functionName ) );

			FileWrite( functionDir & "/#functionName#.html", Trim( renderedFunction ) );
		}
	}

// PRIVATE HELPERS
	private string function _renderFunction( required any LuceeFunction ){
		var args = { LuceeFunction = arguments.LuceeFunction };
		var rendered = "";

		saveContent variable="rendered" {
			include template="templates/function.cfm";
		}

		args = { title=LuceeFunction.getName(), body=Trim( rendered ), base="../" };

		saveContent variable="rendered" {
			include template="layouts/page.cfm";
		}

		return rendered;
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