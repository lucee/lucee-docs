component accessors=true {

	property name="functions" type="struct";

	public any function init() {
		_loadExtensionInfo();
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

			if ( convertedFunc.status neq "hidden" && !len( convertedFunc.aliasOf ) )
				functions[ functionName ] = convertedFunc;
		}

		setFunctions( functions );
	}

	private struct function _getFunctionDefinition( required string functionName ) {
		var coreDefinition = getFunctionData( arguments.functionName );
		var parsedFunction = StructNew( "linked" );

		if ( len ( coreDefinition.nameWithCase ?: "" ) )
			parsedFunction.name     = coreDefinition.nameWithCase;
		else
			parsedFunction.name     = coreDefinition.name ?: "";
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
		parsedFunction.aliasOf      = coreDefinition.aliasOf ?: "";
		parsedFunction.arguments    = [];

		if ( structKeyExists( variables.extensionMap, coreDefinition.name ) )
			parsedFunction.srcExtension = variables.extensionMap[ coreDefinition.name ];

		var args = coreDefinition.arguments ?: [];
		for( var arg in args ) {
			var convertedArg = StructNew( "linked" );
			if ( len ( arg.nameWithCase ?: "" ) )
				convertedArg.name    = arg.nameWithCase;
			else
				convertedArg.name    = arg.name        ?: "";
			convertedArg.description = arg.description ?: "";
			convertedArg.type        = arg.type        ?: "";
			convertedArg.required    = IsBoolean( arg.required ?: "" ) && arg.required;
			convertedArg.default     = arg.defaultValue ?: NullValue();
			convertedArg.alias       = arg.alias        ?: "";
			convertedArg.status		 = arg.status		?: NullValue();
			convertedArg.introduced	 = arg.introduced		?: NullValue();
			if ( arg.status neq "hidden" )
				parsedFunction.arguments.append( convertedArg );
		}

		return parsedFunction;
	}

	private void function _loadExtensionInfo(){
		variables.extensionMap = {};
		var cfg = getPageContext().getConfig();
		var configDir = cfg.getConfigDir().toString();
		var fldDir = configDir & "/library/fld/";
		var extensions = cfg.getAllRHExtensions();

		// map functions to extensions by parsing each extension's FLD files
		loop collection=extensions.iterator() item="local.ext" {
			var md = ext.getMetadata();
			var fldNames = md.getFlds();
			if ( arrayLen( fldNames ) == 0 ) continue;

			var extInfo = {
				name: md.getName(),
				id: md._getId(),
				version: md._getVersion()
			};

			for ( var fldName in fldNames ) {
				var fldPath = fldDir & fldName;
				if ( !fileExists( fldPath ) ) continue;

				var xml = xmlParse( fileRead( fldPath ), false, { "http://apache.org/xml/features/disallow-doctype-decl": false } );
				var funcs = xmlSearch( xml, "//function/name" );
				for ( var f in funcs ) {
					variables.extensionMap[ lCase( f.xmlText ) ] = extInfo;
				}
			}
		}
	}

}