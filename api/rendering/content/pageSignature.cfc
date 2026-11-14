component {

	// Renders just the signature for a function or tag page in a code block.
	// Triggered by [[function-abs::signature]] / [[tag-http::signature]] etc.
	function render( required any docTree, required string pageId, boolean markdown=false ) {
		var page = arguments.docTree.getPage( arguments.pageId );
		if ( isNull( page ) ) {
			return "<em>unknown page: " & htmlEditFormat( arguments.pageId ) & "</em>";
		}

		var pageType = page.getPageType();
		if ( pageType neq "function" && pageType neq "tag" ) {
			return "<em>::signature only supported for function and tag pages (" & htmlEditFormat( arguments.pageId ) & ")</em>";
		}

		var signature = page.getUsageSignature( plainText=true );
		var url       = page.getPath() & ".html";

		// Emit raw HTML in both modes — markdown syntax has no native way to link a fenced code block,
		// and commonmark preserves inline HTML
		var out = "<a href='" & url & "' class='page-signature'><pre><code>"
			& htmlEditFormat( signature ) & "</code></pre></a>";

		if ( arguments.markdown ) {
			return chr( 10 ) & chr( 10 ) & out & chr( 10 ) & chr( 10 );
		}
		return out;
	}
}
