component accessors=true {

	property name="functions" type="struct";

	public any function init( required string sourceFileOrUrl ) {
		_loadFunctionsFromXmlDefinition( arguments.sourceFileOrUrl );

		return this;
	}

	public array function listFunctions() {
		return getFunctions().keyArray();
	}

	public struct function getFunction( required string functionName ) {
		var functions = getFunctions();

		return functions[ arguments.functionName ] ?: {};
	}

// private helpers
	public void function _loadFunctionsFromXmlDefinition( required string sourceFileOrUrl ) {
		var referenceXml = XmlParse( arguments.sourceFileOrUrl );
		var xmlFunctions = XmlSearch( referenceXml, "/func-lib/function" );
		var functions    = StructNew( "linked" );

		for( var func in xmlFunctions ) {
			var convertedFunc = _parseXmlFunctionDefinition( func );

			functions[ convertedFunc.name ] = convertedFunc;
		}

		setFunctions( functions );
	}

	private struct function _parseXmlFunctionDefinition( required xml func ) output=false {
		var parsedFunction = StructNew( "linked" );

		parsedFunction.name         = func.name.xmlText ?: "";
		parsedFunction.memberName   = func[ "member-name" ].xmlText ?: "";
		parsedFunction.description  = func.description.xmlText ?: "";
		parsedFunction.status       = func.status.xmlText ?: "";
		parsedFunction.deprecated   = parsedFunction.status == "deprecated";
		parsedFunction.class        = func.class.xmlText ?: "";
		parsedFunction.returnType   = func.return.type.xmlText ?: "";
		parsedFunction.argumentType = func["argument-type"].xmlText ?: "";
		parsedFunction.keywords     = listToArray( func.keywords.xmlText ?: "" );
		parsedFunction.arguments    = [];

		for( var child in func.xmlChildren ) {
			if ( child.xmlName == "argument" ) {
				var arg = StructNew( "linked" );

				arg.name        = ( child.name.xmlText        ?: "" );
				arg.description = ( child.description.xmlText ?: "" );
				arg.type        = ( child.type.xmlText        ?: "" );
				arg.required    = IsBoolean( child.required.xmlText    ?: "" ) && child.required.xmlText;
				arg.default     = ( child.default.xmlText     ?: "" );

				parsedFunction.arguments.append( arg );
			}
		}

		return parsedFunction;
	}

}