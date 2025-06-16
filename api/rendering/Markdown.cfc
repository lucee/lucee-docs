component
	javaSettings='{
		"maven": [
			"org.commonmark:commonmark:0.24.0"
			, "org.commonmark:commonmark-ext-gfm-strikethrough:0.24.0"
			, "org.commonmark:commonmark-ext-gfm-tables:0.24.0"
			, "org.commonmark:commonmark-ext-ins:0.24.0"
			, "org.commonmark:commonmark-ext-autolink:0.24.0"
			, "org.commonmark:commonmark-ext-image-attributes:0.24.0"
		]
	}'
{

	import org.commonmark.node.Node;
	import org.commonmark.parser.Parser;
	import org.commonmark.renderer.html.HtmlRenderer;
	import org.commonmark.Extension;
	import org.commonmark.ext.autolink.AutolinkExtension;
	import org.commonmark.ext.gfm.strikethrough.StrikethroughExtension;
	import org.commonmark.ext.gfm.tables.TablesExtension;
	import org.commonmark.ext.image.attributes.ImageAttributesExtension;
	import org.commonmark.ext.ins.InsExtension;


	function render( string markdown, boolean safemode=false ){
		var extensions = [
			AutolinkExtension::create(),
			ImageAttributesExtension::create(),
			InsExtension::create(),
			StrikethroughExtension::create(),
			TablesExtension::create()
		];
		var parser = Parser::builder().extensions(extensions).build();
		// Parse the markdown to a Node
		var  document = parser.parse( arguments.markdown); 
		// Create a HTML renderer
		var renderer = HtmlRenderer::builder().extensions(extensions).escapeHtml( arguments.safeMode ).build();
		// Render the Node to HTML
		return renderer.render(document);
	}

}
