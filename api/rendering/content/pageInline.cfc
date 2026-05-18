component {

	// Renders a compact inline block for a function or tag page: linked title, description and signature.
	// Triggered by [[function-abs::inline]] / [[tag-http::inline]] etc.
	function render( required any docTree, required string pageId, boolean markdown=false ) {
		var page = arguments.docTree.getPage( arguments.pageId );
		if ( isNull( page ) ) {
			return "<em>unknown page: " & htmlEditFormat( arguments.pageId ) & "</em>";
		}

		var url         = page.getPath() & ".html";
		var title       = page.getTitle();
		var description = _shortDescription( page );
		var signature   = _signature( page );

		if ( arguments.markdown ) {
			var lines = [];
			arrayAppend( lines, "**[" & title & "](" & url & ")**" );
			if ( len( description ) ) {
				arrayAppend( lines, description );
			}
			if ( len( signature ) ) {
				arrayAppend( lines, "```" );
				arrayAppend( lines, signature );
				arrayAppend( lines, "```" );
			}
			return chr( 10 ) & arrayToList( lines, chr( 10 ) ) & chr( 10 );
		}

		var out = [ "<div class='inline-page-ref'>" ];
		arrayAppend( out, "<p><a href='" & url & "'><strong>" & htmlEditFormat( title ) & "</strong></a></p>" );
		if ( len( description ) ) {
			arrayAppend( out, "<p>" & htmlEditFormat( description ) & "</p>" );
		}
		if ( len( signature ) ) {
			arrayAppend( out, "<pre><code>" & htmlEditFormat( signature ) & "</code></pre>" );
		}
		arrayAppend( out, "</div>" );
		return arrayToList( out, chr( 10 ) );
	}

// PRIVATE
	private string function _shortDescription( required any page ) {
		var d = arguments.page.getDescription() ?: "";
		if ( !len( trim( d ) ) ) {
			d = arguments.page.getExtractedDescription() ?: "";
		}
		return trim( d );
	}

	private string function _signature( required any page ) {
		var pageType = arguments.page.getPageType();
		if ( pageType neq "function" && pageType neq "tag" ) return "";
		return arguments.page.getUsageSignature( plainText=true );
	}
}
