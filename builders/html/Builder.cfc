component {
	public string function renderLink( any page, required string title ) {
		if ( IsNull( arguments.page ) ) {
			if (arguments.title.left(4) eq "http"){
				return '<a href="#arguments.title#">#HtmlEditFormat( arguments.title )#</a>';
			} else {
				request.logger (text="Missing docs link: [[#HtmlEditFormat( arguments.title )#]]", type="WARN");
				return '<a class="missing-link" title="missing link">#HtmlEditFormat( arguments.title )#</a>';
			}
		}
		var link = arguments.page.getPath() & ".html";
		return '<a href="#link#">#HtmlEditFormat( arguments.title )#</a>';
	}

	public string function _getIssueTrackerLink(required string name) {
		var link = Replace( new api.build.BuildProperties().getIssueTrackerLink(), "{search}", urlEncodedFormat(arguments.name) )
		return '<a href="#link#" class="no-oembed" target="_blank">Search Issue Tracker <i class="fa fa-external-link"></i></a>';
	}

	public void function build( required any docTree, required string buildDirectory, required numeric threads) {
		var pagePaths = arguments.docTree.getPageCache().getPages();

		request.filesWritten = 0;
		request.filesToWrite = StructCount(pagePaths);

		request.logger (text="Builder HTML directory: #arguments.buildDirectory#");

		new api.parsers.ParserFactory().getMarkdownParser(); // so the parser in use shows up in logs

		//for ( var path in pagePaths ) {
		each(pagePaths, function(path){
			var tick = getTickCount();
			_writePage( pagePaths[arguments.path].page, buildDirectory, docTree );

			request.filesWritten++;
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

	public string function renderPage( required any page, required any docTree, required boolean edit ){
		try {
			var renderedPage = renderTemplate(
				  template = "templates/#_getPageLayoutFile( arguments.page )#.cfm"
				, args     = { page = arguments.page, docTree=arguments.docTree, edit=arguments.edit }
				, helpers  = "/builders/html/helpers"
			);
		} catch( any e ) {
			e.additional.luceeDocsTitle = arguments.page.getTitle();
			e.additional.luceeDocsPath = arguments.page.getPath();
			e.additional.luceeDocsPageId = arguments.page.getid();
			rethrow;
		}
		var crumbs = arguments.docTree.getPageBreadCrumbs(arguments.page);
		var excludeLinkMap = {}; // tracks links to exclude from See also
		var links = [];
		var categories = [];

		if ( !IsNull( arguments.page.getCategories() ) ) {
			for( var category in arguments.page.getCategories() ) {
				if ( arguments.docTree.pageExists( "category-" & category ) ) {
					links.append( "[[category-" & category & "]]" );
					categories.append( "[[category-" & category & "]]" );
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
					break;
				case "function":
					links.append( variables._getIssueTrackerLink(name) );
					break;
				default:
          break;
			}
		}
		try {
			var pageContent = renderTemplate(
				template = "layouts/main.cfm"
				, helpers  = "/builders/html/helpers"
				, args     = {
					body       = Trim( renderedPage )
					, page       = arguments.page
					, edit       = arguments.edit
					, crumbs     = renderTemplate( template="layouts/breadcrumbs.cfm", helpers  = "/builders/html/helpers", args={ crumbs=crumbs, page=arguments.page, docTree=arguments.docTree, categories=categories.sort("textNoCase"), edit= arguments.edit } )
					, navTree    = renderTemplate( template="layouts/sideNavTree.cfm", helpers  = "/builders/html/helpers", args={
						crumbs=crumbs, docTree=arguments.docTree, pageLineage=arguments.page.getLineage(), pageLineageMap=arguments.page.getPageLineageMap()
					} )
					, seeAlso    = renderTemplate( template="layouts/seeAlso.cfm"    , helpers  = "/builders/html/helpers",
						args={ links=links } )
				}
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
				, "desc" = HtmlEditFormat( page.getTitle() & " " & page.getDescription() ) // used for indexing
				, "type"    = page.getPageType()
				, "icon"    = icon
			} );
		}

		return SerializeJson( searchIndex );
	}

// PRIVATE HELPERS
	private void function _writePage( required any page, required string buildDirectory, required any docTree ) {
		var filePath      = variables._getHtmlFilePath( arguments.page, arguments.buildDirectory );
		var fileDirectory = GetDirectoryFromPath( filePath );

		//var starttime = getTickCount();
		lock name="CreateDirectory" timeout=10 {
			if ( !DirectoryExists( fileDirectory ) ) {
				DirectoryCreate( fileDirectory );
			}
		}
		var pageContent = variables.cleanHtml(variables.renderPage( arguments.page, arguments.docTree, false ));
		FileWrite( filePath, pageContent );
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

	private void function _copyStaticAssets( required string buildDirectory ) {
		var subdirs = directoryList(path=GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/assets", type="dir", recurse="false");
		for (var subdir in subdirs){
			var dirName = listLast(subdir, "/\");
			if (dirName neq "node_modules" and dirName neq "sass" and left(dirName,1) neq "."){
				DirectoryCopy(subdir, arguments.buildDirectory & "/assets/" & dirName, true );
			}
		}
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
		FileWrite( arguments.buildDirectory & "/robots.txt", "User-agent: *#chr(10)#Disallow: /dictionaries/#chr(10)#Sitemap: https://docs.lucee.org/sitemap.xml");

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
}
