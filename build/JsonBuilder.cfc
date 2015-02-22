/**
 * Logic to build json data sources for the reference documentation
 *
 */

component {

	processingdirective preserveCase=true;

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
			var convertedFunc = StructNew( "linked" );

			convertedFunc.name         = func.name.xmlText  ?: "";
			convertedFunc.memberName   = func[ "member-name" ].xmlText ?: "";
			convertedFunc.description  = func.description.xmlText ?: "";
			convertedFunc.status       = func.status.xmlText ?: "";
			convertedFunc.deprecated   = convertedFunc.status == "deprecated";
			convertedFunc.class        = func.class.xmlText ?: "";
			convertedFunc.returnType   = func.return.type.xmlText ?: "";
			convertedFunc.argumentType = func["argument-type"].xmlText ?: "";
			convertedFunc.keywords     = listToArray( func.keywords.xmlText ?: "" );
			convertedFunc.arguments    = [];

			for( var child in func.xmlChildren ) {
				if ( child.xmlName == "argument" ) {
					var arg = StructNew( "linked" );

					arg.name        = ( child.name.xmlText        ?: "" );
					arg.description = ( child.description.xmlText ?: "" );
					arg.type        = ( child.type.xmlText        ?: "" );
					arg.required    = IsBoolean( child.required.xmlText    ?: "" ) && child.required.xmlText;
					arg.default     = ( child.default.xmlText     ?: "" );

					convertedFunc.arguments.append( arg );
				}
			}

			convertedFuncs[ convertedFunc.name ] = convertedFunc;
		}

		_buildFunctionIndex( convertedFuncs, arguments.version );
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

	private void function _buildFunctionIndex( required struct convertedFuncs, required string version ) {
		var functionNames              = arguments.convertedFuncs.keyArray().sort( "textnocase" );
		var jsonDir                    = buildProperties.getProperty( version, "rootJsonDirectory" );
		var individualFunctionsDir     = jsonDir & "functions/";
		var functionsByCategory        = {};
		var orderedFunctionsByCategory = StructNew( "linked" );

		if ( !DirectoryExists( jsonDir ) ) {
			DirectoryCreate( jsonDir, true );
		}
		if ( !DirectoryExists( individualFunctionsDir ) ) {
			DirectoryCreate( individualFunctionsDir, true );
		}

		for( var functionName in convertedFuncs ) {
			var func = convertedFuncs[ functionName ];

			FileWrite( individualFunctionsDir & LCase( func.name ) & ".json", _serializeJson( func ) );

			for( var keyWord in func.keywords ) {
				functionsByCategory[ keyword ] = functionsByCategory[ keyword ] ?: [];
				functionsByCategory[ keyword ].append( func.name )
			}
		}

		for( var category in functionsByCategory.keyArray().sort( "textnocase" ) ) {
			orderedFunctionsByCategory[ category ] = functionsByCategory[ category ].sort( "textnocase" );
		}

		FileWrite( jsonDir & "/functions.json", _serializeJson( functionNames ) ) ;
		FileWrite( jsonDir & "/functions_by_category.json", _serializeJson( orderedFunctionsByCategory ) ) ;
	}
}