component accessors=true {

	property name="tree"    type="array";
	property name="idMap"   type="struct";
	property name="pathMap" type="struct";

	public any function init( required string rootDirectory ) {
		_loadTree( arguments.rootDirectory );

		return this;
	}

	public any function getPage( required string id ) {
		return idMap[ arguments.id ] ?: NullValue();
	}

	public any function getPageByPath( required string path ) {
		return pathMap[ arguments.path ] ?: NullValue();
	}

	public boolean function pageExists( required string id ) {
		return idMap.keyExists( arguments.id );
	}

	public array function getPagesByCategory( required string category ) {
		var matchedPages = [];

		for( var id in idMap ) {
			var pageCategories = idMap[ id ].getCategories();

			if ( !IsNull( pageCategories ) && pageCategories.indexOf( arguments.category ) != -1 ) {
				matchedPages.append( idMap[ id ] );
			}
		}

		return matchedPages;
	}

	public array function sortPagesByType( required array pages ) {
		return arguments.pages.sort( function( pageA, pageB ) {
			if ( pageA.getPageType() > pageB.getPageType() ) {
				return 1;
			}
			if ( pageA.getPageType() < pageB.getPageType() ) {
				return -1;
			}

			return pageA.getTitle() > pageB.getTitle() ? 1 : -1;
		} );
	}

// private helpers
	private void function _loadTree( required string rootDirectory ) {
		var start = getTickCount();
		cflog(text="Starting Lucee Documentation Build");

		_initializeEmptyTree();				
		
		var pageFiles = _readPageFilesFromDocsDirectory( arguments.rootDirectory );
		for( var pageFile in pageFiles ) {
			page = _preparePageObject( pageFile, arguments.rootDirectory );

			_addPageToTree( page );
		}
		_sortChildren( tree );
		cflog(text="Calculating Next and Previous Links");
		_calculateNextAndPreviousPageLinks( tree );

		//checkCategories();
		cflog(text="Documentation Built in #(getTickCount()-start)/1000#s");
	}

	private void function _initializeEmptyTree() {
		setTree( [] );
		setIdMap( {} );
		setPathMap( {} );
	}

	private void function _addPageToTree( required any page ) {
		var parent    = _getPageParent( arguments.page );
		var ancestors = [];
		var lineage   = [];

		if ( !IsNull( parent ) ) {
			parent.addChild( arguments.page );
			arguments.page.setParent( parent );

			ancestors = parent.getAncestors();
			if (ancestors.len() eq 0) // avoid duplicates
				ancestors.append( parent.getId() );
		} else {
			tree.append( arguments.page );
		}

		arguments.page.setAncestors( ancestors );
		lineage = Duplicate( ancestors );
		lineage.append( arguments.page.getId() );
		arguments.page.setLineage( lineage );

		idMap[ arguments.page.getId() ]     = arguments.page;
		pathMap[ arguments.page.getPath() ] = arguments.page;
	}

	private array function _readPageFilesFromDocsDirectory( required string rootDirectory ) {
		var pageFiles = DirectoryList( arguments.rootDirectory, true, "path", "*.md" );

		pageFiles = _removeRootDirectoryFromFilePaths( pageFiles, arguments.rootDirectory );
		pageFiles = _removeHiddenPages( pageFiles );
		pageFiles = _sortPageFilesByDepth( pageFiles );

		return pageFiles;
	}

	private array function _removeRootDirectoryFromFilePaths( required any pageFiles, required string rootDirectory ) {
		var args = arguments;

		return args.pageFiles.map( function( path ){
			return path.replace( args.rootDirectory, "" );
		} );
	}

	private array function _removeHiddenPages( required any pageFiles ) {
		for( var i = pageFiles.len(); i > 0; i-- ){
			if ( ReFindNoCase( "/_", pageFiles[ i ] ) ) {
				pageFiles.deleteAt( i );
			}
		}

		return pageFiles;
	}

	private array function _sortPageFilesByDepth( required array pageFiles ) {
		arguments.pageFiles.sort( function( page1, page2 ){
			var depth1 = page1.listLen( "\/" );
			var depth2 = page2.listLen( "\/" );

			if ( depth1 == depth2 ) {
				return page1 > page2 ? 1 : -1;
			}

			return depth1 > depth2 ? 1 : -1;
		} );

		return arguments.pageFiles;
	}

	private any function _preparePageObject( required string pageFilePath, required string rootDirectory ) {
		var page = "";
		var pageData = new PageReader().readPageFile( arguments.rootDirectory & pageFilePath )

		try {
			switch( pageData.pageType ?: "" ) {
				case "function":
					pageData.append( _getFunctionSpecification( pageData.slug, arguments.rootDirectory & pageFilePath ), false );
					page = new FunctionPage( argumentCollection=pageData );
				break;
				case "tag":
					pageData.append( _getTagSpecification( pageData.slug, arguments.rootDirectory & pageFilePath ), false );
					page = new TagPage( argumentCollection=pageData );
				break;
				default:
					page = new Page( argumentCollection=pageData );
			}
		} catch (any e) {
			writeOutput("Error preparing page: " & pageFilePath);
			dump( pageData );
			echo( e );
			abort;
		}

		for( var key in pageData ) {
			if ( !IsNull( pageData[ key ] ) ) {
				page[ key ] = pageData[ key ];
			}
		}

		page.setPath( _getPagePathFromMdFilePath( arguments.pageFilePath ) )
		if ( !page.getId().len() ) {
			page.setId( page.getPath() );
		}

		page.setChildren( [] );
		page.setDepth( ListLen( page.getPath(), "/" ) );

		return page;
	}

	private string function _getPagePathFromMdFilePath( required string filePath ) {
		var fileDir = GetDirectoryFromPath(  arguments.filePath );
		var parts   = fileDir.listToArray( "\/" );

		for( var i=1; i <= parts.len(); i++ ) {
			if ( parts[ i ].listLen( "." ) > 1 ) {
				parts[ i ] = parts[ i ].listRest( "." );
			}
		}

		return "/" & parts.toList( "/" );
	}

	private string function _getParentPagePathFromPagePath( required string pagePath ) {
		var parts = arguments.pagePath.listToArray( "/" );
		parts.deleteAt( parts.len() );

		return "/" & parts.toList( "/" );
	}

	private any function _getPageParent( required any page ) {
		var parentPath = _getParentPagePathFromPagePath( arguments.page.getPath() );

		return getPageByPath( parentPath );
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

	private void function _calculateNextAndPreviousPageLinks( required array pages, any nextParentPage, any lastPageTouched ) {
		var pageCount = arguments.pages.len();

		for( var i=1; i <= pageCount; i++ ) {
			var page = arguments.pages[i];

			if ( i==1 ) {
				page.setPreviousPage( arguments.lastPageTouched ?: NullValue() );
			} else {
				page.setPreviousPage( arguments.pages[i-1] );
			}

			if( page.getChildren().len() ) {
				page.setNextPage( page.getChildren()[1] );
			} elseif ( i == pageCount ) {
				page.setNextPage( arguments.nextParentPage ?: NullValue() );
			} else {
				page.setNextPage( arguments.pages[i+1] );
			}

			arguments.lastPageTouched = page;

			var nextParent = ( i == pageCount ) ? ( arguments.nextParentPage ?: NullValue() ) : arguments.pages[i+1];
			for( var child in page.getChildren() ){
				_calculateNextAndPreviousPageLinks( child.getChildren(), ( nextParent ?: NullValue() ), arguments.lastPageTouched )
			}
		}
	}

	private struct function _getTagSpecification( required string tagName, required string pageFilePath ) {
		var tag           = _getTagReferenceReader().getTag( arguments.tagName );
		var attributes    = tag.attributes ?: [];
		var attributesDir = GetDirectoryFromPath( arguments.pageFilePath ) & "_attributes/";

		for( var attrib in attributes ) {
			var attribDescriptionFile = attributesDir & attrib.name & ".md";
			if ( FileExists( attribDescriptionFile ) ) {
				attrib.description = FileRead( attribDescriptionFile );
			}
		}

		var examplesFile = GetDirectoryFromPath( arguments.pageFilePath ) & "_examples.md";
		if ( FileExists( examplesFile ) ) {
			tag.examples = FileRead( examplesFile );
		}

		return tag;
	}

	private struct function _getFunctionSpecification( required string functionName, required string pageFilePath ) {
		var func    = _getFunctionReferenceReader().getFunction( arguments.functionName );
		var args    = func.arguments ?: [];
		var argsDir = GetDirectoryFromPath( arguments.pageFilePath ) & "_arguments/";

		for( var arg in args ) {
			var argDescriptionFile = argsDir & arg.name & ".md";
			if ( FileExists( argDescriptionFile ) ) {
				arg.description = FileRead( argDescriptionFile );
			}
		}

		var examplesFile = GetDirectoryFromPath( arguments.pageFilePath ) & "_examples.md";
		if ( FileExists( examplesFile ) ) {
			func.examples = FileRead( examplesFile );
		}

		return func;
	}

	private any function _getFunctionReferenceReader() {
		return new api.reference.ReferenceReaderFactory().getFunctionReferenceReader();
	}

	private any function _getTagReferenceReader() {
		var buildProperties = new api.build.BuildProperties();

		return new api.reference.ReferenceReaderFactory().getTagReferenceReader();
	}
	
	// all categories should have content, all referenced categories should exist
	public void function checkCategories() {
		var pageCategories = {};
		var categories = {};
		var empty = {};

		for( var id in idMap ) {
			var cats = idMap[ id ].getCategories();
			if (!IsNull( cats) ){
				for (var cat in cats){
					if (not structKeyExists(pageCategories, cat))
						pageCategories[cat]=[];
					arrayAppend(pageCategories[cat], idMap[ id ].getPath());
				}
			}
		}
		

		for( var id in idMap ) {
			var pageType = idMap[ id ].getPageType(); 
			if (pageType eq "category"){
				var slug = idMap[ id ].getSlug(); 
				if (not structKeyExists(pageCategories, slug )){
					empty[slug]=idMap[ id ].getPath();
				}
				categories[slug] = "";
			}			
		}

		var missing = {};
		for (var cat in pageCategories){
			if (not structKeyExists(categories, cat )){
				missing[slug]=pageCategories[cat];
			}
		}

		if (structCount(empty) gt 0){
			var mess= "The following categories have no pages: " & structKeyList(empty);
			writeOutput(mess);			
			dump(empty);						
		}

		if (structCount(missing) gt 0){
			var mess= "The following categories referenced by pages don't exist: " & structKeyList(missing);
			writeOutput(mess);			
			dump(missing);						
		}

		if (structCount(empty) gt 0 or structCount(missing) gt 0){			
			abort;
		}
	}
}