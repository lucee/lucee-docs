component {

	public any function readPageFile( required string filePath ) {
		var fileDirectory   = GetDirectoryFromPath( arguments.filePath );
		var slug            = ListLast( fileDirectory, "\/" );
		var defaultPageType = ReReplace( arguments.filePath, "^.*?/([a-z]+)\.md$", "\1" );
		var fileContent     = FileRead( arguments.filePath );
		var data            = _parsePage( fileContent );
		var sortOrder       = "";

		if ( ListLen( slug, "." ) > 1 && IsNumeric( ListFirst( slug, "." ) ) ) {
			sortOrder = ListFirst( slug, "." );
			slug      = ListRest( slug, "." );
		} else {
			data.visible = data.visible ?: false;
		}

		data.pageType  = data.pageType  ?: defaultPageType;
		data.slug      = data.slug      ?: slug;
		data.sortOrder = data.sortOrder ?: sortOrder;

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
		var splitterRegex = "^(\-\-\-\n(.*?)\n\-\-\-\n)?(.*)$";

		return {
			  yaml = Trim( ReReplace( arguments.pageContent, splitterRegex, "\2" ) )
			, body = Trim( ReReplace( arguments.pageContent, splitterRegex, "\3" ) )
		}
	}

	private struct function _parseYaml( required string yaml ) {
		var javaLib = [ "../lib/snakeyaml-1.15.jar" ];
		var parser  = CreateObject( "java", "org.yaml.snakeyaml.Yaml", javaLib ).init();

		// todo, catch errors here and report them well
		return parser.load( yaml )
	}

}