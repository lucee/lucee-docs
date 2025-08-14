
component {	
	function render(required any docTree, required string contentType, required struct recipeDates) {
		var gitReader = new api.parsers.git.gitReader();
		var q = gitReader.convertToQuery(arguments.recipeDates);
		querySort(q, "created", "desc");

		// wiki links still get expanded, but we are rendering html here

		var content = ["<ul>"];
		for (var i =1; i < q.recordcount + 1; i++){
			var page = docTree.getPageByPath("/recipes/" & listFirst ( q.name[ i ] , "." ) );
			if ( !isNull( page ) ){
				arrayAppend( content, "<li>[[#page.getId()#]] " & DateFormat( q.created[i] ) & "</li>" );
				if (i gt 20) break;
			}
		}
		arrayAppend(content, "</ul>");
		var html = ArrayToList( content, chr(10) );
		return html;
	}
}