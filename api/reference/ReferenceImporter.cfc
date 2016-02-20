component {
	processingdirective preserveCase=true;

// CONSTRUCTOR
	public any function init(){
		variables.buildProperties = new api.build.BuildProperties();
		variables.cwd = GetDirectoryFromPath( GetCurrentTemplatePath() );

		return this;
	}

// PUBLIC API
	public void function importAll() {
		importFunctionReference();
		importTagReference();
	}

	public void function importFunctionReference() {
		var referenceReader = new ReferenceReaderFactory().getFunctionReferenceReader();

		for( var functionName in referenceReader.listFunctions() ) {
			var convertedFunc = referenceReader.getFunction( functionName );

			if ( !_isHiddenFeature( convertedFunc ) ) {
				_stubFunctionEditorialFiles( convertedFunc );
			}
		}
	}

	public void function importTagReference() {
		var referenceReader = new ReferenceReaderFactory().getTagReferenceReader();

		for( var tagName in referenceReader.listTags() ) {
			var convertedTag = referenceReader.getTag( tagName );

			if ( !_isHiddenFeature( convertedTag ) ) {
				_stubTagEditorialFiles( convertedTag );
			}
		}
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

	private void function _stubFunctionEditorialFiles( required struct func ) {
		var referenceDir = buildProperties.getFunctionReferenceDirectory();
		var functionDir  = referenceDir & LCase( arguments.func.name ) & "/";
		var pageContent  = "---
title: #arguments.func.name#
id: function-#LCase( arguments.func.name )#
related:
categories:";

		for( var keyword in arguments.func.keywords ){
			pageContent &= Chr(10) & "    - " & keyword;
		}

		pageContent &= Chr(10) & "---

#Trim( arguments.func.description )#";

		_createFileIfNotExists( functionDir & "function.md", pageContent );

		var args = arguments.func.arguments ?: "";
		for( var arg in args ) {
			_createFileIfNotExists( functionDir & "_arguments/#arg.name#.md", Trim( arg.description ?: "" ) );
		}

		arguments.func.examples    = [];
		arguments.func.history     = [];
	}

	private void function _stubTagEditorialFiles( required struct tag ) {
		var referenceDir = buildProperties.getTagReferenceDirectory();
		var tagDir       = referenceDir & LCase( arguments.tag.name ) & "/";
		var pageContent  =
"---
title: <cf#LCase( arguments.tag.name )#>
id: tag-#LCase( arguments.tag.name )#
related:
categories:
---

#Trim( arguments.tag.description )#";

		_createFileIfNotExists( tagDir & "tag.md", pageContent );

		var attribs = arguments.tag.attributes ?: "";
		for( var attrib in attribs ) {
			_createFileIfNotExists( tagDir & "_attributes/#attrib.name#.md", Trim( attrib.description ?: "" ) );
		}
	}

	private void function _createFileIfNotExists( filePath, content ) {
		var fileDirectory = GetDirectoryFromPath( arguments.filePath );
		var fileName      = ListLast( arguments.filePath, "/\" );

		if ( !DirectoryExists( fileDirectory ) ) {
			DirectoryCreate( fileDirectory, true );
		}

		var filesInDir = DirectoryList( fileDirectory, false, "name" );

		for( var fileInDir in filesInDir ) {
			if ( fileInDir == fileName ) {
				return; // case insensitive file exists check!
			}
		}

		FileWrite( arguments.filePath, arguments.content );
	}

	private boolean function _isHiddenFeature( required struct feature ) {
		return arguments.feature.name.startsWith( "_" ) || ListFindNoCase( "hidden,unimplemeted", arguments.feature.status ?: "" );
	}
}