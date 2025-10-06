component {

	public string function renderContent( any docTree, required string content ) {
		return docTree.renderContent( content );
	}

	public string function _getIssueTrackerLink(required string name) {
		var link = Replace( new api.build.BuildProperties().getIssueTrackerLink(), "{search}", urlEncodedFormat(arguments.name) )
		return '<a href="#link#" class="no-oembed" target="_blank">Search Issue Tracker <i class="fa fa-external-link"></i></a>';
	}

	public string function _getTestCasesLink(required string name) {
		var link = Replace( new api.build.BuildProperties().getTestCasesLink(), "{search}", urlEncodedFormat(arguments.name) )
		return '<a href="#link#" class="no-oembed" target="_blank">Search Lucee Test Cases <i class="fa fa-external-link"></i></a> (good for further, detailed examples)';
	}

	public void function build( required any docTree, required string buildDirectory, required numeric threads) {
		var pagePaths = arguments.docTree.getPageCache().getPages();

		request.filesWritten = 0;
		request.filesToWrite = StructCount(pagePaths);

		// purge previous build directory contents
		if ( directoryExists( buildDirectory ) )
			DirectoryDelete( buildDirectory, true );
		directoryCreate( buildDirectory );

		request.logger (text="Builder HTML directory: #arguments.buildDirectory#");

		new api.parsers.ParserFactory().getMarkdownParser(); // so the parser in use shows up in logs

		//for ( var path in pagePaths ) {
		each(pagePaths, function(path){
			var tick = getTickCount();
			var page = pagePaths[ arguments.path ].page;

			if ( page.isPage() ) {
				// write out full html page
				var pageContent = renderPageContent( page, docTree, false, {} );
				_writePage( page, buildDirectory, docTree, pageContent, {} );

				// write out markdown page
				var markdownContent = renderMarkdownContent( page, docTree );
				_writeMarkdownPage( page, buildDirectory, markdownContent, docTree );
			}

			if ((request.filesWritten mod 100) eq 0){
				request.logger(text="Rendering Documentation (#request.filesWritten# / #request.filesToWrite#)");
			}
			if (getTickCount()-tick gt 100)
				request.logger(text="Page took #arguments.path# #numberformat(getTickCount()-tick)# ms", link="#arguments.path#.html");
		}, (arguments.threads > 1), arguments.threads);
		//}
		request.logger (text="Html Builder #request.filesWritten# files produced");

		_renderStaticPages( arguments.buildDirectory, arguments.docTree, "/" );
		_copyStaticAssets( arguments.buildDirectory );
		_copySiteImages( arguments.buildDirectory, arguments.docTree );
		_writeSearchIndex( arguments.docTree, arguments.buildDirectory );
	}

	public string function renderPageContent( required any page, required any docTree,
			required boolean edit, required struct htmlOpts  ){
		try {
			var contentArgs = { page = arguments.page, docTree=arguments.docTree, edit=arguments.edit, htmlOpts=arguments.htmlOpts };

			var pageContent = renderTemplate(
				template = "templates/#_getPageLayoutFile( arguments.page )#.cfm"
				, args     = contentArgs
				, helpers  = "/builders/html/helpers"
			);
		} catch( any e ) {
			e.additional.luceeDocsTitle = arguments.page.getTitle();
			e.additional.luceeDocsPath = arguments.page.getPath();
			e.additional.luceeDocsPageId = arguments.page.getid();
			rethrow;
		}
		return pageContent;
	}

	public string function renderMarkdownContent( required any page, required any docTree ){
		try {
			var contentArgs = { page = arguments.page, docTree=arguments.docTree, edit=false };

			var markdownContent = renderTemplate(
				template = "../markdown/templates/#_getPageLayoutFile( arguments.page )#.cfm"
				, args     = contentArgs
				, helpers  = "/builders/html/helpers"
				, markdown = true
			);
		} catch( any e ) {
			e.additional.luceeDocsTitle = arguments.page.getTitle();
			e.additional.luceeDocsPath = arguments.page.getPath();
			e.additional.luceeDocsPageId = arguments.page.getid();
			rethrow;
		}
		return markdownContent;
	}

	public string function renderPage( required any page, required any docTree,
			required string pageContent, required boolean edit, required struct htmlOptions ){

		var crumbs = arguments.docTree.getPageBreadCrumbs( arguments.page );
		var excludeLinkMap = {}; // tracks links to exclude from See also
		var links = [];
		var categories = [];

		if ( !IsNull( arguments.page.getCategories() ) ) {
			for( var category in arguments.page.getCategories() ) {
				var catId = "category-" & category;
				if ( arguments.docTree.pageExists( catId ) ) {
					links.append( "[[#catId#]]" );
					categories.append( "[[#catId#]]" );
				} else {
					request.logger(text="Missing category: " & category, type="error", link="#arguments.page.getPath()#.html");
				}
			}
		}
		excludeLinkMap[arguments.page.getId()]=""; // don't link to itself
		// don't repeat content listed as child of the page
		var children = arguments.page.getChildren()
		for (var child in children){
			excludeLinkMap[child.getId()]="";
		}

		var related = arguments.docTree.getPageRelated(arguments.page);
		for( var link in related ) {
			if (len(link) gt 0 and not StructKeyExists(excludeLinkMap, link)){
				links.append( "[[" & link & "]]");
			}
		}

		if ( len(arguments.page.getId()) gt 0){
			var name = listRest(arguments.page.getId(), "-");
			switch (arguments.page.getPageType()){
				case "tag":
					// add a cf prefix, tried adding with jql "OR & name" but that didn't work
					links.append( variables._getIssueTrackerLink("cf" & name ) );
					links.append( variables._getTestCasesLink( name ) );
					break;
				case "function":
					links.append( variables._getIssueTrackerLink(name) );
					links.append( variables._getTestCasesLink(name) );
					break;
				default:
					break;
			}
		}

		var template = arguments.htmlOptions.mainTemplate ?: "main.cfm";
		var crumbsArgs = {
			crumbs:crumbs,
			page: arguments.page,
			docTree: arguments.docTree,
			categories: categories.sort("textNoCase"),
			edit: arguments.edit,
			htmlOpts:  arguments.htmlOptions
		};
		var seeAlsoArgs = {
			links= links,
			htmlOpts=arguments.htmlOptions
		}

		try {

			var args = {
				body       = Trim( arguments.pageContent )
				, htmlOpts   = arguments.htmlOptions
				, page       = arguments.page
				, edit       = arguments.edit
				, crumbs     = renderTemplate( template="layouts/breadcrumbs.cfm", helpers  = "/builders/html/helpers",
					args = crumbsArgs
				)
				, seeAlso    = renderTemplate( template="layouts/seeAlso.cfm"    , helpers  = "/builders/html/helpers",
					args = seeAlsoArgs )
			};

			if ( !structKeyExists(arguments.htmlOptions, "no_navigation" ) ){
				args.navTree    = renderTemplate( template="layouts/sideNavTree.cfm", helpers  = "/builders/html/helpers", args={
					crumbs=crumbs,
					docTree=arguments.docTree,
					pageLineage=arguments.page.getLineage(),
					pageLineageMap=arguments.page.getPageLineageMap()
				} );
			} else  {
				args.navTree = "";
			}

			var pageContent = renderTemplate(
				template = "layouts/#template#"
				, helpers  = "/builders/html/helpers"
				, args     = args
			);
		} catch( any e ) {
			//e.additional.luceeDocsPage = arguments.page;
			e.additional.luceeDocsTitle = arguments.page.getTitle();
			e.additional.luceeDocsPath = arguments.page.getPath();
			e.additional.luceeDocsId = arguments.page.getId();
			rethrow;
		}
		return pageContent;
	}

	public string function renderFileNotFound(required string filePath, required any docTree, required string baseHref) {
		return _renderStaticPage( "/builders/html/staticPages/404.html", "File not found", arguments.docTree, arguments.baseHref, true );
	}

	public string function renderSearchIndex( required any docTree ) {
		var pages           = arguments.docTree.getIdMap();
		var searchIndex     = [];

		for( var pageId in pages ) {
			var page = pages[ pageId ];
			var icon = "";

			switch( page.getPageType() ){
				case "function":
				case "tag":
					icon = "code";
					break;
				default:
					icon = "file-o";
			}

			searchIndex.append( {
				  "value"   = page.getPath() & ".html"
				, "display" = page.getTitle()
				, "text"    = HtmlEditFormat( page.getTitle() )
				, "desc" 	= "#HtmlEditFormat( page.getTitle() & " " & page.getDescription() )#" // used for indexing
				, "type"    = page.getPageType()
				, "icon"    = icon
			} );
		}

		return SerializeJson( searchIndex );
	}

// PRIVATE HELPERS
	private void function _writePage( required any page, required string buildDirectory,
			required any docTree, required string pageContent, required struct htmlOptions ) {
		var filePath      = variables._getHtmlFilePath( arguments.page, arguments.buildDirectory );
		var fileDirectory = GetDirectoryFromPath( filePath );

		lock name="CreateDirectory" timeout=10 {
			if ( !DirectoryExists( fileDirectory ) ) {
				DirectoryCreate( fileDirectory );
			}
		}

		var html = variables.cleanHtml(
			variables.renderPage( arguments.page,
				arguments.docTree, arguments.pageContent, false ,
				arguments.htmlOptions, arguments.buildDirectory
			)
		);
		FileWrite( filePath, html );
	}

	// regex strips left over whitespace multiple new lines
	private function cleanHtml( required string content){

		return ReReplace(arguments.content, "[\r\n]\s*([\r\n]|\Z)", Chr(10), "ALL")
	}

	private string function _getHtmlFilePath( required any page, required string buildDirectory ) {
		if ( arguments.page.getPath() == "/home" ) {
			return arguments.buildDirectory & "/index.html";
		}

		return arguments.buildDirectory & arguments.page.getPath() & ".html";
	}

	private void function _writeMarkdownPage( required any page, required string buildDirectory, required string markdownContent, required any docTree ) {
		var filePath      = _getMarkdownFilePath( arguments.page, arguments.buildDirectory );
		var fileDirectory = GetDirectoryFromPath( filePath );

		lock name="CreateDirectory" timeout=10 {
			if ( !DirectoryExists( fileDirectory ) ) {
				DirectoryCreate( fileDirectory );
			}
		}

		FileWrite( filePath, arguments.markdownContent );

		// Set last modified date from git for recipes
		var recipeDates = arguments.docTree.getRecipeDates();
		var pageId = arguments.page.getId();
		if ( structKeyExists( recipeDates, pageId ) ) {
			FileSetLastModified( filePath, recipeDates[pageId] );
		}
	}

	private string function _getMarkdownFilePath( required any page, required string buildDirectory ) {
		if ( arguments.page.getPath() == "/home" ) {
			return arguments.buildDirectory & "/index.md";
		}

		return arguments.buildDirectory & arguments.page.getPath() & ".md";
	}


	private void function _copyStaticAssets( required string buildDirectory ) {
		updateHighlightsCss( arguments.buildDirectory );
		var subdirs = directoryList(path=GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/assets", type="dir", recurse="false");
		for (var subdir in subdirs){
			var dirName = listLast(subdir, "/\");
			if (dirName neq "node_modules" and dirName neq "sass" and left(dirName,1) neq "."){
				DirectoryCopy(subdir, arguments.buildDirectory & "/assets/" & dirName, true );
			}
		}
	}

	private function updateHighlightsCss( required string buildDirectory ){
		var highlighter = new api.rendering.Pygments();
		var cssFile = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/assets/css/highlight.css";
		var css = highlighter.getCss();
		if ( trim( css ) neq trim( fileRead( cssFile ) ) )
			fileWrite( cssFile, highlighter.getCss() ); // only update if changed
	}

	private void function _copySiteImages( required string buildDirectory, required any docTree ) {
		DirectoryCopy(arguments.docTree.getRootDir() & "/_images", arguments.buildDirectory & "/images", true, "*", true  );
	}

	private void function _renderStaticPages( required string buildDirectory, required any docTree, required string baseHref ) {
		var staticPagesDir = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/staticPages";
		var _404Page = _renderStaticPage( staticPagesDir & "/404.html", "404 - Page not found", arguments.docTree, arguments.baseHref, true );
		FileWrite( arguments.buildDirectory & "/404.html", cleanHtml( _404Page ) );

		var _searchPage = _renderStaticPage( staticPagesDir & "/search.html", "Search Lucee Documentation", arguments.docTree, arguments.baseHref, true );
		FileWrite( arguments.buildDirectory & "/search.html", cleanHtml( _searchPage ) );
		FileWrite( arguments.buildDirectory & "/sitemap.xml", _renderSiteMap( arguments.docTree ) );
		// google analytics for @zackster
		FileWrite( arguments.buildDirectory & "/google4973ccb67f78b874.html", "google-site-verification: google4973ccb67f78b874.html");
		FileWrite( arguments.buildDirectory & "/robots.txt", [
				"User-agent: *",
				"Disallow: /dictionaries/",
				"Disallow: /editor.html",
				"Sitemap: https://docs.lucee.org/sitemap.xml"
			].toList(chr(10))
		);

		FileCopy( GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/assets/trycf/index.html", arguments.buildDirectory & "/editor.html" );
	}

	private void function _writeSearchIndex( required any docTree, required string buildDirectory ) {
		var searchIndexFile = arguments.buildDirectory & "/assets/js/searchIndex.json";

		FileWrite( searchIndexFile, renderSearchIndex( arguments.docTree ) );
	}

	private string function _getPageLayoutFile( required any page ) {
		switch( arguments.page.getPageType() ) {
			case "function":
			case "tag":
			case "category":
			case "_object":
			case "_method":
				return LCase( arguments.page.getPageType() );
			case "listing":
				return "aToZIndex"; // todo, diff layouts depending on arguments.page.getListingStyle()
			case "implementationStatus":
				return "implementationStatus";
			case "changeLog":
				return "changelog";
			default:
				return "page";
		}
	}

	private string function _renderStaticPage( required string filePath, required string pageTitle,
			required any docTree, required string baseHref, boolean noIndex="false"){
		var renderedPage = FileRead( arguments.filePath );
		var crumbs = [];
		//var links = [];

		return renderTemplate(
			  template = "layouts/static.cfm"
			, helpers  = "/builders/html/helpers"
			, args     = {
				  body       = Trim( renderedPage )
				, baseHref   = arguments.baseHref
				, noIndex    = arguments.noIndex
				, title      = arguments.pageTitle
				, filepath   = arguments.filePath
				, crumbs     = renderTemplate( template="layouts/staticbreadcrumbs.cfm", helpers  = "/builders/html/helpers",
					args={ title=arguments.pageTitle }
				)
				, navTree    = renderTemplate( template="layouts/sideNavTree.cfm", helpers  = "/builders/html/helpers", args={
					crumbs=crumbs, docTree=arguments.docTree, pageLineage=[ "/home" ], pageLineageMap ={"/home":""}
				} )
			  }
		);
	}

	private string function _renderSiteMap( required any docTree ) {
		var pages           = arguments.docTree.getPathMap();
		var siteMap     = [];

		for( var path in pages ) {
			siteMap.append('<url><loc>#XmlFormat("https://docs.lucee.org#path#.html")#</loc>'
			& '<lastmod>#dateFormat(now(),"yyyy-mm-dd")#</lastmod></url>');
		}

		return '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">#chr(10)#' &
			ArrayToList(siteMap, chr(10) ) & '#chr(10)#</urlset>';
	}

	public string function renderLink( any page, required string title, struct args={}, boolean markdown=false ) {
		if ( IsNull( arguments.page ) ) {
			if ( arguments.title.left( 4 ) eq "http" ){
				if ( arguments.markdown ) {
					return "[#arguments.title#](#arguments.title#)";
				}
				return '<a href="#arguments.title#">#HtmlEditFormat( arguments.title )#</a>';
			} else {
				request.logger( text="Missing docs link: [[#HtmlEditFormat( arguments.title )#]]", type="WARN" );
				if ( arguments.markdown ) {
					return "**#arguments.title#**";
				}
				return '<a class="missing-link" title="missing link">#HtmlEditFormat( arguments.title )#</a>';
			}
		}

		var extension = arguments.markdown ? ".md" : ".html";
		var link = arguments.page.getPath() & extension;

		// For markdown, use relative paths
		if ( arguments.markdown && structKeyExists( arguments.args, "page" ) ) {
			link = _calculateRelativePath( arguments.args.page.getPath(), arguments.page.getPath() ) & extension;
		} else if ( structKeyExists( arguments.args, "htmlOpts" )
				&& structKeyExists( arguments.args.htmlOpts, "base_href" ) ){
			link = arguments.args.htmlOpts.base_href & link;
		}

		if ( arguments.markdown ) {
			return "[#arguments.title#](#link#)";
		}
		return '<a href="#link#">#HtmlEditFormat( arguments.title )#</a>';
	}

	private string function _calculateRelativePath( required string fromPath, required string toPath ) {
		// Handle home page specially
		if ( arguments.fromPath == "/home" ) {
			arguments.fromPath = "/";
		}
		if ( arguments.toPath == "/home" ) {
			arguments.toPath = "/";
		}

		// Split paths into parts (excluding filename)
		var fromParts = listToArray( arguments.fromPath, "/" );
		var toParts = listToArray( arguments.toPath, "/" );

		// If they're in the same directory, just use the filename
		if ( arrayLen( fromParts ) == arrayLen( toParts ) ) {
			var samePath = true;
			for ( var i = 1; i < arrayLen( fromParts ); i++ ) {
				if ( fromParts[i] != toParts[i] ) {
					samePath = false;
					break;
				}
			}
			if ( samePath ) {
				return listLast( arguments.toPath, "/" );
			}
		}

		// Find common prefix
		var commonLength = 0;
		var minLength = min( arrayLen( fromParts ) - 1, arrayLen( toParts ) - 1 );
		for ( var i = 1; i <= minLength; i++ ) {
			if ( fromParts[i] == toParts[i] ) {
				commonLength = i;
			} else {
				break;
			}
		}

		// Build relative path
		var relativeParts = [];

		// Go up from current location (exclude the filename itself)
		var upLevels = arrayLen( fromParts ) - 1 - commonLength;
		for ( var i = 1; i <= upLevels; i++ ) {
			arrayAppend( relativeParts, ".." );
		}

		// Go down to target location
		for ( var i = commonLength + 1; i <= arrayLen( toParts ); i++ ) {
			arrayAppend( relativeParts, toParts[i] );
		}

		return arrayToList( relativeParts, "/" );
	}

	public string function _getIssueTrackerLink(required string name) {
		var link = Replace( new api.build.BuildProperties().getIssueTrackerLink(), "{search}", urlEncodedFormat(arguments.name) )
		return '<a href="#link#" class="no-oembed" target="_blank">Search Issue Tracker <i class="fa fa-external-link"></i></a>';
	}

	public string function _getTestCasesLink(required string name) {
		var link = Replace( new api.build.BuildProperties().getTestCasesLink(), "{search}", urlEncodedFormat(arguments.name) )
		return '<a href="#link#" class="no-oembed" target="_blank">Search Lucee Test Cases <i class="fa fa-external-link"></i></a> (good for further, detailed examples)';
	}


}
