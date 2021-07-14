<cfscript>
	string function getMetaDescription( required any page, required string body ) {
		var description = arguments.page.getDescription();
		if ( len(trim(description)) eq 0 and arguments.body.len() ) {
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
			request.logger (text="missing / short description: [#description#] #arguments.page.getPath()#", type="warn");

		return HtmlEditFormat( description );
	}

	function stripHTML( html ) {
		var str = arguments.html;
		str = ReReplaceNoCase(str, "<*style.*?>(.*?)</style>"," ","all");
		str = ReReplaceNoCase(str, "<*script.*?>(.*?)</script>"," ","all");

		str = ReReplaceNoCase(str, "<.*?>"," ","all");
		str = ReReplaceNoCase(str, "^.*?>"," ");
		str = ReReplaceNoCase(str, "<.*$"," ");
		str = ReReplaceNoCase(str, "  "," ","all");

		return Trim( str );
	}
</cfscript>