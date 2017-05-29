<cfscript>
	string function getSourceLink( required string path ) {
		var sourceBase = new api.build.BuildProperties().getEditSourceLink();

		return Replace( sourceBase, "{path}", fixPathCase( arguments.path ) );
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