
component {
	function render( required any docTree, required string contentType, required struct args, boolean markdown=false ) {
		// Get current page
		var page = arguments.args.page;

		// Determine function name from page ID (e.g., "function-queryexecute" -> "queryexecute")
		var pageId = page.getId();
		if ( left( pageId, 9 ) != "function-" ) {
			return ""; // Not a function page
		}

		var functionName = mid( pageId, 10 );

		// Get related sysprops
		var sysprops = arguments.docTree.getSyspropsByFunction( functionName );

		// If no related sysprops, return empty
		if ( arrayLen( sysprops ) == 0 ) {
			return "";
		}

		// Sort alphabetically by envvar name
		arraySort( sysprops, function( a, b ) {
			return compareNoCase( a.envvar, b.envvar );
		} );

		// Render section
		if ( arguments.markdown ) {
			var content = [];
			arrayAppend( content, "" );
			arrayAppend( content, "#### Related System Properties / Environment Variables" );
			arrayAppend( content, "" );

			for ( var prop in sysprops ) {
				var anchor = lCase( prop.envvar );
				var desc = structKeyExists( prop, "desc" ) && len( trim( prop.desc ) ) ? prop.desc : "";

				// Build metadata string
				var metadata = [];
				if ( structKeyExists( prop, "type" ) && len( prop.type ) ) {
					arrayAppend( metadata, "**Type:** " & prop.type );
				}
				if ( structKeyExists( prop, "default" ) && !isNull( prop.default ) ) {
					var defaultVal = isBoolean( prop.default ) ? ( prop.default ? "true" : "false" ) : prop.default;
					arrayAppend( metadata, "**Default:** " & defaultVal );
				}
				if ( structKeyExists( prop, "introduced" ) && len( prop.introduced ) ) {
					arrayAppend( metadata, "**Introduced:** " & prop.introduced );
				}
				if ( structKeyExists( prop, "deprecated" ) && len( prop.deprecated ) ) {
					arrayAppend( metadata, "**Deprecated:** " & prop.deprecated );
				}

				var line = "- [[full-list-environment-variables-system-properties###anchor#|#prop.envvar#]]";
				if ( len( desc ) ) {
					line &= " - " & desc;
				}
				if ( arrayLen( metadata ) ) {
					line &= chr(10) & "  *" & arrayToList( metadata, ", " ) & "*";
				}
				arrayAppend( content, line );
			}

			return arrayToList( content, chr(10) );
		} else {
			// HTML version
			var content = [];
			arrayAppend( content, "<h4>Related System Properties / Environment Variables</h4>" );
			arrayAppend( content, "<ul>" );

			for ( var prop in sysprops ) {
				var anchor = lCase( prop.envvar );
				var desc = structKeyExists( prop, "desc" ) && len( trim( prop.desc ) ) ? htmlEditFormat( prop.desc ) : "";

				// Build metadata string
				var metadata = [];
				if ( structKeyExists( prop, "type" ) && len( prop.type ) ) {
					arrayAppend( metadata, "<strong>Type:</strong> " & htmlEditFormat( prop.type ) );
				}
				if ( structKeyExists( prop, "default" ) && !isNull( prop.default ) ) {
					var defaultVal = isBoolean( prop.default ) ? ( prop.default ? "true" : "false" ) : htmlEditFormat( prop.default );
					arrayAppend( metadata, "<strong>Default:</strong> " & defaultVal );
				}
				if ( structKeyExists( prop, "introduced" ) && len( prop.introduced ) ) {
					arrayAppend( metadata, "<strong>Introduced:</strong> " & htmlEditFormat( prop.introduced ) );
				}
				if ( structKeyExists( prop, "deprecated" ) && len( prop.deprecated ) ) {
					arrayAppend( metadata, "<strong>Deprecated:</strong> " & htmlEditFormat( prop.deprecated ) );
				}

				var line = "<li><a href='/recipes/environment-variables-system-properties.html###anchor#'>#prop.envvar#</a>";
				if ( len( desc ) ) {
					line &= " - " & desc;
				}
				if ( arrayLen( metadata ) ) {
					line &= "<br><em>" & arrayToList( metadata, ", " ) & "</em>";
				}
				line &= "</li>";
				arrayAppend( content, line );
			}

			arrayAppend( content, "</ul>" );
			return arrayToList( content, chr(10) );
		}
	}
}
