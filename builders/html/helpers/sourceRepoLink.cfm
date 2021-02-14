<cfscript>

	string function getEditLink( required string path, required boolean edit ) {
		if (arguments.edit)
			return '<button class="btn btn-flat pull-right local-edit-link" data-src="#arguments.path#" title="Edit"><i class="fa fa-pencil fa-fw"></i></button>';
		else
			return '<a class="pull-right edit-link" href="#getSourceLink(arguments.path)#" title="Improve the docs"><i class="fa fa-github fa-fw"></i></a>';
	}

	string function getSourceLink( required string path ) {
		var sourceBase = new api.build.BuildProperties().getEditSourceLink();

		return Replace( sourceBase, "{path}", fixPathCase( arguments.path ) );
	}

	string function showOriginalDescription( required struct props, required boolean edit, required any markdownToHtml ) {
		if (arguments.edit
			and structKeyExists(arguments.props, "descriptionOriginal")
			and arguments.props.descriptionOriginal neq arguments.props.description){
				return "<b>Modifed in Lucee Docs, Source Lucee definition:</b>" & arguments.markdownToHtml(arguments.props.descriptionOriginal);
		}
		return "";
	}

	string function fixPathCase( required string path ) {
		var dir = getDirectoryFromPath( arguments.path );
		var files = directoryList( dir, false, 'name' );

		for( var filename in files ) {
			if ( filename == arguments.path.listLast( "/\" ) ) {
				return dir & filename;
			}
		}

		return arguments.path;
	}
</cfscript>