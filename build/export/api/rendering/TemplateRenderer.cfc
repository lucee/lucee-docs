component {

	public string function render( required string template, struct args={} ) {
		var rendered = "";

		savecontent variable="rendered" {
			include template=arguments.template;
		}

		return Trim( rendered );
	}

	public string function markdownToHtml( required string markdown ) {
		var processor = CreateObject( "java", "com.petebevin.markdown.MarkdownProcessor", [ "../lib/markdownj-1.0.2b4-0.3.0.jar" ] ).init();

		return processor.markdown( arguments.markdown );
	}
}