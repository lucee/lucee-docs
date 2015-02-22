/**
 * Logic to build json data sources
 * for the reference documentation
 *
 */
component {

// CONSTRUCTOR
	public any function init(){
		variables.buildProperties = new BuildProperties();

		return this;
	}

// PUBLIC API
	public void function buildAll() {
		for( version in buildProperties.listVersions() ){
			buildFunctionReference( version );
		}
	}

	public void function buildFunctionReference( required string version ) {
		var convertedFuncs = {};
		var referenceXml   = XmlParse( buildProperties.getProperty( version, "functionReferenceUrl" ) );
		var functions      = XmlSearch( referenceXml, "/func-lib/function" );

		for( var func in functions ) {
			var convertedFunc = {
				  name         = func.name.xmlText  ?: ""
				, class        = func.class.xmlText ?: ""
				, description  = func.description.xmlText ?: ""
				, returnType   = func.return.type.xmlText ?: ""
				, argumentType = func["argument-type"].xmlText ?: ""
				, keywords     = listToArray( func.keywords.xmlText ?: "" )
				, memberName   = func[ "member-name" ].xmlText ?: ""
				, arguments    = []
			};

			for( var child in func.xmlChildren ) {
				if ( child.xmlName == "argument" ) {
					convertedFunc.arguments.append( {
						  name        = ( child.name.xmlText        ?: "" )
						, type        = ( child.type.xmlText        ?: "" )
						, required    = ( child.required.xmlText    ?: "" )
						, default     = ( child.default.xmlText     ?: "" )
						, description = ( child.description.xmlText ?: "" )
					} );
				}
			}

			convertedFuncs[ convertedFunc.name ] = convertedFunc;
		}

		var functionNames = convertedFuncs.keyArray().sort( "textnocase" );
		var jsonDir       = buildProperties.getProperty( version, "rootJsonDirectory" );
		if ( !DirectoryExists( jsonDir ) ) {
			DirectoryCreate( jsonDir, true );
		}

		FileWrite( jsonDir & "/functions.json", _serializeJson( functionNames ) ) ;
	}

// PRIVATE HELPERS
	private string function _serializeJson( required any data ) {
		return _formatJson( SerializeJson( arguments.data ) );
	}

	private string function _formatJson( val ) {
		    var retval = '';
		    var str = val;
		    var pos = 0;
		    var strLen = str.len();
		    var indentStr = '  ';
		    var newLine = Chr(10);
		    var char = '';

		    for (var i=0; i<strLen; i++) {
		        char = str.substring(i,i+1);

		        if (char == '}' || char == ']') {
		            retval = retval & newLine;
		            pos = pos - 1;

		            for (var j=0; j<pos; j++) {
		                retval = retval & indentStr;
		            }
		        }

		        retval = retval & char;

		        if (char == '{' || char == '[' || char == ',') {
		            retval = retval & newLine;

		            if (char == '{' || char == '[') {
		                pos = pos + 1;
		            }

		            for (var k=0; k<pos; k++) {
		                retval = retval & indentStr;
		            }
		        }
		    }

		    return retval;
		};
}