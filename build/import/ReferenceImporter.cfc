/**
 * Logic to build json data sources for the reference documentation
 * from source files in Lucee's codebase
 *
 */
component {
	processingdirective preserveCase=true;

// CONSTRUCTOR
	public any function init(){
		variables.buildProperties = new BuildProperties();
		variables.cwd = GetDirectoryFromPath( GetCurrentTemplatePath() );

		return this;
	}

// PUBLIC API
	public void function importAll() {
		importFunctionReference();
		importTagReference();
	}

	public void function importFunctionReference() {
		var convertedFuncs = {};
		var referenceXml   = XmlParse( buildProperties.getFunctionReferenceUrl() );
		var functions      = XmlSearch( referenceXml, "/func-lib/function" );

		for( var func in functions ) {
			var convertedFunc = _parseXmlFunctionDefinition( func );

			convertedFuncs[ convertedFunc.name ] = convertedFunc;
		}

		_writeFunctionsToFile( convertedFuncs );
	}

	public void function importTagReference() {
		var convertedTags = {};
		var referenceXml  = XmlParse( buildProperties.getTagReferenceUrl() );
		var tags          = XmlSearch( referenceXml, "/taglib/tag" );

		var childNodeNames = {};
		for( var tag in tags ) {
			var convertedTag = _parseXmlTagDefinition( tag );

			convertedTags[ convertedTag.name ] = convertedTag;
		}
		_writeTagsToFile( convertedTags );
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
		var nextChar = '';
		var inStringLiteral = false;
		var isEscaped = false;

		for (var i=0; i<strLen; i++) {
			char = str.substring(i,i+1);
			nextChar = i >= strLen-1 ? "" : str.substring(i,i+2);

			if ( !inStringLiteral && !isEscaped && ( char == '}' || char == ']' ) ) {
				retval = retval & newLine;
				pos = pos - 1;

				for (var j=0; j<pos; j++) {
					retval = retval & indentStr;
				}
			}

			retval = retval & char;

			if ( !inStringLiteral && !isEscaped && ( ( char == '{' && nextChar != '}' ) || ( char == '[' && nextChar != ']' ) || char == ',' ) ) {
				retval = retval & newLine;

				if (char == '{' || char == '[') {
					pos = pos + 1;
				}

				for (var k=0; k<pos; k++) {
					retval = retval & indentStr;
				}
			}

			if ( char == '"' && !isEscaped ) {
				inStringLiteral = !inStringLiteral;
			}

			isEscaped = !isEscaped && char == "\";
		}

		return retval;
	};

	private struct function _parseXmlFunctionDefinition( required xml func ) output=false {
		var parsedFunction = StructNew( "linked" );

		parsedFunction.name         = func.name.xmlText  ?: "";
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

	private struct function _parseXmlTagDefinition( required xml tag ) output=false {
		var parsedTag = StructNew( "linked" );

		parsedTag.name                 = tag.name.xmlText ?: NullValue();
		parsedTag.description          = tag.description.xmlText ?: NullValue();
		parsedTag.status               = tag.status.xmlText ?: NullValue();
		parsedTag.appendix             = IsBoolean( tag.apppendix.xmlText ?: "" ) && tag.appendix.xmlText; // ? what does this mean exactly
		parsedTag.bodyContentType      = tag[ "body-content" ].xmlText ?: NullValue(); // better name here?
		parsedTag.attributeType        = tag[ "attribute-type" ].xmlText ?: NullValue(); // better name here?
		parsedTag.minimumAttributes    = tag[ "attribute-min" ].xmlText ?: NullValue(); // better name here?
		parsedTag.handleException      = tag[ "handle-exception" ].xmlText ?: NullValue(); // better name here?
		parsedTag.allowRemovingLiteral = tag[ "allow-removing-literal" ].xmlText ?: NullValue(); // better name here? what does it mean?! It's always "yes".

		parsedTag.sourceClasses = StructNew( "linked" );
		parsedTag.sourceClasses.tag  = tag[ "tag-class" ].xmlText  ?: NullValue();
		parsedTag.sourceClasses.ttt  = tag[ "ttt-class" ].xmlText  ?: NullValue();
		parsedTag.sourceClasses.tdbt = tag[ "tdbt-class" ].xmlText ?: NullValue();
		parsedTag.sourceClasses.att  = tag[ "att-class" ].xmlText  ?: NullValue();
		parsedTag.sourceClasses.tte  = tag[ "tte-class" ].xmlText  ?: NullValue();

		parsedTag.script = StructNew( "linked" );
		parsedTag.script.type                   = tag.script.type.xmlText        ?: NullValue();
		parsedTag.script.runtimeExpressionValue = tag.script.rtexprvalue.xmlText ?: NullValue();
		parsedTag.script.context                = tag.script.context.xmlText     ?: NullValue();

		parsedTag.attributes = [];
		for( var child in tag.xmlChildren ) {
			if ( child.xmlName == "attribute" ) {
				var parsedAttribute = StructNew( "linked" );

				parsedAttribute.name                   = child.name.xmlText ?: NullValue();
				parsedAttribute.type                   = child.type.xmlText ?: NullValue();
				parsedAttribute.default                = IsBoolean( child.default.xmlText ?: "" ) && child.default.xmlText;
				parsedAttribute.defaultValue           = child[ "default-value" ].xmlText ?: NullValue();
				parsedAttribute.description            = child.description.xmlText ?: NullValue();
				parsedAttribute.aliases                = ListToArray( child.alias.xmlText ?: "" );
				parsedAttribute.values                 = ListToArray( child.values.xmlText ?: "" );
				parsedAttribute.status                 = child.status.xmlText ?: NullValue();
				parsedAttribute.required               = IsBoolean( child.required.xmlText ?: "" ) && child.required.xmlText;
				parsedAttribute.noname                 = IsBoolean( child.noname.xmlText ?: "" ) && child.noname.xmlText;
				parsedAttribute.scriptSupport          = child[ "script-support" ].xmlText ?: NullValue();
				parsedAttribute.runTimeExpressionValue = IsBoolean( child.rtexprvalue.xmlText ?: "" ) && child.rtexprvalue.xmlText;

				parsedTag.attributes.append( parsedAttribute );
			}
		}

		return parsedTag;
	}

	private void function _writeFunctionsToFile( required struct convertedFuncs ) {
		var functionNames              = [];
		var referenceDirectory         = buildProperties.getReferenceDirectory();
		var individualFunctionsDir     = referenceDirectory & "/functions/";
		var functionsByCategory        = {};
		var orderedFunctionsByCategory = StructNew( "linked" );

		if ( !DirectoryExists( referenceDirectory ) ) {
			DirectoryCreate( referenceDirectory, true );
		}
		if ( !DirectoryExists( individualFunctionsDir ) ) {
			DirectoryCreate( individualFunctionsDir, true );
		}

		for( var functionName in convertedFuncs ) {
			var func = convertedFuncs[ functionName ];

			functionNames.append( LCase( functionName ) );

			_stubFunctionEditorialFiles( func );

			for( var keyword in func.keywords ) {
				keyword = LCase( keyword );
				functionsByCategory[ keyword ] = functionsByCategory[ keyword ] ?: [];
				functionsByCategory[ keyword ].append( LCase( func.name ) )
			}
		}

		for( var category in functionsByCategory.keyArray().sort( "textnocase" ) ) {
			orderedFunctionsByCategory[ category ] = functionsByCategory[ category ].sort( "textnocase" );
		}

		FileWrite( referenceDirectory & "/functions.json", _serializeJson( functionNames.sort( "text" ) ) ) ;
		FileWrite( referenceDirectory & "/functions_by_category.json", _serializeJson( orderedFunctionsByCategory ) ) ;
	}

	private void function _writeTagsToFile( required struct convertedTags ) {
		var referenceDirectory = buildProperties.getReferenceDirectory();
		var tagsDir   = referenceDirectory & "/tags/";
		var tagNames = [];

		if ( !DirectoryExists( tagsDir ) ) {
			DirectoryCreate( tagsDir, true );
		}

		for( var tagName in convertedTags ) {
			var tag = convertedTags[ tagName ];
			tagNames.append( LCase( tagName ) );

			_stubTagEditorialFiles( tag );
		}
		FileWrite( referenceDirectory & "/tags.json", _serializeJson( tagNames.sort( "text" ) ) ) ;
	}

	private void function _stubFunctionEditorialFiles( required struct func ) {
		var referenceDir = buildProperties.getReferenceDirectory();
		var functionDir  = referenceDir & "functions/" &   LCase( arguments.func.name ) & "/";
		var readme       = Replace( FileRead( cwd & "resources/functionReadmeTemplate.md" ), "{{functionname}}", arguments.func.name );

		_createFileIfNotExists( functionDir & "README.md", readme );
		_createFileIfNotExists( functionDir & "description.md", arguments.func.description ?: "" );

		arguments.func.description = "{{include:description.md}}";
		arguments.func.seeAlso     = [];
		arguments.func.examples    = [];
		arguments.func.history     = [];
		arguments.func.returnInfo  = "";

		for( var arg in arguments.func.arguments ) {
			_createFileIfNotExists( functionDir & "/arguments/#LCase( arg.name )#/description.md", arg.description ?: "" );
			arg.description = "{{include:arguments/#LCase( arg.name )#/description.md}}";
		}
		_createFileIfNotExists( functionDir & "specification.json", _serializeJson( arguments.func ) );
	}

	private void function _stubTagEditorialFiles( required struct tag ) {
		var referenceDir = buildProperties.getReferenceDirectory();
		var tagDir       = referenceDir & "tags/" & LCase( arguments.tag.name ) & "/";
		var readme       = Replace( FileRead( cwd & "resources/tagReadmeTemplate.md" ), "{{tagname}}", arguments.tag.name );

		_createFileIfNotExists( tagDir & "README.md", readme );
		_createFileIfNotExists( tagDir & "description.md", arguments.tag.description ?: "" );

		arguments.tag.description = "{{include:description.md}}";
		arguments.tag.seeAlso     = [];
		arguments.tag.examples    = [];
		arguments.tag.history     = [];

		for( var attribute in arguments.tag.attributes ) {
			_createFileIfNotExists( tagDir & "/attributes/#attribute.name#/description.md", attribute.description ?: "" );
			attribute.description = "{{include:/attributes/#attribute.name#/description.md}}";
		}
		_createFileIfNotExists( tagDir & "/specification.json", _serializeJson( arguments.tag ) );

	}

	private void function _createFileIfNotExists( filePath, content ) {
		if ( !DirectoryExists( GetDirectoryFromPath( arguments.filePath ) ) ) {
			DirectoryCreate( GetDirectoryFromPath( arguments.filePath ), true );
		}
		if ( !FileExists( arguments.filePath ) ) {
			FileWrite( arguments.filePath, arguments.content );
		}
	}
}