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
		logger.logger ("assetBundleVersion: " & application.assetBundleVersion);
		logger.logger(" ");

		//savecontent variable="suppressingwhitespacehere" {
			new api.build.BuildRunner(threads=1).buildAll();
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
