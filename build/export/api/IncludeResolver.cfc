/**
 * This component is used to resolve {{include:file}} directives
 * in the documentation source
 *
 */
 component {

 	public any function init() {
 		return this;
 	}

 	public any function resolveAllIncludes( required any target, required string rootDirectory ) {

		if ( IsSimpleValue( arguments.target ) ) {
			return resolveIncludes( arguments.target, arguments.rootDirectory );
		}

		if ( IsArray( arguments.target ) ) {
			for( var i=1; i<=arguments.target.len(); i++ ) {
				arguments.target[ i ] = resolveAllIncludes( arguments.target[ i ], arguments.rootDirectory );
			}

			return arguments.target;
		}

		if ( IsStruct( arguments.target ) ) {
			for( var key in arguments.target ) {
				arguments.target[ key ] = resolveAllIncludes( arguments.target[ key ], arguments.rootDirectory );
			}

			return arguments.target;
		}

		return arguments.target;
	}

 	public string function resolveIncludes( required string text, required string rootDirectory ) {
 		var complete = false;
 		var resolved = arguments.text;

 		do {
 			var nextIncludeMatch = _findNextInclude( resolved );
 			if ( Len( Trim( nextIncludeMatch ) ) ) {
 				resolved = replace( resolved, "{{include:#nextIncludeMatch#}}", _readInclude( nextIncludeMatch, arguments.rootDirectory ) );
			} else {
				break;
			}
 		} while( !complete );

 		return resolved;
 	}

 // PRIVATE HELPERS
 	private string function _findNextInclude( required string text ) {
 		var regex = "\{\{include:(.*?)\}\}";
    	var result = ReFind( regex, arguments.text, 0, true );

    	if ( result.pos.len() == 2 ) {
        	return Mid( text, result.pos[2], result.len[2] );
    	}

    	return "";
 	}

 	private string function _readInclude( required string inc, required string rootDirectory ) {
 		var fullPath = ReReplace( rootDirectory, "[\\/]$", "" ) & "/" & ReReplace( arguments.inc, "^[\\/]", "" );

 		if ( FileExists( fullPath ) ) {
 			return resolveIncludes( FileRead( fullPath ), fullPath );
 		}

 		return "{{include [#fullPath#] not found}}"
 	}
 }