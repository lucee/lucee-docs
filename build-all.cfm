<cfprocessingdirective suppressWhitespace="true" />
<cfsetting requesttimeout="1200" />
<cfscript>
	var docsZipFile = "builds/html/lucee-docs.zip";
	if ( fileExists( docsZipFile ) )
		fileDelete( docsZipFile );
	include  template="import.cfm";
	include  template="build.cfm";

	systemOutput("Generating lucee-docs.zip", true);
	zip action="zip" source="builds/html" file="#docsZipFile#" recurse="true";
	systemOutput("lucee-docs.zip generated #numberFormat(int(fileInfo(docsZipFile).size/1024))# Kb", true);

	systemOutput("", true);

	systemOutput("Docs build process complete, ready to upload to S3", true);

</cfscript>
