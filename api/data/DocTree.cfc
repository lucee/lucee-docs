component accessors=true {
	property name="rootDir"    type="string"; // top level folders
	property name="tree"    type="array"; // top level folders
	property name="idMap"   type="struct"; // pages by id
	property name="pathMap" type="struct"; // pages by paths
	property name="pageTypeMap" type="struct"; // tracks the total number of pages by type
	property name="relatedMap" type="struct"; // tracks related pages
	property name="categoryMap" type="struct"; // tracks categories pages
	property name="referenceMap" type="struct"; // tracks references
	property name="pageCache" type="any"; // tracks references
	// tracks directly related pages ( i.e. BIF and object member, Struct.keyExists and StructKeyExists) LD-112
	property name="directlyRelatedMap" type="struct";

	property name="threads" type="numeric"; // tracks references

	public any function init( required string rootDirectory, required numeric threads ) {
		variables.rootDir =  arguments.rootDirectory;
		variables.pageCache = new PageCache(rootDir);
		setThreads(arguments.threads);
		var start = getTickCount();

		request.logger (text="Starting Lucee Documentation Build");

		_loadTree();

		request.logger (text="Documentation Compiled in #(getTickCount()-start)/1000#s");

		return this;
	}

	private void function _initializeEmptyTree() {
		setTree( [] );
		setIdMap( {} );
		setPathMap( {} );
		setPageTypeMap( {} );
		setRelatedMap( {} );
		setCategoryMap( {} );
		setReferenceMap( {} );
		setDirectlyRelatedMap( {} );
	}

	public void function updateTree() {
		_updateTree();
	}

	public any function getPage( required string id ) {
		return variables.idMap[ arguments.id ] ?: NullValue();
	}

	public any function getPageByPath( required string path ) {
		return variables.pathMap[ arguments.path ] ?: NullValue();
	}

	public boolean function pageExists( required string id ) {
		return variables.idMap.keyExists( arguments.id );
	}

	public array function getPagesByCategory( required string category ) {
		var matchedPages = [];

		for( var id in variables.idMap ) {
			var pageCategories = variables.idMap[ id ].getCategories();

			if ( !IsNull( pageCategories ) && pageCategories.findNoCase(arguments.category ) > 0 ) {
				matchedPages.append( variables.idMap[ id ] );
			}
		}

		return matchedPages;
	}

	// used for categories
	public array function sortPagesByType( required array pages ) {
		return arguments.pages.sort( function( pageA, pageB ) {
			if ( arguments.pageA.getPageType() > arguments.pageB.getPageType() ) {
				return 1;
			}
			if ( arguments.pageA.getPageType() < arguments.pageB.getPageType() ) {
				return -1;
			}

			return arguments.pageA.getTitle() > arguments.pageB.getTitle() ? 1 : -1;
		} );
	}

	public array function getPageRelated(required any page){
		if (structKeyExists(variables.relatedMap, arguments.page.getId()))
			return variables.relatedMap[arguments.page.getId()];
		else
			return [];
	}

	public struct function getPageIds(){
		if (structCount(referenceMap) eq 0)
			_buildReferenceMap();
		return getReferenceMap();
	}

	public array function getCategories(){
		var cats = [];
		for (var cat in categoryMap){
			cats.append(cat);
		}
		ArraySort(cats, "textnocase");
		return cats;
	}

	public array function getPageBreadCrumbs(required any page){
		var crumbs = [];
		crumbs.append( _getPageBreadCrumbs(arguments.page) );
		if ( variables.directlyRelatedMap.keyExists(arguments.page.getId()) ){
			var related = variables.directlyRelatedMap[arguments.page.getId()];
			for (relatedId in related){
				crumbs.append( _getPageBreadCrumbs( getPage(relatedId) ) );
			}
		}
		return crumbs;
	}

	private array function _getPageBreadCrumbs(required any page){
		var crumbs = [];
		var parent = arguments.page.getParent();
		while( !IsNull( parent ) ) {
			if (parent.getVisible())
				crumbs.prepend( parent.getId() );
			parent = parent.getParent();
		}
		crumbs.append( arguments.page.getId() );
		return crumbs;
	}

	public struct function getPageSource(required string pagePath){
		if (not FileExists(rootDir & arguments.pagePath)){
			var reqType = listLast(arguments.pagePath,"/");
			var dir = getDirectoryFromPath(rootDir & arguments.pagePath);

			switch (reqType){
				case "page.md":
					// check for directories with number prefix and match, i.e. /01.functions/
					var newDir = variables.pageCache.createPageDirectory(
						pagePath.listDeleteAt(ListLen(pagePath,"/"), "/")
					);
					arguments.pagePath = newDir & "/page.md";

				case "_examples.md":
					try {
						request.logger("Creating new file " & variables.rootDir & arguments.pagePath);
						FileWrite(variables.rootDir & arguments.pagePath, "");
					} catch (any){
						header statuscode="401";
						writeOutput("Can't create file " & variables.rootDir & arguments.pagePath);
						dump(cfcatch);
						abort;
					}
					break;
				default:
					header statuscode="404";
					writeOutput("File Not found " & reqType);
					abort;
			}
		}

		var page = new PageReader().readPageFileSource( rootDir & arguments.pagePath );
		var body = page.BODY;
		structdelete(page, "BODY");
		return {
			content: body,
			types: getComponentMetadata(new Page()).properties,
			properties: page
		};
	}

	public any function updatePageSource(required string filePath, required string content,
			required struct properties, required string pageUrl){

		if ( not FileExists(variables.rootDir & arguments.filePath)){
			var fileName = ListLast(arguments.filePath, "/");
			var newDir = variables.pageCache.createPageDirectory(
				arguments.filePath.listDeleteAt( ListLen(arguments.filePath,"/"), "/")
			);
			arguments.filePath = newDir & "/" & filename;
		}
		request.logger("updatePageSource: " & arguments.filePath);
		var result = new PageReader().savePageFile( rootDir & arguments.filePath, arguments.content, arguments.properties);

		var pagePath = arguments.pageUrl;
		if (pagePath.endsWith(".html"))
			pagePath = mid(pagePath,1, len(pagePath) - len(".html") ) ;
		variables.pageCache.removePages(pagePath, "updated");
		_updateTree();
		return result;
	}

	public any function getReferenceByStatus(required string status){
		return new StatusFilter().getReferenceByStatus( variables.idMap, arguments.status );
	}

// private helpers
	private void function _loadTree() {
		lock name="docsBuildTree" timeout=10 {
			_initializeEmptyTree();

			variables.pageCache.reset();
			var q_source_files = variables.pageCache.getPageFileList(lastModified=false);

			var start = getTickCount();
			var _threads = getThreads();
			each (q_source_files, function (page) {
				var _parsedPage = new PageReader().preparePageObject( variables.rootDir, arguments.page.name, arguments.page.directory, arguments.page.path );

				if ( ! _parsedPage.getHidden() ) {
					variables.pageCache.addPage(
						_parsedPage,
						arguments.page.path
					);
				}
			}, (_threads != 1), _threads);
			request.logger (text="Pages Parsed in #(getTickCount()-start)/1000#s");

			_buildTreeHierachy(false);
			_parseTree();
		}
	}

	private void function _updateTree() {
		lock name="docsBuildTree" timeout=10 {
			_initializeEmptyTree();
			var pathCache = variables.pageCache.getPathCache();
			var q_source_files = variables.pageCache.getPageFileList(lastModified=true);
			var added = 0;
			var exists = {};
			var deleted = [];

			loop query=q_source_files {
				var addFile = false;
				if (!structKeyExists(pathCache, q_source_files.path)){
					addFile = true;
				} else if (dateCompare(q_source_files.dateLastModified, pathCache[q_source_files.path]) eq 1) {
					// do a timestamp comparison against the cache here
					request.logger (text="source updated #q_source_files.path#");
					addFile = true;
				}

				if (addFile){
					request.logger (text="Update pageCache, adding #q_source_files.path#");
					variables.pageCache.addPage(
						new PageReader().preparePageObject( variables.rootDir, q_source_files.name, q_source_files.directory, q_source_files.path ),
						q_source_files.path
					);
					added++;
				}
				exists[q_source_files.path] = true;
			}
			for( var c in pathCache ) {
				if (not exists.keyExists(c))
					deleted.append(c);
			}

			if (deleted.len() gt 0){
				// pages in cache which have been deleted
				pageCache.removePages( deleted, "deleted" );
			}

			if (added gt 0 or deleted.len() gt 0)
				pageCache.reSort();
			_buildTreeHierachy(true);
			_parseTree();
		}
	}

	private void function _buildTreeHierachy(boolean reset="false") {
    	//var start = getTickCount();
		var pages = variables.pageCache.getPages();
		for (var pagePath in pages ){
			var page = pages[ pagePath ].page;
			if ( arguments.reset )
				page.reset(); // clear previous structure data
			try {
				_addPageToTree( page );
			} catch (any e){
				dump(page);
				dump(e);
				systemOutput( pagePath, true );
				systemOutput( e, true );
				echo(e);
				abort;
			}
		}
		//request.logger (text="Tree processed in #(getTickCount()-start)/1000#s");
	}

	private void function _parseTree( ) {
		// expose guides as a top level folder
		for (var folder in variables.tree){
			if (folder.getId() eq "guides"){
				var guideTree = folder.getChildren();
				for (var guide in guideTree){
					if (guide.getForceSortOrder() gt 0){
						guide.setSortOrder(guide.getForceSortOrder());
					} else {
						guide.setSortOrder(6 + NumberFormat(guide.getSortOrder()/100,"0.00"));
					}
					variables.tree.append(guide);
				}
			}
		}
		_sortChildren( variables.tree );
		_calculateNextAndPreviousPageLinks( variables.tree );
		_buildRelated();
		setCategoryMap( new Category().buildCategories( variables.idMap ) );

		request.logger (text="ParseTree results: ids: #structCount(variables.idMap)#, " &
			"paths: #structCount(variables.pathMap)#, categories: #structCount(variables.categoryMap)#");
	}

	private void function _addPageToTree( required any page ) {
		var parent    = _getPageParent( arguments.page );
		var ancestors = [];
		var lineage   = [];
		var pageType = arguments.page.getPageType();
		var isPage = arguments.page.isPage(); // workaround for page types not being parsed out correctly in PageReader.readPageFile

		if ( !IsNull( parent ) ) {
			if ( isPage )
				parent.addChild( arguments.page ); // don't add page subelements, i.e _attributes etc
			arguments.page.setParent( parent );

			ancestors = parent.getAncestors();
			if ( ancestors.len() eq 0 or pageType eq "_method" ) // avoid duplicates, hack for methods
				ancestors.append( parent.getId() );
		} else {
			variables.tree.append( arguments.page );
		}

 		if ( !isPage ){
			if ( page.getPath() comtains "/recipes" ){
				request.logger(text="skipping coz /recipes" );
				return;
			}
			throw "not a page [#page.path#]"; // only add main pages
		}

		if ( !StructKeyExists( variables.pageTypeMap, pageType ) )
			variables.pageTypeMap[ pageType ] = 0;
		variables.pageTypeMap[ pageType ]++;

		arguments.page.setAncestors( ancestors );
		lineage = Duplicate( ancestors );
		lineage.append( arguments.page.getId() );
		arguments.page.setLineage( lineage );
		variables.idMap[ arguments.page.getId() ]     = arguments.page;
		variables.pathMap[ arguments.page.getPath() ] = arguments.page;
	}

	private string function _getParentPagePathFromPagePath( required string pagePath ) {
		var parts = arguments.pagePath.listToArray( "/" );
		if (parts.len() gt 1){
			parts.deleteAt( parts.len() );
			return "/" & parts.toList( "/" );
		} else {
			return "/";
		}
	}

	private any function _getPageParent( required any page ) {
		var parentPath = _getParentPagePathFromPagePath( arguments.page.getPath() );

		return getPageByPath( parentPath );
	}

	private void function _sortChildren( required array children ){
		arguments.children.sort( function( childA, childB ) {
			if ( arguments.childA.getSortOrder() == arguments.childB.getSortOrder() ) {
				return arguments.childA.getTitle() > arguments.childB.getTitle() ? 1 : -1;
			}
			return arguments.childA.getSortOrder() > arguments.childB.getSortOrder() ? 1 : -1;
		} );


		for( var child in arguments.children ) {
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

			if ( page.getChildren().len() ) {
				page.setNextPage( page.getChildren()[1] );
			} else if ( i == pageCount ) {
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

	private void function _buildRelated(){
		var related = {};

		for ( var id in variables.idMap ) {
			var relatedPageLinks = variables.idMap[ id ].getRelated();
			var pageId = variables.idMap[ id ].getId();

			if ( !IsNull( relatedPageLinks ) and ArrayLen(relatedPageLinks) gt 0) {
				for( var link in relatedPageLinks ) {
					if (len(trim(link)) gt 0){
						if (!structKeyExists(related, id))
							related[id] = {};
						if (!structKeyExists(related, link))
							related[link] = {};
						related[link][pageId]="";
						related[pageId][link]="";
					}
				}
			}
		}
		var _relatedMap = {};
		for (var id in related){
			var links = ListToArray( structKeyList(related[id]) );
			ArraySort(links,"textnocase");
			_relatedMap[id] = links;
		}
		setRelatedMap(_relatedMap);

		// cross referencing BIF to object methods
		// i.e. Struct.keyExists and StructKeyExists

		var _related = {};
		for ( var id in variables.idMap ) {
			var page = variables.idMap[ id ];
			if (page.getMethodObject().len() && page.getMethodName().len()){
				var relatedId = "function-" & page.getMethodObject() & page.getMethodName();
				if (variables.idMap.keyExists(relatedId)){
					if (!_related.keyExists(id) )
						_related[id] = {};
					_related[id][relatedId] = "";
					if (!_related.keyExists(relatedId) )
						_related[relatedId] = {};
					_related[relatedId][id] = "";
				}
			}
			if (page.getMethodName().len()){
				var relatedId = "function-" & page.getMethodName();
				if (variables.idMap.keyExists(relatedId)){
					if (!_related.keyExists(id) )
						_related[id] = {};
					_related[id][relatedId] = "";
					if (!_related.keyExists(relatedId) )
						_related[relatedId] = {};
					_related[relatedId][id] = "";
				}
			}
		}
		setDirectlyRelatedMap(_related);
	}

	// all categories should have content, all referenced categories should exist


	public struct function _buildReferenceMap() {
		var pages = {};
		var pagesByType = {};
		for ( var id in idMap ) {
			var pageType = "content";
			if ( listLen( id, "-" ) gt 1)
				pageType = listFirst( id,"-" );
			if ( !structKeyExists( pages, pageType ) )
				pages[ pageType ] = {};
			pages[ pageType ][ id ]="";
		}
		for (var types in pages){
			var ids = ListToArray( structKeyList( pages[ types ] ) );
			ArraySort( ids,"textnocase" );
			pagesByType[ types ] = ids;
		}
		setReferenceMap( pagesByType );
		return referenceMap;
	}
}
