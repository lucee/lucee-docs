component {
	this.name = "luceeDocumentationLocalServer-" & Hash( GetCurrentTemplatePath() );

	this.cwd     = GetDirectoryFromPath( GetCurrentTemplatePath() )
	this.baseDir = ExpandPath( this.cwd & "../" );

	this.mappings[ "/api"      ] = this.baseDir & "api";
	this.mappings[ "/builders" ] = this.baseDir & "builders";
	this.mappings[ "/docs"     ] = this.baseDir & "docs";

	public boolean function onRequest( required string requestedTemplate ) output=true {
		include template=arguments.requestedTemplate;

		return true;
	}
}