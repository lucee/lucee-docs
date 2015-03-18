component {
	this.name            = "luceeDocumentationBuilder-" & Hash( GetCurrentTemplatePath() );

	public boolean function onRequest( required string requestedTemplate ) output=true {
		include template=arguments.requestedTemplate;

		return true;
	}
}