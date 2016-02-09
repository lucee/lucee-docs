<cfscript>
	string function getMetaDescription( required any page, required string body ) {
		var description = arguments.page.getDescription();

		if ( !description.len() ) {
			description = arguments.body;
			description = ReReplaceNoCase( description, "^(.*?)</p>.*$", "\1" );
		}

		description = ReReplace( description, "\n", " ", "all" );
		description = ReReplace( description, "\s\s+", " ", "all" );

		return HtmlEditFormat( stripHtml( description ) );
	}

	function stripHTML( str ) {
		str = ReReplaceNoCase(str, "<*style.*?>(.*?)</style>","","all");
		str = ReReplaceNoCase(str, "<*script.*?>(.*?)</script>","","all");

		str = ReReplaceNoCase(str, "<.*?>","","all");
		str = ReReplaceNoCase(str, "^.*?>","");
		str = ReReplaceNoCase(str, "<.*$","");

		return Trim( str );
	}
</cfscript>