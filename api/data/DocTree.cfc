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
	property name="recipeDates" type="struct"; // tracks the git created dates for recipes for latest content
	property name="syspropEnvvars" type="array"; // all system properties and environment variables
	property name="syspropByTag" type="struct"; // sysprops indexed by tag name
	property name="syspropByFunction" type="struct"; // sysprops indexed by function name

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
		setIdMap( [:] );
		setPathMap( [:] );
		setPageTypeMap( [:] );
		setRelatedMap( [:] );
		setCategoryMap( [:] );
		setReferenceMap( [:] );
		setDirectlyRelatedMap( [:] );
		setSyspropEnvvars( [] );
		setSyspropByTag( [:] );
		setSyspropByFunction( [:] );
	}

	public void function updateTree() {
		_updateTree();
	}

	public any function getPage( required string id ) {
		if ( !pageExists( arguments.id ) ) {
			// Debug logging - uncomment to troubleshoot broken links
			/*
			var debugInfo = {
				id: arguments.id,
				idLength: len( arguments.id ),
				endsWithBackslash: right( arguments.id, 1 ) eq chr( 92 ),
				endsWithForwardSlash: right( arguments.id, 1 ) eq "/",
				lastChar: asc( right( arguments.id, 1 ) ),
				idBytes: []
			};

			// Capture each character's ASCII value
			for ( var i = 1; i <= len( arguments.id ); i++ ) {
				debugInfo.idBytes.append( asc( mid( arguments.id, i, 1 ) ) );
			}

			// Only log first 5 failures with stack trace to avoid spam
			if ( !structKeyExists( variables, "getPageFailCount" ) ) {
				variables.getPageFailCount = 0;
			}
			variables.getPageFailCount++;

			systemOutput( "GetPage FAILED (#variables.getPageFailCount#): " & serializeJSON( debugInfo ), true );

			if ( variables.getPageFailCount <= 5 ) {
				systemOutput( "Stack trace:", true );
				var stack = callStackGet();
				for ( var i = 1; i <= min( 5, arrayLen( stack ) ); i++ ) {
					var line = structKeyExists( stack[i], "line" ) ? stack[i].line : "?";
					systemOutput( "  #i#: #stack[i].template# line #line#", true );
				}
			}
			*/

			// Don't throw - just log so we can see all broken links
		// throw( type="PageNotFound", message="Broken link: Page ID '#arguments.id#' not found in doctree. Check wiki-link references like [[#arguments.id#]] in your markdown files.", detail=arguments.id );
		}
		return variables.idMap[ arguments.id ] ?: NullValue();
	}

	public any function getPageByPath( required string path ) {
		if ( !structKeyExists( variables.pathMap, arguments.path  ) )
			; // systemOutput( "GetPageByPath: #path# does not exist in doctree", true ); // Debug logging
		return variables.pathMap[ arguments.path ] ?: NullValue();
	}

	public boolean function pageExists( required string id ) {
		return variables.idMap.keyExists( arguments.id );
	}

	public array function getPagesByCategory( required string category ) {
		var matchedPages = [];

		cfloop( collection=variables.idMap, item="local.page", index="local.id" ) {
			var pageCategories = local.page.getCategories();

			if ( !IsNull( pageCategories ) && pageCategories.findNoCase(arguments.category ) > 0 ) {
				matchedPages.append( local.page );
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
		cfloop( collection=categoryMap, index="local.cat" ) {
			cats.append(local.cat);
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
				// Skip URLs in related field - they're external links, not page IDs
				if ( !relatedId.startsWith( "http://" ) && !relatedId.startsWith( "https://" ) ) {
					crumbs.append( _getPageBreadCrumbs( getPage(relatedId) ) );
				}
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
				// systemOutput( arguments.page.path & arguments.page.name, true);
				var _parsedPage = new PageReader().preparePageObject( variables.rootDir, arguments.page.name, arguments.page.directory, arguments.page.path );

				if ( ! _parsedPage.getHidden() ) {
					variables.pageCache.addPage(
						_parsedPage,
						_parsedPage.getPath()
					);
				} else {
					// systemOutput("hidden--------------------#arguments.page.path#", true)
				}
			}, (_threads != 1), _threads);
			request.logger (text=" #len(variables.pageCache.getPages())# Pages Parsed in #(getTickCount()-start)/1000#s");

			_buildTreeHierarchy(false);
			_updateRecipeDates();
			_loadSyspropEnvvars();
			_parseTree();

			// Debug: dump idMap to disk after tree is built
			//_debugDumpIdMap();
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
			cfloop( collection=pathCache, index="local.c" ) {
				if (not exists.keyExists(local.c))
					deleted.append(local.c);
			}

			if (deleted.len() gt 0){
				// pages in cache which have been deleted
				pageCache.removePages( deleted, "deleted" );
			}

			if (added gt 0 or deleted.len() gt 0)
				pageCache.reSort();
			_buildTreeHierarchy(true);
			_updateRecipeDates();
			_parseTree();
		}
	}
	private void function _buildTreeHierarchy(boolean reset="false") {
    	//var start = getTickCount();
		var pages = variables.pageCache.getPages();
		cfloop( collection=pages, item="local.pageData", index="local.pagePath" ) {
			var page = local.pageData.page;
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
		cfloop( array=variables.tree, item="local.folder" ) {
			switch( local.folder.getId() ){
				case "guides":
					var guideTree = local.folder.getChildren();
					cfloop( array=guideTree, item="local.guide" ) {
						if (local.guide.getForceSortOrder() gt 0){
							local.guide.setSortOrder(local.guide.getForceSortOrder());
						} else {
							local.guide.setSortOrder(6 + NumberFormat(local.guide.getSortOrder()/100,"0.00"));
						}
						variables.tree.append(local.guide);
					}
					break;
				case "recipes":
					var recipeTree = local.folder.getChildren();
					cfloop( array=recipeTree, item="local.recipe" ) {
						if (local.recipe.getForceSortOrder() gt 0){
							local.recipe.setSortOrder(local.recipe.getForceSortOrder());
						} else {
							local.recipe.setSortOrder(5 + NumberFormat(local.recipe.getSortOrder()/100,"0.00"));
						}
						variables.tree.append(local.recipe);
					}
					break;
				/*
				case "reference":
					// add sysprop page to reference section (also stays in recipes)
					if ( pageExists( "environment-variables-system-properties" ) ) {
						var syspropPage = getPage( "environment-variables-system-properties" );
						if ( !IsNull( syspropPage ) ) {
							folder.addChild( syspropPage );
							request.logger( text="Added sysprop page to reference menu" );
						}
					} else {
						request.logger( text="Sysprop page not found in idMap", type="WARN" );
					}
					break;
				*/
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

		if ( !isPage ){
			return;
			throw "not a page [#page.getFilePath()#]"; // only add main pages
		}

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


		cfloop( array=arguments.children, item="local.child" ) {
			_sortChildren( local.child.getChildren() );
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
			cfloop( array=page.getChildren(), item="local.child" ) {
				_calculateNextAndPreviousPageLinks( local.child.getChildren(), ( nextParent ?: NullValue() ), arguments.lastPageTouched )
			}
		}
	}

	private void function _buildRelated(){
		var related = {};

		cfloop( collection=variables.idMap, item="local.page", index="local.id" ) {
			var relatedPageLinks = local.page.getRelated();
			var pageId = local.page.getId();

			if ( !IsNull( relatedPageLinks ) and ArrayLen(relatedPageLinks) gt 0) {
				cfloop( array=relatedPageLinks, item="local.link" ) {
					// Skip URLs in related field - they're external links, not page IDs
					if ( !local.link.startsWith( "http://" ) && !local.link.startsWith( "https://" ) ) {
						// systemOutput( "Processing link [#local.link#] from page [#pageId#]", true ); // Debug logging
						if (len(trim(local.link)) gt 0){
							if (!structKeyExists(related, local.id))
								related[local.id] = {};
							if (!structKeyExists(related, local.link))
								related[local.link] = {};
							related[local.link][pageId]="";
							related[pageId][local.link]="";
						}
					}
				}
			}
		}
		var _relatedMap = {};
		cfloop( collection=related, item="local.relatedLinks", index="local.id" ) {
			var links = ListToArray( structKeyList(local.relatedLinks) );
			ArraySort(links,"textnocase");
			_relatedMap[local.id] = links;
		}
		setRelatedMap(_relatedMap);

		// cross referencing BIF to object methods
		// i.e. Struct.keyExists and StructKeyExists

		var _related = {};
		cfloop( collection=variables.idMap, item="local.page", index="local.id" ) {
			if (local.page.getMethodObject().len() && local.page.getMethodName().len()){
				var relatedId = "function-" & local.page.getMethodObject() & local.page.getMethodName();
				if (variables.idMap.keyExists(relatedId)){
					if (!_related.keyExists(local.id) )
						_related[local.id] = {};
					_related[local.id][relatedId] = "";
					if (!_related.keyExists(relatedId) )
						_related[relatedId] = {};
					_related[relatedId][local.id] = "";
				}
			}
			if (local.page.getMethodName().len()){
				var relatedId = "function-" & local.page.getMethodName();
				if (variables.idMap.keyExists(relatedId)){
					if (!_related.keyExists(local.id) )
						_related[local.id] = {};
					_related[local.id][relatedId] = "";
					if (!_related.keyExists(relatedId) )
						_related[relatedId] = {};
					_related[relatedId][local.id] = "";
				}
			}
		}
		setDirectlyRelatedMap(_related);
	}

	// all categories should have content, all referenced categories should exist


	public struct function _buildReferenceMap() {
		var pages = {};
		var pagesByType = {};
		cfloop( collection=idMap, index="local.id" ) {
			var pageType = "content";
			if ( listLen( local.id, "-" ) gt 1)
				pageType = listFirst( local.id,"-" );
			if ( !structKeyExists( pages, pageType ) )
				pages[ pageType ] = {};
			pages[ pageType ][ local.id ]="";
		}
		cfloop( collection=pages, item="local.pageIds", index="local.types" ) {
			var ids = ListToArray( structKeyList( local.pageIds ) );
			ArraySort( ids,"textnocase" );
			pagesByType[ local.types ] = ids;
		}
		setReferenceMap( pagesByType );
		return referenceMap;
	}

	
	private void function _updateRecipeDates(){
		var s = getTickCount()
		var gitReader = new api.parsers.git.gitReader();
		var repoRoot = expandPath( getDirectoryFromPath(GetCurrentTemplatePath()) & "../.." );
		var skip = {
			"README.md": true
		};
		var folder ="docs\recipes\";

		setRecipeDates(gitReader.getDatesForFolder( repoRoot, folder, server.luceeDocsRecipeDateCache ?: {}, skip));
		server.luceeDocsRecipeDateCache = duplicate(getRecipeDates()); // this is expensive and docTree gets blown away on reload, plus applicationStop()
		request.logger("Scanned git logs for recipes dates in #getTickCount()-s#ms, found #structCount(getRecipeDates())# recipes");
	}

	private void function _loadSyspropEnvvars() {
		var s = getTickCount();

		// Get all sysprops/envvars from Lucee
		var allProps = getSystemPropOrEnvVar();
		setSyspropEnvvars( allProps );

		// Build indexes by tag and function
		var byTag = {};
		var byFunction = {};

		cfloop( array=allProps, item="local.prop" ) {
			// Index by tags (strip cf prefix for docs compatibility)
			if ( structKeyExists( local.prop, "tags" ) && isArray( local.prop.tags ) ) {
				cfloop( array=local.prop.tags, item="local.tag" ) {
					// Strip cf prefix if present (cfquery -> query)
					var tagKey = left( local.tag, 2 ) == "cf" ? mid( local.tag, 3 ) : local.tag;
					if ( !structKeyExists( byTag, tagKey ) ) {
						byTag[ tagKey ] = [];
					}
					arrayAppend( byTag[ tagKey ], local.prop );
				}
			}

			// Index by functions
			if ( structKeyExists( local.prop, "functions" ) && isArray( local.prop.functions ) ) {
				cfloop( array=local.prop.functions, item="local.func" ) {
					if ( !structKeyExists( byFunction, local.func ) ) {
						byFunction[ local.func ] = [];
					}
					arrayAppend( byFunction[ local.func ], local.prop );
				}
			}
		}

		setSyspropByTag( byTag );
		setSyspropByFunction( byFunction );

		request.logger( "Loaded #arrayLen(allProps)# sysprops/envvars in #getTickCount()-s#ms" );
	}

	public array function getSyspropsByTag( required string tagName ) {
		var byTag = getSyspropByTag();
		return structKeyExists( byTag, arguments.tagName ) ? byTag[ arguments.tagName ] : [];
	}

	public array function getSyspropsByFunction( required string functionName ) {
		var byFunction = getSyspropByFunction();
		return structKeyExists( byFunction, arguments.functionName ) ? byFunction[ arguments.functionName ] : [];
	}

	// hack first cut
	public function renderContent( required string content, required struct args, boolean markdown=false ) {
		// Extract hash parameter if present (e.g., "sysprop-envvar#LUCEE_ADMIN_ENABLED")
		var contentType = arguments.content;
		var hashParam = "";

		if ( find( "##", contentType ) ) {
			hashParam = listLast( contentType, "##" );
			contentType = listFirst( contentType, "##" );
		}

		switch (contentType){
			case "latest-recipies":
				return new api.rendering.content.recipes().render(this, contentType, getRecipeDates(), arguments.markdown);
			case "sysprop-envvar-listing":
				return new api.rendering.content.syspropEnvvar().render(this, contentType, arguments.args, arguments.markdown);
			case "sysprop-envvar":
				return new api.rendering.content.syspropEnvvarInline().render(this, contentType, arguments.args, hashParam, arguments.markdown);
			case "sysprop-envvar-for-tag":
				return new api.rendering.content.syspropEnvvarForTag().render(this, contentType, arguments.args, arguments.markdown);
			case "sysprop-envvar-for-function":
				return new api.rendering.content.syspropEnvvarForFunction().render(this, contentType, arguments.args, arguments.markdown);
			default:
				throw("unknown content type: " & contentType);
		}
	}

	private void function _debugDumpIdMap() {
		// Debug function - uncomment to dump idMap contents to disk for inspection
		// systemOutput( "=== DEBUG: Dumping idMap to disk ===", true );
		var idMapKeys = variables.idMap.keyArray().sort( "textnocase" );
		var debugInfo = {
			totalIds: arrayLen( idMapKeys ),
			functionIds: [],
			tagIds: [],
			otherIds: [],
			sampleIds: []
		};

		// Categorize IDs
		cfloop( array=idMapKeys, item="local.id" ) {
			if ( left( local.id, 9 ) == "function-" ) {
				debugInfo.functionIds.append( local.id );
			} else if ( left( local.id, 4 ) == "tag-" ) {
				debugInfo.tagIds.append( local.id );
			} else {
				debugInfo.otherIds.append( local.id );
			}
		}

		// Sample some IDs for verification
		debugInfo.sampleIds = idMapKeys.slice( 1, min( 20, arrayLen( idMapKeys ) ) );

		// Check for specific broken links
		debugInfo.missingFromBrokenList = {
			"function-websocketinfo": variables.idMap.keyExists( "function-websocketinfo" ),
			"function-arraypop": variables.idMap.keyExists( "function-arraypop" ),
			"function-javacast": variables.idMap.keyExists( "function-javacast" ),
			"tag-imap": variables.idMap.keyExists( "tag-imap" ),
			"tag-cache": variables.idMap.keyExists( "tag-cache" )
		};

		// Write full key list
		fileWrite( "D:\work\lucee-docs\test-output\idmap-keys.txt", idMapKeys.toList( chr( 10 ) ) );

		// Write summary
		fileWrite( "D:\work\lucee-docs\test-output\idmap-summary.json", serializeJSON( debugInfo ) );

		// systemOutput( "Total IDs in map: #debugInfo.totalIds#", true );
		// systemOutput( "Function IDs: #arrayLen( debugInfo.functionIds )#", true );
		// systemOutput( "Tag IDs: #arrayLen( debugInfo.tagIds )#", true );
		// systemOutput( "Other IDs: #arrayLen( debugInfo.otherIds )#", true );
		// systemOutput( "Written to: test-output/idmap-keys.txt and test-output/idmap-summary.json", true );

		// Throw to stop build and inspect
		throw( type="DebugStop", message="IdMap dumped - stopping build for inspection" );
	}
}
