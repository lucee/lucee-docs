/**
 * Logic to build json data sources for the reference documentation
 * from source files in Lucee's codebase
 *
 */
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
		var referenceReader = new ReferenceReaderFactory().getFunctionReferenceReader( buildProperties.getFunctionReferenceUrl() );

		for( var functionName in referenceReader.listFunctions() ) {
			var convertedFunc = referenceReader.getFunction( functionName );

			if ( !convertedFunc.name.startsWith( '_' ) ) {
				_stubFunctionEditorialFiles( convertedFunc );
			}
		}
	}

	public void function importTagReference() {
		var referenceReader = new ReferenceReaderFactory().getTagReferenceReader( buildProperties.getTagReferenceUrl() );

		for( var tagName in referenceReader.listTags() ) {
			var convertedTag = referenceReader.getTag( tagName );

			if ( !convertedTag.name.startsWith( '_' ) ) {
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
related:
categories:";

		for( var keyword in arguments.func.keywords ){
			pageContent &= Chr(10) & "    - " & keyword;
		}

		pageContent &= Chr(10) & "---

#arguments.func.description#";

		_createFileIfNotExists( functionDir & "function.md", pageContent );


		arguments.func.examples    = [];
		arguments.func.history     = [];
	}

	private void function _stubTagEditorialFiles( required struct tag ) {
		var referenceDir = buildProperties.getTagReferenceDirectory();
		var tagDir       = referenceDir & LCase( arguments.tag.name ) & "/";
		var pageContent  =
"---
title: #arguments.tag.name#
related:
categories:
---

#arguments.tag.description#";

		_createFileIfNotExists( tagDir & "tag.md", arguments.tag.description ?: "" );


		arguments.tag.examples    = [];
		arguments.tag.history     = [];
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