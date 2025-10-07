
component {
	function render(required any docTree, required string contentType, required struct recipeDates, boolean markdown=false) {
		var gitReader = new api.parsers.git.gitReader();
		var q = gitReader.convertToQuery(arguments.recipeDates);
		querySort(q, "created", "desc");

		if ( arguments.markdown ) {
			// render as markdown list
			var content = [ "" ];
			for (var i =1; i < q.recordcount + 1; i++){
				var page = docTree.getPageByPath("/recipes/" & listFirst ( q.name[ i ] , "." ) );
				if ( !isNull( page ) ){
					arrayAppend( content, "- [[#page.getId()#]] " & DateFormat( q.created[i] ) );
					if (i gt 20) break;
				}
			}
			return ArrayToList( content, chr(10) );
		} else {
			// render as HTML (for content inserted after markdown processing)
			var content = [ "<ul>" ];
			for (var i =1; i < q.recordcount + 1; i++){
				var page = docTree.getPageByPath("/recipes/" & listFirst ( q.name[ i ] , "." ) );
				if ( !isNull( page ) ){
					arrayAppend( content, "<li>[[#page.getId()#]] " & DateFormat( q.created[i] ) & "</li>" );
					if (i gt 20) break;
				}
			}
			arrayAppend( content, "</ul>" );
			return ArrayToList( content, chr(10) );
		}
	}
}