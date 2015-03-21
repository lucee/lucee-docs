component accessors=true {

	property name="tree"    type="array";
	property name="idMap"   type="struct";
	property name="slugMap" type="struct";

	public any function init( required string rootDirectory ) {
		_loadTree( arguments.rootDirectory );

		return this;
	}

	public any function getPage( required string id ) {
		return idMap[ arguments.id ] ?: NullValue();
	}

	public any function getPageBySlug( required string slug ) {
		return slugMap[ arguments.slug ] ?: NullValue();
	}

// private helpers
	private void function _loadTree( required string rootDirectory ) {
		_initializeEmptyTree();

		var pageFiles = _readPageFilesFromDocsDirectory( arguments.rootDirectory );
		for( var pageFile in pageFiles ) {
			page = _preparePageObject( pageFile, arguments.rootDirectory );

			_addPageToTree( page );
		}

		_sortChildren( tree );
	}

	private void function _initializeEmptyTree() {
		setTree( [] );
		setIdMap( {} );
		setSlugMap( {} );
	}

	private void function _addPageToTree( required any page ) {
		idMap[ arguments.page.getId() ] = arguments.page;
		slugMap[ arguments.page.getSlug() ] = arguments.page;

		if ( idMap.keyExists( arguments.page.getParentId() ) ) {
			idMap[ arguments.page.getParentId() ].addChild( arguments.page );
			arguments.page.setParent( idMap[ arguments.page.getParentId() ] )
		} else {
			tree.append( arguments.page );
		}
	}

	private array function _readPageFilesFromDocsDirectory( required string rootDirectory ) {
		var pageFiles = DirectoryList( arguments.rootDirectory, true, "path", "*.md" );

		pageFiles = pageFiles.map( function( path ){
			return path.replace( rootDirectory, "" );
		} );

		_sortPageFilesByDepth( pageFiles );

		return pageFiles;
	}

	private void function _sortPageFilesByDepth( required array pageFiles ) {
		arguments.pageFiles.sort( function( page1, page2 ){
			var depth1 = page1.listLen( "\/" );
			var depth2 = page2.listLen( "\/" );

			if ( depth1 == depth2 ) {
				return page1 > page2 ? 1 : -1;
			}

			return depth1 > depth2 ? 1 : -1;
		} );
	}

	private any function _preparePageObject( required string pageFilePath, required string rootDirectory ) {
		var page = "";
		var pageData = new PageReader().readPageFile( arguments.rootDirectory & pageFilePath )

		switch( pageData.pageType ?: "" ) {
			case "function":
				pageData.append( _readFunctionOrTagSpecificationData( arguments.rootDirectory & pageFilePath ), false );
				page = new FunctionPage( argumentCollection=pageData );
			break;
			case "tag":
				pageData.append( _readFunctionOrTagSpecificationData( arguments.rootDirectory & pageFilePath ), false );
				page = new TagPage( argumentCollection=pageData );
			break;
			default:
				page = new Page( argumentCollection=pageData );
		}

		page.setId( _getPageIdFromMdFilePath( arguments.pageFilePath ) );
		page.setParentId( _getParentPageIdFromPageId( page.getId() ) );
		page.setChildren( [] );
		page.setDepth( ListLen( page.getId(), "/" ) );

		return page;
	}

	private string function _getPageIdFromMdFilePath( required string filePath ) {
		var withoutExtension = ReReplace( arguments.filePath, "[^\\\/]+\.md$", "" );
		var parts            = withoutExtension.listToArray( "\/" );

		for( var i=1; i <= parts.len(); i++ ) {
			if ( parts[ i ].listLen( "." ) > 1 ) {
				parts[ i ] = parts[ i ].listRest( "." );
			}
		}

		return "/" & parts.toList( "/" );
	}

	private string function _getParentPageIdFromPageId( required string pageId ) {
		var parts = arguments.pageId.listToArray( "/" );
		parts.deleteAt( parts.len() );

		return "/" & parts.toList( "/" );
	}

	private void function _sortChildren( required array children ){
		children.sort( function( childA, childB ) {
			if ( childA.getSortOrder() == childB.getSortOrder() ) {
				return childA.getTitle() > childB.getTitle() ? 1 : -1;
			}
			return childA.getSortOrder() > childB.getSortOrder() ? 1 : -1;
		} );


		for( var child in children ) {
			_sortChildren( child.getChildren() );
		}
	}

	private struct function _readFunctionOrTagSpecificationData( required string pageFilePath ) {
		var specFile = GetDirectoryFromPath( pageFilePath ) & "specification.json";

		if ( FileExists( specFile ) ) {
			return new JsonDataFileReader().readDataFile( specFile );
		}
	}
}