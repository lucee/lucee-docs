
component {
	function render( required any docTree, required string contentType, required struct args, boolean markdown=false ) {
		// Get all sysprops/envvars from Lucee
		var allProps = getSystemPropOrEnvVar();

		// If no props, return empty
		if ( arrayLen( allProps ) == 0 ) {
			return "";
		}

		// Group by category
		var byCategory = {};
		for ( var prop in allProps ) {
			var cat = structKeyExists( prop, "category" ) && len( prop.category ) ? prop.category : "uncategorized";
			if ( !structKeyExists( byCategory, cat ) ) {
				byCategory[ cat ] = [];
			}
			arrayAppend( byCategory[ cat ], prop );
		}

		// Sort categories alphabetically
		var categories = structKeyArray( byCategory );
		arraySort( categories, "textnocase" );

		// Sort props within each category alphabetically by envvar name
		for ( var cat in byCategory ) {
			arraySort( byCategory[ cat ], function( a, b ) {
				return compareNoCase( a.envvar, b.envvar );
			} );
		}

		// Render with header and formatted like existing entries
		if ( arguments.markdown ) {
			var content = [];
			arrayAppend( content, "" );
			arrayAppend( content, "" );

			// Render each category
			for ( var cat in categories ) {
				// Category header
				arrayAppend( content, "" );
				arrayAppend( content, "## #uCase( left( cat, 1 ) )##right( cat, len( cat ) - 1 )#" );
				arrayAppend( content, "" );

				// Render props in this category
				for ( var prop in byCategory[ cat ] ) {
				arrayAppend( content, "#### #prop.envvar#" );
				arrayAppend( content, "" );
				arrayAppend( content, "*SysProp:* `-D#prop.sysprop#`" );
				arrayAppend( content, "*EnvVar:* `#prop.envvar#`" );
				arrayAppend( content, "" );

				// Add description
				if ( structKeyExists( prop, "desc" ) && len( trim( prop.desc ) ) ) {
					arrayAppend( content, prop.desc );
					arrayAppend( content, "" );
				}

				// Add metadata (skip category since it's in the h2 header)
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
				if ( arrayLen( metadata ) ) {
					arrayAppend( content, arrayToList( metadata, " | " ) );
					arrayAppend( content, "" );
				}

				// Add related tags and functions (combined on one line)
				var related = [];
				if ( structKeyExists( prop, "tags" ) && isArray( prop.tags ) && arrayLen( prop.tags ) ) {
					var tagLinks = [];
					for ( var tag in prop.tags ) {
						// Strip cf prefix if present (cfquery -> query)
						var tagKey = left( tag, 2 ) == "cf" ? mid( tag, 3 ) : tag;
						arrayAppend( tagLinks, "[[tag-#tagKey#]]" );
					}
					arrayAppend( related, "**Tags:** " & arrayToList( tagLinks, ", " ) );
				}
				if ( structKeyExists( prop, "functions" ) && isArray( prop.functions ) && arrayLen( prop.functions ) ) {
					var funcLinks = [];
					for ( var func in prop.functions ) {
						arrayAppend( funcLinks, "[[function-#func#]]" );
					}
					arrayAppend( related, "**Functions:** " & arrayToList( funcLinks, ", " ) );
				}
				if ( arrayLen( related ) ) {
					arrayAppend( content, arrayToList( related, " | " ) );
					arrayAppend( content, "" );
				}
				}
			}
			return arrayToList( content, chr(10) );
		} else {
			// HTML version - wrap in div so CommonMark's <p> tags don't break the structure
			var content = [];
			arrayAppend( content, "<div class='sysprop-envvar-listing'>" );

			// Render each category
			for ( var cat in categories ) {
				// Category header
				arrayAppend( content, "<h2>#uCase( left( cat, 1 ) )##right( cat, len( cat ) - 1 )#</h2>" );

				// Render props in this category
				for ( var prop in byCategory[ cat ] ) {
					arrayAppend( content, "<h4>#prop.envvar#</h4>" );
					arrayAppend( content, "<p><em>SysProp:</em> <code>-D#prop.sysprop#</code>" );
					arrayAppend( content, "<em>EnvVar:</em> <code>#prop.envvar#</code></p>" );

					// Description
					if ( structKeyExists( prop, "desc" ) && len( trim( prop.desc ) ) ) {
						arrayAppend( content, "<p>#htmlEditFormat( prop.desc )#</p>" );
					}

					// Metadata (skip category since it's in the h2 header)
					var metadata = [];
					if ( structKeyExists( prop, "type" ) && len( prop.type ) ) {
						arrayAppend( metadata, "<strong>Type:</strong> " & htmlEditFormat( prop.type ) );
					}
					if ( structKeyExists( prop, "default" ) && !isNull( prop.default ) ) {
						var defaultVal = isBoolean( prop.default ) ? ( prop.default ? "true" : "false" ) : prop.default;
						arrayAppend( metadata, "<strong>Default:</strong> " & htmlEditFormat( defaultVal ) );
					}
					if ( structKeyExists( prop, "introduced" ) && len( prop.introduced ) ) {
						arrayAppend( metadata, "<strong>Introduced:</strong> " & htmlEditFormat( prop.introduced ) );
					}
					if ( structKeyExists( prop, "deprecated" ) && len( prop.deprecated ) ) {
						arrayAppend( metadata, "<strong>Deprecated:</strong> " & htmlEditFormat( prop.deprecated ) );
					}
					if ( arrayLen( metadata ) ) {
						arrayAppend( content, "<p>" & arrayToList( metadata, " | " ) & "</p>" );
					}

					// Related tags and functions (combined on one line)
					var related = [];
					if ( structKeyExists( prop, "tags" ) && isArray( prop.tags ) && arrayLen( prop.tags ) ) {
						var tagLinks = [];
						for ( var tag in prop.tags ) {
							var tagKey = left( tag, 2 ) == "cf" ? mid( tag, 3 ) : tag;
							arrayAppend( tagLinks, "<a href='/reference/tags/#lCase(tagKey)#.html'>" & htmlEditFormat( tag ) & "</a>" );
						}
						arrayAppend( related, "<strong>Tags:</strong> " & arrayToList( tagLinks, ", " ) );
					}
					if ( structKeyExists( prop, "functions" ) && isArray( prop.functions ) && arrayLen( prop.functions ) ) {
						var funcLinks = [];
						for ( var func in prop.functions ) {
							arrayAppend( funcLinks, "<a href='/reference/functions/#lCase(func)#.html'>" & htmlEditFormat( func ) & "</a>" );
						}
						arrayAppend( related, "<strong>Functions:</strong> " & arrayToList( funcLinks, ", " ) );
					}
					if ( arrayLen( related ) ) {
						arrayAppend( content, "<p>" & arrayToList( related, " | " ) & "</p>" );
					}
				}
			}
			arrayAppend( content, "</div>" );
			return arrayToList( content, chr(10) );
		}
	}
}
