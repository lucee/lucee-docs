component accessors=true {

	property name="methods" type="struct";

	public any function init() {
		_loadMethods();

		return this;
	}

	public struct function listMethods() {
		return getMethods();
	}

	public struct function getMethod( required string objectName, required string methodName ) {
		var methods = getMethods();
		var BIFName = getBIFName( objectName, methodName);	

		if (BIFName eq "")
			return {};
		
		try {
			return getFunctionData(BIFName);
		} catch (e) {
			throw (text="couldn't find member #BIFName# [#objectName# #methodname#]");			
		}
	}

	public string function getBIFName( objectDotMethod, method="" ) {
		var methods = getMethods();
		var object = objectDotMethod;

		if ( !len( method ) ) {
			object = listFirst( objectDotMethod, '.' );
			method = listLast ( objectDotMethod, '.' );
		}
		if ( methods.keyExists( object ) && methods[ object ].keyExists( method ) ){
			return  methods[object][method];
		} else {
			throw (message="missing method: #object# #method#");
			return "";
		}
		
	}


// private helpers
	public void function _loadMethods() {
		var objects = getFunctionList().keyArray().sort( "textnocase" );

        var methods = StructNew("linked");

		for( var object in objects) {
            var data = getFunctionData(object);

            if ( data.keyExists("member") && data.member.keyExists("name")){
                var member = data.member;
                if (not methods.keyExists(member.type) )
                    methods[member.type] = StructNew("linked");				
                
                if (not methods[member.type].keyExists(member.name) )
                    methods[member.type][member.name] = StructNew("linked");    				

				methods[member.type][member.name] = object;				
            }			

			//var convertedFunc = _getFunctionDefinition( functionName );
			//functions[ functionName ] = convertedFunc;
		}						
        setMethods( methods );        
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
