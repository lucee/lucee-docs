component {
	public string function renderLink( any page, required string title ) {
		if ( IsNull( arguments.page ) ) {
			return '<a class="missing-link">#HtmlEditFormat( arguments.title )#</a>';
		}

		var link = ReReplace( page.getPath(), "^/", "" ) & ".html";

		return '<a href="#link#">#HtmlEditFormat( arguments.title )#</a>';
	}

	public string function _getIssueTrackerLink(required string name) {
		var link = Replace( new api.build.BuildProperties().getIssueTrackerLink(), "{search}", urlEncodedFormat(arguments.name) )
		return '<a href="#link#" target="_blank">Search Issue Tracker <i class="fa fa-external-link"></i></a>';
	}

	public void function build( docTree, buildDirectory ) {
		var tree = docTree.getTree();
		cflog(text="Builder html directory: #arguments.buildDirectory#");
		for( var page in tree ) {
			_writePage( page, arguments.buildDirectory, docTree );
		}

		_renderStaticPages( arguments.buildDirectory, arguments.docTree, "/" );
		_copyStaticAssets( arguments.buildDirectory );
		_writeSearchIndex( arguments.docTree, arguments.buildDirectory );
	}

	public string function renderPage( required any page, required any docTree, required boolean edit ){
		try {
			var renderedPage = renderTemplate(
				  template = "templates/#_getPageLayoutFile( arguments.page )#.cfm"
				, args     = { page = arguments.page, docTree=arguments.docTree, edit=edit }
				, helpers  = "/builders/html/helpers"
			);
		} catch( any e ) {
			e.additional.luceeDocsPageId = arguments.page.getid();
			rethrow;
		}	
		var crumbs = [];
		var excludeLinkMap = {}; // tracks links to exclude from See also
		var parent = arguments.page.getParent();
		var links = [];

		while( !IsNull( parent ) ) {
			//excludeLinkMap[parent.getId()]="";
			crumbs.prepend( parent.getId() );
			parent = parent.getParent();
		}

		if ( !IsNull( arguments.page.getCategories() ) ) {
			for( var category in arguments.page.getCategories() ) {
				if ( arguments.docTree.pageExists( "category-" & category ) ) {
					links.append( "[[category-" & category & "]]" );
				}
			}
		}

		var related = arguments.docTree.getPageRelated(arguments.page);
		for( var link in related ) {
			if (len(link) gt 0 and not StructKeyExists(excludeLinkMap, link))
				links.append( "[[" & link & "]]");
		}

		if ( len(arguments.page.getId()) gt 0){
			var name = listRest(arguments.page.getId(), "-");
			switch (arguments.page.getPageType()){
				case "tag":
					// add a cf prefix, tried adding with jql "OR & name" but that didn't work
					links.append( _getIssueTrackerLink("cf" & name ) );
					break;
				case "function":
					links.append( _getIssueTrackerLink(name) );
					break;
				default:
          break;
			}
		}

		return renderTemplate(
			  template = "layouts/main.cfm"
			, helpers  = "/builders/html/helpers"
			, args     = {
				  body       = Trim( renderedPage )
				, page       = arguments.page
				, edit       = arguments.edit
				, crumbs     = renderTemplate( template="layouts/breadcrumbs.cfm", helpers  = "/builders/html/helpers", args={ crumbs=crumbs, page=arguments.page } )
				, navTree    = renderTemplate( template="layouts/sideNavTree.cfm", helpers  = "/builders/html/helpers", args={ crumbs=crumbs, docTree=arguments.docTree, pageLineage=arguments.page.getLineage() } )
				, seeAlso    = renderTemplate( template="layouts/seeAlso.cfm"    , helpers  = "/builders/html/helpers", args={ links=links } )
			  }
		);
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
				, "type"    = page.getPageType()
				, "icon"    = icon
			} );
		}

		return SerializeJson( searchIndex );
	}

// PRIVATE HELPERS
	private void function _writePage( required any page, required string buildDirectory, required any docTree ) {
		var filePath      = _getHtmlFilePath( arguments.page, arguments.buildDirectory );
		var fileDirectory = GetDirectoryFromPath( filePath );
		//var starttime = getTickCount();
		if ( !DirectoryExists( fileDirectory ) ) {
			DirectoryCreate( fileDirectory );
		}
		var pageContent = renderPage( arguments.page, arguments.docTree, false );
		// regex strips left over whitespace multiple new lines
		pageContent = ReReplace(pageContent, "[\r\n]\s*([\r\n]|\Z)", Chr(10), "ALL")
		FileWrite( filePath, pageContent );
		//cflog(text="Finished page #arguments.page.getPath()# in #NumberFormat( getTickCount()-startTime)#ms");
		for( var childPage in arguments.page.getChildren() ) {
			_writePage( childPage, arguments.buildDirectory, arguments.docTree );
		}
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

	private void function _renderStaticPages( required string buildDirectory, required any docTree, required string baseHref ) {
		var staticPagesDir = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/staticPages";
		var _404Page = _renderStaticPage( staticPagesDir & "/404.html", "404 - Page not found", arguments.docTree, arguments.baseHref, true );

		FileWrite( buildDirectory & "/404.html", _404Page );
		FileCopy( GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/assets/trycf/index.html", buildDirectory & "/editor.html" );
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
				return LCase( arguments.page.getPageType() );
			case "listing":
				return "aToZIndex"; // todo, diff layouts depending on arguments.page.getListingStyle()
			default:
				return "page";	
		}
	}

	private string function _renderStaticPage( required string filePath, required string pageTitle, 
			required any docTree, required string baseHref, required boolean noIndex default false){
		var renderedPage = FileRead( arguments.filePath );
		var crumbs = [];
		//var links = [];

		return renderTemplate(
			  template = "layouts/static.cfm"
			, helpers  = "/builders/html/helpers"
			, args     = {
				  body       = Trim( renderedPage )
				, baseHref   = arguments.baseHref  
				, noIndex   = arguments.noIndex  
				, title      = arguments.pageTitle
				, crumbs     = renderTemplate( template="layouts/staticbreadcrumbs.cfm", helpers  = "/builders/html/helpers", args={ title=arguments.pageTitle } )
				, navTree    = renderTemplate( template="layouts/sideNavTree.cfm", helpers  = "/builders/html/helpers", args={ crumbs=crumbs, docTree=arguments.docTree, pageLineage=[ "/home" ] } )
			  }
		);
	}
}