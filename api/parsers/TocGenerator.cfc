component {

	public any function init() {
		return this;
	}

	public array function generateToc( required string content ){
		var htmlParser   = new api.parsers.HtmlParser();
		var doc          = htmlParser.parseHtml( arguments.content );
		var titles       = htmlParser.select( doc, "h1, h2, h3, h4" );
		var toc          = [];
		var currentLevel = 1000000;
		var level        = 0;
		var node         = {};
		var parentNode   = {};
		var currentIndex = [];
		var newIndex     = [];
		var i            = 0;

		for( var title in titles ) {
			level = Val( htmlParser.getNodeName( title ).reReplace( "^[hH]", "" ) );
			node  = {
				  title    = htmlParser.getText( title )
				, slug     = LCase( htmlParser.getText( title ) ).replace( "\.", "", "all" ).reReplace( "\W", "-", "all" ).reReplace( "-+", "-", "all" ).reReplace( "-$", "", "all" )
				, children = []
				, level    = level
			};

			if ( level > currentLevel ) {
				parentNode = _getNode( toc, currentIndex );
				parentNode.children.append( node );
				currentIndex.append( parentNode.children.len() );

			} else if ( level < currentLevel ) {
				do {
					if ( currentIndex.len() ) {
						currentIndex.deleteAt( currentIndex.len() );
						if ( currentIndex.len() ) {
							parentNode = _getNode( toc, currentIndex );
						}
					}
				} while( currentIndex.len() && parentNode.level >= level );

				if ( currentIndex.len() ) {
					parentNode.children.append( node );
					currentIndex.append( parentNode.children.len() );

				} else {
					toc.append( node );
					currentIndex = [ toc.len() ];
				}
			} else {
				currentIndex.deleteAt( currentIndex.len() );

				if ( currentIndex.len() ) {
					parentNode = _getNode( toc, currentIndex );
					parentNode.children.append( node );
					currentIndex.append( parentNode.children.len() );
				} else {
					toc.append( node );
					currentIndex = [ toc.len() ];
				}
			}

			currentLevel = level;
		}

		// Smart filtering: if TOC is too large, limit depth
		return _filterLargeToc( toc );
	}

	private array function _filterLargeToc( required array toc ) {
		// Count total items in TOC
		var totalItems = _countTocItems( arguments.toc );

		// If TOC has more than 50 items, only show top-level and first level children (h1, h2)
		if ( totalItems > 50 ) {
			systemOutput( "TOC has #totalItems# items, limiting to depth 2", true );
			var filtered = _limitTocDepth( arguments.toc, 2 );
			systemOutput( "Filtered TOC has #_countTocItems(filtered)# items", true );
			return filtered;
		}

		return arguments.toc;
	}

	private numeric function _countTocItems( required array toc ) {
		var count = 0;
		for ( var item in arguments.toc ) {
			count++;
			if ( arrayLen( item.children ) ) {
				count += _countTocItems( item.children );
			}
		}
		return count;
	}

	private array function _limitTocDepth( required array toc, required numeric maxDepth, numeric currentDepth=1 ) {
		var filtered = [];

		for ( var item in arguments.toc ) {
			var newItem = {
				title: item.title,
				slug: item.slug,
				level: item.level,
				children: []
			};

			// Include children only if we haven't reached max depth
			if ( arguments.currentDepth < arguments.maxDepth && arrayLen( item.children ) ) {
				newItem.children = _limitTocDepth( item.children, arguments.maxDepth, arguments.currentDepth + 1 );
			}

			arrayAppend( filtered, newItem );
		}

		return filtered;
	}

// helpers
	private any function _getNode( required array tree, required array index ) {
		var isFirst = true;
		var node    = "";
		var i       = "";

		for( i in arguments.index ) {
			try {

				node = isFirst ? arguments.tree[i] : node.children[i];
			} catch( any e ) {
				WriteDump( i);
				WriteDump( isFirst);
				WriteDump(node);
				WriteDump( arguments.tree); abort;
			}
			isFirst = false;
		}

		return node;
	}
}