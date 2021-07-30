component {
	this.name = "luceeDocumentationBuilder-" & Hash( GetCurrentTemplatePath() );

	variables.assetBundleVersion = 33; // must match lucee-docs\builders\html\assets\Gruntfile.js _version

	this.cwd = GetDirectoryFromPath( GetCurrentTemplatePath() )

	this.mappings[ "/api"      ] = this.cwd & "api";
	this.mappings[ "/builders" ] = this.cwd & "builders";
	this.mappings[ "/docs"     ] = this.cwd & "docs";
	this.mappings[ "/import"   ] = this.cwd & "import";
	this.mappings[ "/builds"   ] = this.cwd & "builds";

	public boolean function onRequest( required string requestedTemplate ) output=true {
		var logger = new api.build.Logger();

		application.assetBundleVersion = variables.assetBundleVersion;

		include template=arguments.requestedTemplate;

		return true;
	}
}
