component {

	public struct function generateIndexFromDocTree( required any docTree ) {
		var index = [];
		var pages = arguments.docTree.getIdMap();
		var recipeDates = arguments.docTree.getRecipeDates();
		var mostRecentDate = NullValue();

		// Find all recipe pages
		cfloop( collection=pages, item="local.page", index="local.pageId" ) {
			var path = local.page.getPath();

			// Only process pages under /recipes/
			if ( path.startsWith( "/recipes/" ) && path != "/recipes" ) {
				var fileName = listLast( path, "/" ) & ".md";
				var keywords = [];
				var categories = [];
				var recipeHash = "";
				var lastModified = NullValue();

				// Extract keywords from page metadata
				if ( !isNull( local.page.getKeywords() ) ) {
					keywords = local.page.getKeywords();
				}

				// Extract categories
				if ( !isNull( local.page.getCategories() ) ) {
					categories = local.page.getCategories();
				}

				// Use git commit date for hash if available, otherwise fallback to content hash
				if ( structKeyExists( recipeDates, fileName ) && arrayLen( recipeDates[ fileName ].commits ) ) {
					// Use most recent commit date (first in array)
					lastModified = arrayFirst( recipeDates[ fileName ].commits );
					recipeHash = hash( lastModified.getTime(), "MD5" );

					// Track the most recent date across all recipes
					if ( isNull( mostRecentDate ) || lastModified > mostRecentDate ) {
						mostRecentDate = lastModified;
					}
				} else {
					// Fallback to content-based hash
					recipeHash = hash( local.page.getTitle() & local.page.getDescription(), "MD5" );
				}

				var entry = [:];
				entry[ "file" ] = fileName;
				entry[ "title" ] = local.page.getTitle();
				entry[ "path" ] = "/recipes/#fileName#";
				entry[ "hash" ] = recipeHash;
				entry[ "keywords" ] = keywords;
				// entry[ "categories" ] = categories;

				// Add lastModified date if available
				if ( !isNull( lastModified ) ) {
					entry[ "lastModified" ] = GetHttpTimeString( lastModified );
				}

				index.append( entry );
			}
		}

		var result = [:];
		result[ "content" ] = serializeJSON( var=index, compact=false );

		// Add lastModified to result if we found any dates
		if ( !isNull( mostRecentDate ) ) {
			result[ "lastModified" ] = GetHttpTimeString( mostRecentDate );
		}

		return result;
	}

	public string function generateIndex( required string recipesDir ) {
		var files = directoryList(
			path = arguments.recipesDir,
			filter = "*.md",
			type = "file"
		);
		var index = [];

		cfloop( array=files, item="local.filePath" ) {
			var fileName = listLast( local.filePath, "/\" );

			// Skip README.md
			if ( fileName == "README.md" ) {
				continue;
			}

			var content = fileRead( filePath );
			var title = _extractTitle( content );
			var hash = hash( content, "MD5" );
			var metadata = _extractMetadata( content );

			index.append( {
				file = fileName,
				title = title,
				path = "/docs/recipes/#fileName#",
				hash = hash,
				keywords = metadata.keywords ?: []
			} );
		}

		return serializeJSON( index );
	}

	private string function _extractTitle( required string content ) {
		var titleMatch = reFind( "(?m)^##\s+(.+)$", arguments.content, 1, true );

		if ( titleMatch.pos[1] > 0 && arrayLen( titleMatch.pos ) > 1 ) {
			return mid( arguments.content, titleMatch.pos[2], titleMatch.len[2] );
		}

		return "Untitled";
	}

	private struct function _extractMetadata( required string content ) {
		var result = {
			keywords = []
		};

		var metadataMatch = reFind( "<!--\s*(\{[^]*?\})\s*-->", arguments.content, 1, true );

		if ( metadataMatch.pos[1] > 0 && arrayLen( metadataMatch.pos ) > 1 ) {
			try {
				var jsonStr = mid( arguments.content, metadataMatch.pos[2], metadataMatch.len[2] );
				var metadata = deserializeJSON( jsonStr );

				if ( structKeyExists( metadata, "keywords" ) && isArray( metadata.keywords ) ) {
					result.keywords = metadata.keywords;
				}
			} catch ( any e ) {
				// Invalid JSON in metadata comment, just return empty keywords
			}
		}

		return result;
	}

}
