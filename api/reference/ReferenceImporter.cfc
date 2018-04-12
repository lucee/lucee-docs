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
		lock name="importAll" timeout="1" type ="Exclusive" throwontimeout="yes" {
			request.logger (text="Start Importing new tags and functions");
			importFunctionReference();
			importTagReference();
			importObjectReference();
			importMethodReference();
			request.logger (text="Finished importing new tags and functions");
		}
	}

	public void function importFunctionReference() {
		var filesImported = 0;
		var referenceReader = new ReferenceReaderFactory().getFunctionReferenceReader();
		var filesImported = 0;
		for( var functionName in referenceReader.listFunctions() ) {
			var convertedFunc = referenceReader.getFunction( functionName );

			if ( !_isHiddenFeature( convertedFunc ) ) {
				filesImported += _stubFunctionEditorialFiles( convertedFunc );
			}
		}
		request.logger (text="#filesImported# functions imported");
	}

	public void function importObjectReference() {
		var filesImported = 0;
		var referenceReader = new ReferenceReaderFactory().getObjectReferenceReader();

		for( var objectName in referenceReader.listObjects() ) {
			var convertedObject = referenceReader.getObject( ObjectName );
			//if ( !_isHiddenFeature( convertedObject ) ) {
				filesImported += _stubObjectEditorialFiles( objectName );
			//}
		}
		request.logger (text="#filesImported# objects imported");
	}


	public void function importMethodReference() {
		var filesImported = 0;
		var referenceReader = new ReferenceReaderFactory().getMethodReferenceReader();
		var objects = referenceReader.listMethods();
		for( var object in objects ) {
			for (var method in objects[object] ){
				var methodData = referenceReader.getMethod( object, method);
				//if ( !_isHiddenFeature( convertedMethod ) ) {
					if (methodData.count() gt 0)
						filesImported += _stubMethodEditorialFiles( methodData );
				//}
			}
		}

		request.logger (text="#filesImported# methods imported");
	}

	public void function importTagReference() {
		var filesImported = 0;
		var referenceReader = new ReferenceReaderFactory().getTagReferenceReader();

		for( var tagName in referenceReader.listTags() ) {
			var convertedTag = referenceReader.getTag( tagName );

			if ( !_isHiddenFeature( convertedTag ) ) {
				filesImported += _stubTagEditorialFiles( convertedTag );
			}
		}
		request.logger (text="#filesImported# tags imported");

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

	private numeric function _stubFunctionEditorialFiles( required struct func ) {
		var filesCreated = 0;
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

		//arguments.func.examples    = [];
		//arguments.func.history     = [];
	}

	private numeric function _stubTagEditorialFiles( required struct tag ) {
		var filesCreated = 0;
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

		filesCreated += _createFileIfNotExists( tagDir & "tag.md", pageContent );

		var attribs = arguments.tag.attributes ?: "";
		for( var attrib in attribs ) {
			filesCreated += _createFileIfNotExists( tagDir & "_attributes/#attrib.name#.md", Trim( attrib.description ?: "" ) );
		}

		return filesCreated;
	}

	private numeric function _stubObjectEditorialFiles( required string obj ) {
		var filesCreated = 0;
		var referenceDir = buildProperties.getObjectReferenceDirectory();
		var objectName = obj;
		var objectDir  = referenceDir & LCase( objectName ) & "/";
		var pageContent  = "---
title: #objectName#
id: object-#LCase( objectName )#
listingStyle: a-z
visible: true
related:
categories:
- object
- #objectName#
---
";
		/*
		for( var keyword in arguments.method.keywords ){
			pageContent &= Chr(10) & "    - " & keyword;
		}

		pageContent &= Chr(10) & "---

#Trim( arguments.method.description )#";
*/

		filesCreated += _createFileIfNotExists( objectDir & "_object.md", pageContent );
/*
		var args = arguments.method.arguments ?: "";
		for( var arg in args ) {
			_createFileIfNotExists( methodDir & "_arguments/#arg.name#.md", Trim( arg.description ?: "" ) );
		}
		*/
		//arguments.method.examples    = [];
		//arguments.method.history     = [];

		return filesCreated;
	}

	private numeric function _stubMethodEditorialFiles( required struct method ) {
		var filesCreated = 0;
		var referenceDir = buildProperties.getObjectReferenceDirectory();
		var methodDir  = referenceDir & LCase( arguments.method.member.type ) & "/" & LCase( arguments.method.member.name ) & "/";

		var pageContent  = "---
title: #arguments.method.member.type#.#arguments.method.member.name#()
id: method-#LCase( arguments.method.member.type )#-#LCase( arguments.method.member.name )#
methodObject: #arguments.method.member.type#
methodName: #arguments.method.member.name#
related:
- function-#arguments.method.name#
- object-#arguments.method.member.type#
categories:
- #arguments.method.member.type#";
		if (arguments.method.keyExists("keywords")){
			for( var keyword in arguments.method.keywords ){
				if (arguments.method.member.type neq keyword)
					pageContent &= Chr(10) & "- " & keyword;
			}
		}

		pageContent &= Chr(10) & "---

#Trim( arguments.method.description )#";


		filesCreated += _createFileIfNotExists( methodDir & "_method.md", pageContent );

		var args = arguments.method.arguments ?: "";
		for( var arg in args ) {
			filesCreated += _createFileIfNotExists( methodDir & "_arguments/#arg.name#.md", Trim( arg.description ?: "" ) );
		}

		//arguments.method.examples    = [];
		//arguments.method.history     = [];

		return filesCreated;
	}

	private numeric function _createFileIfNotExists( filePath, content ) {
		var fileDirectory = GetDirectoryFromPath( arguments.filePath );
		var fileName      = ListLast( arguments.filePath, "/\" );

		if ( !DirectoryExists( fileDirectory ) ) {
			DirectoryCreate( fileDirectory, true );
		}

		var q_files = DirectoryList( path=fileDirectory, recurse=false, listinfo="query", type="all" );
		var exists = false;

		loop query=q_files {
			if ( q_files.name == fileName ) {
				arguments.filePath = q_files.directory & "/" & q_files.name;  // use exact case
				var file = Trim(FileRead(arguments.filePath));
				if ( len(file) == 0){
					if (len(trim(arguments.content)) gt 0){
						request.logger(text="Updating existing zero length file: " & arguments.filePath);
						exists = true;
						break;
					} else {
						request.logger(text="Missing content from Lucee: " & arguments.filePath, type="warn");
						return 0;
					}
				} else {
					return 0; // case insensitive file exists check!
				}
			}
		}
		if (!exists)
			request.logger("Generated file: " & arguments.filePath  & chr(10));
		FileWrite( arguments.filePath, arguments.content );
		return 1;
	}

	private boolean function _isHiddenFeature( required struct feature ) {
		return arguments.feature.name.startsWith( "_" ) || ListFindNoCase( "hidden,unimplemeted", arguments.feature.status ?: "" );
	}
}