<cfprocessingdirective suppressWhitespace="true" />
<cfsetting requesttimeout="1200" />
<cfscript>
	newline = Chr( 10 );

	function exitCode( required numeric code ) {
		var exitcodeFile = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/.exitcode";
		FileWrite( exitcodeFile, code );
	}

	try {
		startTime = getTickCount();

		logger = new api.build.Logger( opts={ textOnly: true, console: true }, force: true );
		request.loggerFlushEnabled = true;
		logger.logger(" ");
		logger.logger( "Lucee " & server.lucee.version & ", java " & server.java.version );
		logger.logger(" ");

		// Require Lucee 7.x
		if ( listFirst( server.lucee.version, "." ) < 7 ) {
			throw( type="BuildError", message="Lucee 7.x required", detail="This build requires Lucee 7.x or later. Current version: #server.lucee.version#" );
		}
		logger.logger( "assetBundleVersion: " & application.assetBundleVersion );

		// Check all versioned asset files exist
		assetDir = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "builders/html/assets/";
		requiredAssets = [
			"css/base.#application.assetBundleVersion#.min.css",
			"js/dist/base.#application.assetBundleVersion#.min.js",
			"trycf/js/ace/ace-bundle.#application.assetBundleVersion#.js",
			"css/highlight.#application.assetBundleVersion#.css",
			"css/highlight-dark.#application.assetBundleVersion#.css"
		];
		missingAssets = [];
		for ( asset in requiredAssets ) {
			if ( !fileExists( assetDir & asset ) ) {
				missingAssets.append( asset );
			}
		}
		if ( missingAssets.len() ) {
			logger.logger( "Missing versioned asset files: #missingAssets.toList( ', ' )#" );
			throw( message="Run 'npm run build' in builders/html/assets/ to create missing assets" );
		}
		logger.logger( "All versioned assets present" );
		logger.logger( " " );

		threads = 4;
		logger.logger("Using #threads# threads for building the documentation.");

		//savecontent variable="suppressingwhitespacehere" {
			new api.build.BuildRunner(threads=threads).buildAll();
		//}

		//content reset="true" type="text/plain";
		logger.logger( "---" & newline );
		logger.logger( "Documentation built in #NumberFormat( getTickCount()-startTime )#ms" & newline );
		logger.logger( "---" & newline );
	} catch ( any e ) {
		logger.logger( "" & newline );
		logger.logger( "Documentation build error" & newline );
		logger.logger( "-------------------------" & newline );
		logger.logger( "" & newline );
		logger.logger( "[#e.type#] error occurred while building the docs. Message: [#e.message#]. Detail: [#e.detail#]." & newline );
		if ( ( e.tagContext ?: [] ).len() ) {
			logger.logger( "" & newline );
			logger.logger( "Stacktrace:" & newline );
			for( tracePoint in e.tagContext ) {
				logger.logger( "    " & tracepoint.template & " (line #tracepoint.line#)" & newline );
			}
		}

		exitCode( 1 );
		rethrow;
	}
</cfscript>
