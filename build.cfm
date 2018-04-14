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

		savecontent variable="suppressingwhitespacehere" {
			new api.build.BuildRunner(threads=1).buildAll();
		}

		content reset="true" type="text/plain";
		echo( "---" & newline );
		echo( "Documentation built in #NumberFormat( getTickCount()-startTime )#ms" & newline );
		echo( "---" & newline );
	} catch ( any e ) {
		echo( "" & newline );
		echo( "Documentation build error" & newline );
		echo( "-------------------------" & newline );
		echo( "" & newline );
		echo( "[#e.type#] error occurred while building the docs. Message: [#e.message#]. Detail: [#e.detail#]." & newline );
		if ( ( e.tagContext ?: [] ).len() ) {
			echo( "" & newline );
			echo( "Stacktrace:" & newline );
			for( var tracePoint in e.tagContext ) {
				echo( "    " & tracepoint.template & " (line #tracepoint.line#)" & newline );
			}
		}

		exitCode( 1 );
	}
</cfscript>
