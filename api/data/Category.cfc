component accessors=true {
	public any function init () {
		return this;
	}
	public struct function buildCategories( required struct idMap) {
		var pageCategories = {};
		var categories = {};
		var emptyCategories = {};
		// extract all assigned categories from content pages
		for ( var id in arguments.idMap ) {
			var cats = arguments.idMap[ id ].getCategories();
			if ( !IsNull( cats ) ){
				for ( var cat in cats ){
					if ( !structKeyExists( pageCategories, cat ) )
						pageCategories[ cat ] = [];
					arrayAppend( pageCategories[cat], arguments.idMap[ id ].getPath() );
				}
			}
		}
		// extract content from category pages
		for ( var id in arguments.idMap ) {
			if ( arguments.idMap[ id ].getPageType() eq "category" ){
				var slug = arguments.idMap[ id ].getSlug();
				if ( !structKeyExists( pageCategories, slug ) ){
					emptyCategories[ slug ] = idMap[ id ].getPath();
					pageCategories[ slug ] = [arguments.idMap[ id ].getPath()];
				} else {
					categories[ slug ] = [];
				}
			}
		}
		if ( false ){
			var missing = {};
			for ( var cat in pageCategories ){
				if ( !structKeyExists( categories, cat )){
					missing[cat] = pageCategories[ cat ];
				}
			}

			if ( structCount( emptyCategories ) gt 0 ){
				var mess= "<b>The following categories have no content assigned:</b><br>" & structKeyList( emptyCategories, ", " );
				writeOutput( mess );
				dump( emptyCategories );
			}

			if ( structCount( missing ) gt 0 ){
				var mess= "<b>The following categories referenced by pages, but don't exist:</b> <br> " & structKeyList( missing, ", " );
				writeOutput( mess );

				dump(missing);
			}

			if ( structCount(emptyCategories) gt 0 or structCount(missing) gt 0 ){
				var mess= "<b>All Categories with their assigned content:</b>";
				writeOutput( mess );
				dump( pageCategories )
				abort;
			}
		}		
		return pageCategories;
	}
}