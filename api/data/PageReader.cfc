component {

	public any function readPageFile( required string filePath ) {
		var path            = Replace(arguments.filePath,"\","/","all");
		var fileDirectory   = GetDirectoryFromPath( path );
		var slug            = ListLast( fileDirectory, "\/" );
		var defaultPageType = ReReplace(path, "^.*?/([a-z]+)\.md$", "\1" );
		var fileContent     = REReplace(FileRead( path ), "\r\n","\n","all"); // convert all line endings to unix style
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
			data.visible = true;
		}

		data.visible    = data.visible  ?: false;
		data.pageType   = data.pageType ?: defaultPageType; // TODO this is sometimes still the .md file path
		data.slug       = data.slug     ?: slug;
		data.sortOrder  = Val( data.sortOrder ?: sortOrder );
		data.sourceFile = "/docs" & Replace( path, docsBase, "" );
		data.sourceDir  = "/docs" & Replace( fileDirectory     , docsBase, "" );
		data.related    = isArray( data.related ?: "" ) ? data.related : ( Len( Trim( data.related ?: "" ) ) ? [ data.related ] : [ "" ] );

		new api.parsers.ParserFactory().getMarkdownParser().validateMarkdown( data );

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

	private struct function _parseYaml( required string yaml ) {
		return new api.parsers.ParserFactory().getYamlParser().yamlToCfml( arguments.yaml );
	}

	private boolean function _isWindows(){
		return findNoCase("Windows", SERVER.os.name);
	}

}