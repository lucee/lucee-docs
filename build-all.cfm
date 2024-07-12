<cfprocessingdirective suppressWhitespace="true" />
<cfsetting requesttimeout="1200" />
<cfscript>
	var docsZipFile = "builds/html/lucee-docs.zip";
	if ( fileExists( docsZipFile ) )
		fileDelete( docsZipFile );
	if (directoryExists( "builds/artifacts") ){
		directoryDelete("builds/artifacts", true);
	}
	include  template="import.cfm";
	include  template="build.cfm";

	systemOutput("Generating lucee-docs.zip", true);
	zip action="zip" source="builds/html" file="#docsZipFile#" recurse="true";
	systemOutput( "lucee-docs.zip generated #numberFormat(int(fileInfo(docsZipFile).size/1024))# Kb", true );

	systemOutput( "Copying artifacts for upload to s3", true );
	DirectoryCopy( "builds/html", "builds/artifacts", true);

	systemOutput( "", true );
	systemOutput( "Docs build process complete, ready to upload to S3", true );

</cfscript>
