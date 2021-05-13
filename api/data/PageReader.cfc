component {
	public any function preparePageObject(required string rootDir, required string pageType, required string pageDir, required string pagePath ) {
		var page = "";
		var pageData = readPageFile(arguments.rootDir, arguments.pageType, arguments.pageDir );
		pageData.path = arguments.pagePath;
		var pageFilepath = arguments.rootDir & arguments.pageDir & arguments.pageType;

		try {
			//request.logger(text="[#arguments.pageType#] #pageFilePath#");
			timer label="preparePageObject() #pageData.pageType#" {
				switch( pageData.pageType ?: "" ) {
					case "function":
						pageData.append( _getFunctionSpecification( pageData.slug, pageFilePath ), false );
						page = new FunctionPage( argumentCollection=pageData );
					break;
					case "tag":
						pageData.append( _getTagSpecification( pageData.slug, pageFilePath ), false );
						page = new TagPage( argumentCollection=pageData );
					break;
					case "_object":
						pageData.append( _getObjectSpecification( pageData.slug, pageFilePath ), false );
						page = new ObjectPage( argumentCollection=pageData );
					break;
					case "_method":
						pageData.append( _getMethodSpecification( pageData.methodObject, pageData.methodName,
							pageFilePath ), false );
						page = new MethodPage( argumentCollection=pageData );
					break;
					default:
						page = new Page( argumentCollection=pageData );
				}
			}
		} catch (any e) {
			writeOutput("Error preparing page: " & pageFilePath);
			dump( pageData );
			echo( e );
			abort;
		}

		for( var key in pageData ) {
			if ( !IsNull( pageData[ key ] ) ) {
				page[ key ] = pageData[ key ];
			}
		}

		page.setPath( arguments.pagePath );
		if ( !page.getId().len() ) {
			page.setId( page.getPath() );
		}

		page.setChildren( [] );
		page.setDepth( ListLen( page.getPath(), "/" ) );

		return page;
	}

	// markdown parsing expects unix file line endings
	private string function FileReadAsUnix(required string filePath){
		return _convertToUnixLineEnding( FileRead( arguments.filePath ) );
	}

	// filenames are case sensitive on some platforms, struct keys aren't, used to match files to exact casing
	private struct function getFilesInDirectory(required string dirPath){
		var q = directoryList(path=arguments.dirPath, type="file", listInfo="query");
		var st = {};
		loop query="q"{
			st[q.name] = q.name;
		}
		return st
	}

	public any function readPageFile( required string rootDir, required string pageType, required string pageDir ) {
		var path            = arguments.rootDir & "/" & arguments.pageDir & arguments.pageType;
		var slug            = ListLast( arguments.pageDir, "\/" );

		var fileContent     = FileReadAsUnix( path );
		var data            = _parsePage( fileContent );
		var sortOrder       = "";

		// if the last directory is in the format 00.home, flag is as visible
		if ( ListLen( slug, "." ) > 1 && IsNumeric( ListFirst( slug, "." ) ) ) {
			sortOrder    = ListFirst( slug, "." );
			slug         = ListRest( slug, "." );
			if (not structKeyExists(data, "visible"))
				data.visible = true;
		}

		data.visible    = data.visible  ?: false;
		data.pageType   = listFirst(arguments.pageType, ".");
		data.slug       = data.slug     ?: slug;
		data.sortOrder  = Val( data.sortOrder ?: sortOrder );
		data.sourceFile = "/docs" & arguments.pageDir & arguments.pageType;
		data.sourceDir  = "/docs" & arguments.pageDir;
		data.related    = isArray( data.related ?: "" ) ? data.related : ( Len( Trim( data.related ?: "" ) ) ? [ data.related ] : [ ] );

		//_extractMarkdownLinks(data.related, data.body);
		//new api.parsers.ParserFactory().getMarkdownParser().validateMarkdown( data );

		return data;
	}

	public any function savePageFile(required string pagePath, required string content,
			required struct props){
		request.logger("savePageFile: " & arguments.pagePath);
		var fileContent     = _convertToUnixLineEnding(arguments.content);
		var content = "";

		if (structCount(props) gt 0){
			var yaml = _toYaml( _orderProperties(props) );
			content = "---#chr(10)##yaml#---#chr(10)##chr(10)##fileContent##chr(10)#";
		} else {
			content = fileContent;
		}
		FileWrite(pagePath, content);
		return content;
	}

	public any function readPageFileSource( required string filePath ) {
		var path            = Replace(arguments.filePath,"\","/","all");
		var fileContent     = FileReadAsUnix( path );
		var data            = _parsePage( fileContent );
		return data;
	}

	private struct function _parsePage( required string pageContent ) {
		var yamlAndBody = _splitYamlAndBody( arguments.pageContent );
		var parsed      = { body = yamlAndBody.body };

		if ( yamlAndBody.yaml.len() ) {
			parsed.append( _parseYaml( yamlAndBody.yaml ), false );
		}

		return parsed;
	}

	private struct function _splitYamlAndBody( required string pageContent ) {
		var splitterRegex = "^(\-\-\-\n(.*?)\n\-\-\-\n)?(.*)$";

		return {
			  yaml = Trim( ReReplace( arguments.pageContent, splitterRegex, "\2" ) )
			, body = Trim( ReReplace( arguments.pageContent, splitterRegex, "\3" ) )
		}
	}

	private string function _convertToUnixLineEnding( required string content ){
		return 	REReplace(arguments.content, "\r\n", chr(10), "all");
	}

	private struct function _parseYaml( required string yaml ) {
		return new api.parsers.ParserFactory().getYamlParser().yamlToCfml( arguments.yaml );
	}

	private string function _toYaml( required any data ) {
		return new api.parsers.ParserFactory().getYamlParser().cfmlToYaml( arguments.data );
	}

	private boolean function _isWindows(){
		return findNoCase("Windows", SERVER.os.name);
	}

	private struct function _orderProperties(required struct unOrderedProperties){
		var props = duplicate(arguments.unOrderedProperties);
		// preserve order
		var orderedProps = structNew("linked");
        var propOrder = ['title','id','related','categories','visible'];

        for ( var po = 1; po <= ArrayLen(propOrder); po++){
            if (structKeyExists(props, propOrder[po])){
                orderedProps[propOrder[po]] = props[propOrder[po]];
                structDelete(props, propOrder[po]);
            }
        }
		// add any other remaining properties which don't have an order defined
        for (var other in props)
            orderedProps[other] = props[other];

		return orderedProps;
	}

	private void function _extractMarkdownLinks(required array related, required string bodyContent){
		var links = REMatch("[^|\s]\[([^\]]+)\][^(]", arguments.bodyContent);
		for (var l = 1; l lte arrayLen(links); l++)
			links[l] = ListFirst(links[l],"[]");

		arrayAppend(arguments.related, links , true )
	}

	private struct function _getTagSpecification( required string tagName, required string pageFilePath ){
		var tag           = _getTagReferenceReader().getTag( arguments.tagName );
		var attributes    = tag.attributes ?: [];
		var attributesDir = GetDirectoryFromPath( arguments.pageFilePath ) & "_attributes/";
		var attrFiles = getFilesInDirectory(attributesDir);

		for( var attrib in attributes ) {
			if (structKeyExists(attrFiles, attrib.name & ".md" )){
				var attribDescriptionFile = attributesDir & attrFiles[attrib.name & ".md"]; // avoid file system case problems
				attrib.descriptionOriginal = attrib.description;
				attrib.description = FileReadAsUnix( attribDescriptionFile );
			}
		}

		var examplesFile = GetDirectoryFromPath( arguments.pageFilePath ) & "_examples.md";
		if ( FileExists( examplesFile ) ) {
			tag.examples = FileReadAsUnix( examplesFile );
		}

		return tag;
	}

	private struct function _getFunctionSpecification( required string functionName, required string pageFilePath ) {
		var func    = _getFunctionReferenceReader().getFunction( arguments.functionName );
		var args    = func.arguments ?: [];
		var argsDir = GetDirectoryFromPath( arguments.pageFilePath ) & "_arguments/";
		var argsFiles = getFilesInDirectory(argsDir);

		for( var arg in args ) {
			if (structKeyExists(argsFiles, arg.name & ".md" )){
				var argDescriptionFile = argsDir & argsFiles[arg.name & ".md"]; // avoid file system case problems
				arg.descriptionOriginal = arg.description;
				arg.description = FileReadAsUnix( argDescriptionFile );
			}
		}

		var examplesFile = GetDirectoryFromPath( arguments.pageFilePath ) & "_examples.md";
		if ( FileExists( examplesFile ) ) {
			func.examples = FileReadAsUnix( examplesFile );
		}

		return func;
	}

	private struct function _getObjectSpecification( required string objectName, required string pageFilePath ) {
		var obj    = _getObjectReferenceReader().getObject( arguments.objectName );
		var args    = obj.arguments ?: [];
		return obj;
		var argsDir = GetDirectoryFromPath( arguments.pageFilePath ) & "_arguments/";
		var argsFiles = getFilesInDirectory(argsDir);

		for( var arg in args ) {
			if (structKeyExists(argsFiles, arg.name & ".md" )){
				var argDescriptionFile = argsDir & argsFiles[arg.name & ".md"]; // avoid file system case problems
				arg.descriptionOriginal = arg.description;
				arg.description = FileReadAsUnix( argDescriptionFile );
			}
		}

		var examplesFile = GetDirectoryFromPath( arguments.pageFilePath ) & "_examples.md";
		if ( FileExists( examplesFile ) ) {
			obj.examples = FileReadAsUnix( examplesFile );
		}

		return obj;
	}

	private struct function _getMethodSpecification(required string methodObject, required string methodName, required string pageFilePath ) {
		var meth    = _getMethodReferenceReader().getMethod( arguments.methodObject, arguments.methodName );
		var args    = meth.arguments ?: [];
		var argsDir = GetDirectoryFromPath( arguments.pageFilePath ) & "_arguments/";
		var argsFiles = getFilesInDirectory(argsDir);

		for( var arg in args ) {
			var argDescriptionFile = argsDir & arg.name & ".md";
			if (structKeyExists(argsFiles, arg.name & ".md" )){
				var argDescriptionFile = argsDir & argsFiles[arg.name & ".md"]; // avoid file system case problems
				arg.descriptionOriginal = arg.description;
				arg.description = FileReadAsUnix( argDescriptionFile );
			}
		}
		var examplesFile = GetDirectoryFromPath( arguments.pageFilePath ) & "_examples.md";
		if ( FileExists( examplesFile ) ) {
			meth.examples = FileReadAsUnix( examplesFile );
		}

		return meth;
	}

	private any function _getFunctionReferenceReader() {
		return new api.reference.ReferenceReaderFactory().getFunctionReferenceReader();
	}

	private any function _getObjectReferenceReader() {
		return new api.reference.ReferenceReaderFactory().getObjectReferenceReader();
	}

	private any function _getMethodReferenceReader() {
		return new api.reference.ReferenceReaderFactory().getMethodReferenceReader();
	}

	private any function _getTagReferenceReader() {
		//var buildProperties = new api.build.BuildProperties();
		return new api.reference.ReferenceReaderFactory().getTagReferenceReader();
	}

}
