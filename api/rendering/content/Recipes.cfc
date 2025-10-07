
component {	
	function render(required any docTree, required string contentType, required struct recipeDates) {
		var gitReader = new api.parsers.git.gitReader();
		var q = gitReader.convertToQuery(arguments.recipeDates);
		querySort(q, "created", "desc");

		// render as markdown list, will get converted to html during build

		var content = [];
		for (var i =1; i < q.recordcount + 1; i++){
			var page = docTree.getPageByPath("/recipes/" & listFirst ( q.name[ i ] , "." ) );
			if ( !isNull( page ) ){
				arrayAppend( content, "- [[#page.getId()#]] " & DateFormat( q.created[i] ) );
				if (i gt 20) break;
			}
		}
		var markdown = ArrayToList( content, chr(10) );
		return markdown;
	}
}