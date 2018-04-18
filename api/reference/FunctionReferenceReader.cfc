component accessors=true {

	property name="functions" type="struct";

	public any function init() {
		_loadFunctions();

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
	public void function _loadFunctions() {
		var functionNames = getFunctionList().keyArray().sort( "textnocase" );
		var functions = {};

		for( var functionName in functionNames ) {
			var convertedFunc = _getFunctionDefinition( functionName );

			functions[ functionName ] = convertedFunc;
		}

		setFunctions( functions );
	}

	private struct function _getFunctionDefinition( required string functionName ) {
		var coreDefinition = getFunctionData( arguments.functionName );
		var parsedFunction = StructNew( "linked" );

		parsedFunction.name         = coreDefinition.name ?: "";
		parsedFunction.memberName   = coreDefinition.member.name ?: "";
		parsedFunction.description  = coreDefinition.description ?: "";
		parsedFunction.status       = coreDefinition.status ?: "";
		parsedFunction.deprecated   = parsedFunction.status == "deprecated";
		parsedFunction.class        = coreDefinition.class ?: "";
		parsedFunction.returnType   = coreDefinition.returntype ?: "";
		parsedFunction.argumentType = coreDefinition.argumentType ?: "";
		parsedFunction.keywords     = coreDefinition.keywords ?: [];
		parsedFunction.introduced   = coreDefinition.introduced ?: "";
		parsedFunction.alias        = coreDefinition.alias ?: "";
		parsedFunction.arguments    = [];

		var args = coreDefinition.arguments ?: [];
		for( var arg in args ) {
			var convertedArg = StructNew( "linked" );

			convertedArg.name        = arg.name        ?: "";
			convertedArg.description = arg.description ?: "";
			convertedArg.type        = arg.type        ?: "";
			convertedArg.required    = IsBoolean( arg.required ?: "" ) && arg.required;
			convertedArg.default     = arg.defaultValue ?: NullValue();
			convertedArg.alias       = arg.alias        ?: "";

			parsedFunction.arguments.append( convertedArg );
		}

		return parsedFunction;
	}

}