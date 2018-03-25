component {

	public any function readPageFile( required string filePath ) {
		var fileDirectory   = GetDirectoryFromPath( arguments.filePath );
		var slug            = ListLast( fileDirectory, "\/" );
		var defaultPageType = ReReplace( arguments.filePath, "^.*?/([a-z]+)\.md$", "\1" );
		var fileContent     = FileRead( arguments.filePath );
		var data            = _parsePage( fileContent );
		var sortOrder       = "";
		var docsBase        = ExpandPath( "/docs" );

		if ( ListLen( slug, "." ) > 1 && IsNumeric( ListFirst( slug, "." ) ) ) {
			sortOrder    = ListFirst( slug, "." );
			slug         = ListRest( slug, "." );
			data.visible = true;
		}

		data.visible    = data.visible  ?: false;
		data.pageType   = data.pageType ?: defaultPageType;
		data.slug       = data.slug     ?: slug;
		data.sortOrder  = Val( data.sortOrder ?: sortOrder );
		data.sourceFile = "/docs" & Replace( arguments.filePath, docsBase, "" );
		data.sourceDir  = "/docs" & Replace( fileDirectory     , docsBase, "" );
		data.related    = isArray( data.related ?: "" ) ? data.related : ( Len( Trim( data.related ?: "" ) ) ? [ data.related ] : [ "" ] );

		return data;
	}

	private struct function _parsePage( required string pageContent ) {
		var yamlAndBody = _splitYamlAndBody( arguments.pageContent );
		var parsed      = { body = yamlAndBody.body }

		if ( yamlAndBody.yaml.len() ) {
			parsed.append( _parseYaml( yamlAndBody.yaml ), false );
		}

		return parsed;
	}

	private struct function _splitYamlAndBody( required string pageContent ) {
		if(_isWindows())
			var splitterRegex = "^(\-\-\-\r\n(.*?)\r\n\-\-\-\r\n)?(.*)$";
		else
			var splitterRegex = "^(\-\-\-\n(.*?)\n\-\-\-\n)?(.*)$";

		return {
			  yaml = Trim( ReReplace( arguments.pageContent, splitterRegex, "\2" ) )
			, body = Trim( ReReplace( arguments.pageContent, splitterRegex, "\3" ) )
		}
	}

	private struct function _parseYaml( required string yaml ) {
		return new api.parsers.ParserFactory().getYamlParser().yamlToCfml( arguments.yaml );
	}

	private boolean function _isWindows(){
		return findNoCase("Windows", SERVER.os.name);
	}

}