component {

	public any function readPageFile( required string filePath ) {
		var path            = Replace(arguments.filePath,"\","/","all");
		var fileDirectory   = GetDirectoryFromPath( path );
		var slug            = ListLast( fileDirectory, "\/" );
		var defaultPageType = "";
		var pagePath = ListToArray(path, "/\");
		if ( left(pagePath[pagePath.len()-1], 1) eq "_"){
			defaultPageType = pagePath[pagePath.len()-1];  // xml\xmlelemnew\_arguments\xmlObj.md
		} else {
			defaultPageType = ListFirst(ListLast(path, "/"),"."); //ee\01.using-lucee-in-java\page.md
		}
		
		var fileContent     = _convertToUnixLineEnding( FileRead( path ) ); 
		var data            = _parsePage( fileContent );
		var sortOrder       = "";

		if (_isWindows())
			var docsBase        = Replace(ExpandPath( "../docs" ),"\","/","all");
		else
			var docsBase        = ExpandPath("/docs");
      
		// if the last directory is in the format 00.home, flag is as visible
		if ( ListLen( slug, "." ) > 1 && IsNumeric( ListFirst( slug, "." ) ) ) {
			sortOrder    = ListFirst( slug, "." );
			slug         = ListRest( slug, "." );
			if (not structKeyExists(data, "visible"))
				data.visible = true;
		}		
	
		data.visible    = data.visible  ?: false;
		data.pageType   = data.pageType ?: defaultPageType; // TODO this is sometimes still the .md file path
		data.slug       = data.slug     ?: slug;
		data.sortOrder  = Val( data.sortOrder ?: sortOrder );
		data.sourceFile = "/docs" & Replace( path, docsBase, "" );
		data.sourceDir  = "/docs" & Replace( fileDirectory     , docsBase, "" );
		data.related    = isArray( data.related ?: "" ) ? data.related : ( Len( Trim( data.related ?: "" ) ) ? [ data.related ] : [ ] );

		//_extractMarkdownLinks(data.related, data.body);
		//new api.parsers.ParserFactory().getMarkdownParser().validateMarkdown( data );

		return data;
	}

	public any function savePageFile(required string pagePath, required string content,
			required struct props){
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
		var fileContent     = _convertToUnixLineEnding(FileRead( path )); 
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
}