component {
	this.name = "Lucee Docs Builder";

	this.mappings[ "/build" ] = ExpandPath( GetDirectoryFromPath( GetCurrentTemplatePath() ) );
	this.mappings[ "/data"  ] = ExpandPath( "/build/../data" );
}