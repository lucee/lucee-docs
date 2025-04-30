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

		var simpleBuildDirectory = arguments.buildDirectory & "Basic";

		// purge previous build directory contents
		loop array="#[buildDirectory, simpleBuildDirectory]#" item="local.dir" {
			if ( directoryExists( dir ) )
				DirectoryDelete(dir, true);
			directoryCreate( dir );
		}
		request.logger (text="Builder HTML directory: #arguments.buildDirectory#");
		request.logger (text="Builder Simple HTML directory: #simplebuildDirectory#");

		new api.parsers.ParserFactory().getMarkdownParser(); // so the parser in use shows up in logs

		//for ( var path in pagePaths ) {
		each(pagePaths, function(path){
			var tick = getTickCount();
			var page = pagePaths[ arguments.path ].page;
			// write out full html page
			var pageContent = renderPageContent( page, docTree, false, {} );
			_writePage( page, buildDirectory, docTree, pageContent, {} );

			// write out reduced stripped down basic html page with no navigation etc
			var basicArgs = {
				//"no_css": true,
				"no_google_analytics": true,
				"no_navigation": true,
				"mainTemplate": "main_basic.cfm",
				"base_href": _calcRelativeBaseHref( page, simpleBuildDirectory )
			}; 
			if (pagePaths[arguments.path].page.isPage()) {
				var basicPageContent = renderPageContent( page, docTree, false, basicArgs );
				_writePage( page, simpleBuildDirectory, docTree, basicPageContent, basicArgs );
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

		_copyStaticAssets( simpleBuildDirectory);
		_zipBasicPages( arguments.buildDirectory, simpleBuildDirectory, "lucee-docs-basic" );
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

	private string function _calcRelativeBaseHref( required any page, required string buildDirectory ) {
		var path = arguments.page.getPath();
		var depth = listLen( path, "/" );
		if ( depth eq 1)
			return "";
		var baseHref = [];
		loop times="#depth-1#" {
			arrayAppend(baseHref, "..");
		}
		return ArrayToList(baseHref, "/");
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

	public string function renderLink( any page, required string title, required struct args ) {
		if ( IsNull( arguments.page ) ) {
			if (arguments.title.left(4) eq "http"){
				return '<a href="#arguments.title#">#HtmlEditFormat( arguments.title )#</a>';
			} else {
				request.logger (text="Missing docs link: [[#HtmlEditFormat( arguments.title )#]]", type="WARN");
				return '<a class="missing-link" title="missing link">#HtmlEditFormat( arguments.title )#</a>';
			}
		}
		var link = arguments.page.getPath() & ".html";
		if (!structKeyExists( args, "htmlOpts" ) ){
			SystemOutput(structKeyList(args), true);
			throw "zac";
		}
		//if ( arguments.page.getPath() contains "ormFlush" )	SystemOutput(args, true);
		if ( structKeyExists( args, "htmlOpts" )
				&& structKeyExists( args.htmlOpts, "base_href" ) ){
			link = args.htmlOpts.base_href & link;
		}

		return '<a href="#link#">#HtmlEditFormat( arguments.title )#</a>';
	}

	public string function _getIssueTrackerLink(required string name) {
		var link = Replace( new api.build.BuildProperties().getIssueTrackerLink(), "{search}", urlEncodedFormat(arguments.name) )
		return '<a href="#link#" class="no-oembed" target="_blank">Search Issue Tracker <i class="fa fa-external-link"></i></a>';
	}

	public string function _getTestCasesLink(required string name) {
		var link = Replace( new api.build.BuildProperties().getTestCasesLink(), "{search}", urlEncodedFormat(arguments.name) )
		return '<a href="#link#" class="no-oembed" target="_blank">Search Lucee Test Cases <i class="fa fa-external-link"></i></a> (good for further, detailed examples)';
	}

	public function _zipBasicPages( buildDirectory, simpleBuildDirectory, zipName ){

		var zipFilename = arguments.zipName & ".zip";
		var doubleZipFilename = arguments.zipName & "-zipped.zip";

		// neat trick, storing then zipping the stored zip reduces the file size from 496 Kb to 216 Kb
		var tempStoredZip = getTempFile( "", "#zipfileName#-store", "zip" );
		var tempDoubleZip = getTempFile( "", "#zipfileName#-normal", "zip" );
		var tempNormalZip = getTempFile( "", "#zipfileName#-normal", "zip" );

		zip action="zip"
			source="#arguments.simpleBuildDirectory#"
			file="#tempStoredZip#"
			compressionmethod="store"
			recurse="true";

		zip action="zip"
			source="#arguments.simpleBuildDirectory#"
			file="#tempDoubleZip#"
			compressionmethod="deflateUtra" // typo in cfzip!
			recurse="false" {
				zipparam entrypath="#zipFilename#" source="#tempStoredZip#";
		};
		fileDelete( tempStoredZip );

		zip action="zip"
			source="#arguments.simpleBuildDirectory#"
			file="#tempNormalZip#"
			recurse="true";

		publishWithChecksum( tempNormalZip, "#buildDirectory#/#zipFilename#" );
		publishWithChecksum( tempDoubleZip, "#buildDirectory#/#doubleZipFilename#" );
	};

	function publishWithChecksum( src, dest ){
		request.logger (text="Builder copying zip to #dest#");
		fileCopy( src, dest );
		loop list="md5,sha1" item="local.hashType" {
			var checksumPath = left( dest, len( dest ) - 3 ) & hashType;
			filewrite( checksumPath, lcase( hash( fileReadBinary( arguments.src ), hashType ) ) );
			request.logger (text="Builder added #checksumPath# checksum");
		}
	}

}
