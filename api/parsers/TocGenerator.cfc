component {

	public any function init() {
		return this;
	}

	public array function generateToc( required string content ){
		var jsoup        = createObject("java", "org.jsoup.Jsoup", [ ExpandPath( "/api/lib/jsoup/jsoup-1.10.1.jar" ) ] );
		var doc          = jsoup.parse( arguments.content );
		var titles       = doc.select( "h1, h2, h3, h4" );
		var toc          = [];
		var currentLevel = 1000000;
		var level        = 0;
		var node         = {};
		var parentNode   = {};
		var currentIndex = [];
		var newIndex     = [];
		var i            = 0;

		for( var title in titles ) {
			level = Val( title.nodeName().reReplace( "^[hH]", "" ) );
			node  = {
				  title    = title.text()
				, slug     = LCase( title.text() ).replace( "\.", "", "all" ).reReplace( "\W", "-", "all" ).reReplace( "-+", "-", "all" ).reReplace( "-$", "", "all" )
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

		return toc;
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