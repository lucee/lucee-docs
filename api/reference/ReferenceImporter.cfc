component {
	processingdirective preserveCase=true;

// CONSTRUCTOR
	public any function init(numeric threads=1){
		variables.threads = arguments.threads;
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

		Each (referenceReader.listFunctions(), function(functionName){
		//for( var functionName in referenceReader.listFunctions() ) {
			var convertedFunc = referenceReader.getFunction( functionName );

			if ( !_isHiddenFeature( convertedFunc ) ) {
				filesImported += _stubFunctionEditorialFiles( convertedFunc );
			}
		}, true, variables.threads);
		request.logger (text="#filesImported# functions imported");
	}

	public void function importObjectReference() {
		var filesImported = 0;
		var referenceReader = new ReferenceReaderFactory().getObjectReferenceReader();

		Each (referenceReader.listObjects(), function(objectName) {
		//for( var objectName in referenceReader.listObjects() ) {
			var convertedObject = referenceReader.getObject( ObjectName );
			//if ( !_isHiddenFeature( convertedObject ) ) {
				filesImported += _stubObjectEditorialFiles( objectName );
			//}
		}, true, variables.threads);
		request.logger (text="#filesImported# objects imported");
	}


	public void function importMethodReference() {
		var filesImported = 0;
		var referenceReader = new ReferenceReaderFactory().getMethodReferenceReader();
		var objects = referenceReader.listMethods();
		Each (objects, function(object){
		//for( var object in objects ) {
			for (var method in objects[object] ){
				var methodData = referenceReader.getMethod( object, method);
				//if ( !_isHiddenFeature( convertedMethod ) ) {
					if (methodData.count() gt 0)
						filesImported += _stubMethodEditorialFiles( methodData );
				//}
			}
		}, true, variables.threads);

		request.logger (text="#filesImported# methods imported");
	}

	public void function importTagReference() {
		var filesImported = 0;
		var referenceReader = new ReferenceReaderFactory().getTagReferenceReader();

		Each (referenceReader.listTags(), function(tagName){
		//for( var tagName in referenceReader.listTags() ) {
			var convertedTag = referenceReader.getTag( tagName );

			if ( !_isHiddenFeature( convertedTag ) ) {
				filesImported += _stubTagEditorialFiles( convertedTag );
			}
		}, true, variables.threads);
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
		return filesCreated;
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
				var size = q_files.size;
				if (size gt 0)
					size = Trim(FileRead(arguments.filePath)); // check for empty file

				if (size eq 0){
					if (len(trim(arguments.content)) gt 0){
						request.logger(text="Updating existing zero length file: " & arguments.filePath);
						exists = true;
						break;
					} else {
						request.logger(text="Missing content from Lucee: " & arguments.filePath, type="warn");
						return 0;
					}
				} else {
					exists = true; // case insensitive file exists check!
				}
			}
		}
		if (!exists){
			request.logger("Generated file: " & arguments.filePath  & chr(10));
			FileWrite( arguments.filePath, _formatText(arguments.content) );
		} else if (false){ // only run this manually
			var existingContent = FileRead( arguments.filePath );
			_formatText(arguments.content);
			FileWrite( arguments.filePath, _formatText(arguments.content) );
			return 0;
		}
		return 1;
	}

	private boolean function _isHiddenFeature( required struct feature ) {
		return arguments.feature.name.startsWith( "_" ) || ListFindNoCase( "hidden,unimplemeted,unimplemented", arguments.feature.status ?: "" );
	}
	/* the imported descriptions have leading tabs from the xml file, only run this manually */
	private string function _formatText( required string text ) {

		var str = arguments.text;
		return str;
		if (str.contains(chr(9)) ){
			str = replace(str, "#chr(10)##chr(9)##chr(9)##chr(9)#", chr(10), "all");
			str = replace(str, "#chr(10)##chr(9)##chr(9)#", chr(10), "all");
			str = replace(str, "#chr(10)##chr(9)#", chr(10), "all");
			str = replace(str, ".#chr(10)#", ".#chr(10)##chr(10)#", "all");
			str = replace(str, ":#chr(10)#-", ":#chr(10)##chr(10)#-", "all");
			str = replace(str, "#chr(10)##chr(9)#-", ".#chr(10)#-", "all");
			str = replace(str, ".#chr(10)##chr(10)#-", ".#chr(10)#-", "all");

			if (left(str,3) eq "---"){
				// yaml
				str = replace(str, ":#chr(10)##chr(10)#---", ":#chr(10)#---", "all");
				str = replace(str, ":#chr(10)#    -", ":#chr(10)##chr(10)#-", "all");
				var line="";
				var newStr = "";
				var inYaml = true;
				var src = ListToArray(str, chr(10) );
				var i= 0;
				loop array=src index="i" item="line" {
					if (i gt 1 and line eq "---"){
						inYaml = false;
						newStr &= "---" & chr(10) & chr(10);
					} else {
						if (inYaml)	{
							if (trim(line).len() gt 0)
								newStr &= trim(line) & chr(10);
						} else {
							newStr &= line & chr(10);
						}
					}
				}
				str = newstr;
			}

			writeOutput("<pre>#text#</pre><hr><b><pre>#str#</pre></b><hr><hr>");
		}
		return str;
	}
}