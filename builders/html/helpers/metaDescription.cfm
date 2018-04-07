<cfscript>
	string function getMetaDescription( required any page, required string body ) {
		var description = arguments.page.getDescription();

		if ( !description.len() ) {
			description = arguments.body;
			description = ReReplaceNoCase( description, "^(.*?)</p>.*$", "\1" );
		}
		description = stripHtml( description );

		// max recommended length for a meta description is 320 characters
		if (len(description) gt 320){
			var desc = listToArray(description, "." ); // grab by sentence
			var l = 0;
			for (var s = 1; s < desc.len(); s++){
				if ( (l + desc[s].len()) gt 320 )
					break;
				l += desc[s].len();
			}
			desc = ArraySlice(desc, 1, s);
			if (desc.len() gt 0){
				description = ArrayToList(desc, (".") );
			} else {
				// this was harder than expected!
				description = mind(description, 1 , 320);
			}
		} else {
			// already short enough
		}

		description = ReReplace( description, "\n", " ", "all" );
		description = ReReplace( description, "\s\s+", " ", "all" );

		if (description.len() lt 10)
			request.logger (text="missing / short description: [#description#] #page.getPath()# ");

		return HtmlEditFormat( description );
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