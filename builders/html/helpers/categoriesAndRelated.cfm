<cfscript>
function renderCategoriesAndRelated( required any page, required any docTree, boolean markdown=false ) {
	var categories = [];
	var related = [];
	var output = "";

	if ( !IsNull( arguments.page.getCategories() ) ) {
		for ( var cat in arguments.page.getCategories() ) {
			var catId = "category-" & cat;
			if ( arguments.docTree.pageExists( catId ) ) {
				arrayAppend( categories, "[[#catId#]]" );
			}
		}
	}

	var excludeMap = {};
	excludeMap[arguments.page.getId()] = "";
	for ( var child in arguments.page.getChildren() ) {
		excludeMap[child.getId()] = "";
	}

	var relatedIds = arguments.docTree.getPageRelated( arguments.page );
	for ( var relId in relatedIds ) {
		if ( len( relId ) gt 0 and not structKeyExists( excludeMap, relId ) ) {
			arrayAppend( related, "[[#relId#]]" );
		}
	}

	if ( arrayLen( categories ) ) {
		output &= chr( 10 ) & "## Categories" & chr( 10 ) & chr( 10 );
		output &= arrayToList( categories, ", " ) & chr( 10 );
	}

	if ( arrayLen( related ) ) {
		output &= chr( 10 ) & "## See Also" & chr( 10 ) & chr( 10 );
		output &= arrayToList( related, ", " ) & chr( 10 );
	}

	return output;
}
</cfscript>
