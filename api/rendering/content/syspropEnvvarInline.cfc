
component {
	function render( required any docTree, required string contentType, required struct args, required string hashParam, boolean markdown=false ) {
		// hashParam contains the envvar name (e.g., "lucee_tag_populate_localscope")
		if ( !len( arguments.hashParam ) ) {
			return "<!-- Missing envvar name in sysprop-envvar content directive -->";
		}

		var envvarName = arguments.hashParam;

		// Get all sysprops and find the matching one
		var allProps = arguments.docTree.getSyspropEnvvars();
		var prop = "";

		for ( var p in allProps ) {
			if ( compareNoCase( p.envvar, envvarName ) == 0 ) {
				prop = p;
				break;
			}
		}

		// If not found, return error
		if ( !isStruct( prop ) || structIsEmpty( prop ) ) {
			return "<!-- Sysprop/envvar not found: #envvarName# -->";
		}

		// Render the sysprop details
		if ( arguments.markdown ) {
			var content = [];
			arrayAppend( content, "" );
			arrayAppend( content, "---" );
			arrayAppend( content, "" );
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

			// Add metadata
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

			// Add related tags
			if ( structKeyExists( prop, "tags" ) && isArray( prop.tags ) && arrayLen( prop.tags ) ) {
				var tagLinks = [];
				for ( var tag in prop.tags ) {
					// Strip cf prefix if present for docs
					var tagKey = left( tag, 2 ) == "cf" ? mid( tag, 3 ) : tag;
					arrayAppend( tagLinks, "[[tag-#tagKey#]]" );
				}
				arrayAppend( content, "**Related tags:** " & arrayToList( tagLinks, ", " ) );
				arrayAppend( content, "" );
			}

			// Add related functions
			if ( structKeyExists( prop, "functions" ) && isArray( prop.functions ) && arrayLen( prop.functions ) ) {
				var funcLinks = [];
				for ( var func in prop.functions ) {
					arrayAppend( funcLinks, "[[function-#func#]]" );
				}
				arrayAppend( content, "**Related functions:** " & arrayToList( funcLinks, ", " ) );
				arrayAppend( content, "" );
			}

			arrayAppend( content, "---" );
			arrayAppend( content, "" );

			return arrayToList( content, chr(10) );
		} else {
			// HTML version
			var content = [];
			arrayAppend( content, "<hr>" );
			arrayAppend( content, "<h4>#prop.envvar#</h4>" );
			arrayAppend( content, "<p><em>SysProp:</em> <code>-D#prop.sysprop#</code>" );
			arrayAppend( content, "<em>EnvVar:</em> <code>#prop.envvar#</code></p>" );

			if ( structKeyExists( prop, "desc" ) && len( trim( prop.desc ) ) ) {
				arrayAppend( content, "<p>#htmlEditFormat( prop.desc )#</p>" );
			}

			// Add metadata
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
			if ( arrayLen( metadata ) ) {
				arrayAppend( content, "<p>" & arrayToList( metadata, " | " ) & "</p>" );
			}

			arrayAppend( content, "<hr>" );
			return arrayToList( content, chr(10) );
		}
	}
}
