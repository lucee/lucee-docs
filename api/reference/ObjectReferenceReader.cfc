component accessors=true {

	property name="objects" type="struct";

	public any function init() {
		_loadObjects();

		return this;
	}

	public array function listObjects() {
		return getObjects().keyArray();
	}

	public struct function getObject( required string objectName ) {
		var objects = getObjects();

		return objects[ arguments.objectName ] ?: {};
	}

// private helpers
	public void function _loadObjects() {
		var functionNames = getFunctionList().keyArray().sort( "textnocase" );

		var objects = StructNew("linked");

		for( var functionName in functionNames ) {
			var func = getFunctionData(functionName);

			if ( func.keyExists("member") &&  func.member.count() gt 0){
				var member = func.member;
				if (not objects.keyExists(member.type) )
					objects[member.type] = StructNew("linked");                
			}

			//var convertedFunc = _getFunctionDefinition( functionName );
			//functions[ functionName ] = convertedFunc;
		}                
		setObjects( objects );        
	}

	/*

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
		parsedFunction.member   	= coreDefinition.member ?: {};
		parsedFunction.arguments    = [];

		var args = coreDefinition.arguments ?: [];
		for( var arg in args ) {
			var convertedArg = StructNew( "linked" );

			convertedArg.name        = arg.name        ?: "";
			convertedArg.description = arg.description ?: "";
			convertedArg.type        = arg.type        ?: "";
			convertedArg.required    = IsBoolean( arg.required ?: "" ) && arg.required;
			convertedArg.default     = arg.defaultValue ?: NullValue();

			parsedFunction.arguments.append( convertedArg );
		}

		return parsedFunction;
	}
	*/

}