component {
	public any function init() {
		_setupMarkdownProcessor();

		return this;
	}

	public string function markdownToHtml( required string markdown ) {
		return _getMarkdownProcessor().markdownToHtml( arguments.markdown );
	}

// PRIVATE
	private void function _setupMarkdownProcessor() {
		var javaLib   = [ "../lib/parboiled-core-1.1.7.jar", "../lib/parboiled-java-1.1.7.jar",  "../lib/pegdown-1.5.0.jar" ];
		var processor = CreateObject( "java", "org.pegdown.PegDownProcessor", javaLib ).init();

		_setMarkdownProcessor( processor );
	}

	private any function _getMarkdownProcessor() output=false {
		return _markdownProcessor;
	}
	private void function _setMarkdownProcessor( required any markdownProcessor ) output=false {
		_markdownProcessor = arguments.markdownProcessor;
	}
}