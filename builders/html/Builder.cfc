component {
	public string function renderLink( required any page, required string title ) {

		if ( IsNull( arguments.page ) ) {
			return '<a class="missing-link">#HtmlEditFormat( arguments.title )#</a>';
		}

		var link = ReReplace( page.getPath(), "^/", "" ) & ".html";

		return '<a href="#link#">#HtmlEditFormat( arguments.title )#</a>';
	}

	public void function build( docTree, buildDirectory ) {
		var tree = docTree.getTree();

		for( var page in tree ) {
			_writePage( page, arguments.buildDirectory, docTree );
		}

		_copyStaticAssets( arguments.buildDirectory );
	}

	public string function renderPage( required any page, required any docTree ){
		var renderedPage = renderTemplate(
			  template = "templates/#_getPageLayoutFile( arguments.page )#.cfm"
			, args     = { page = arguments.page, docTree=arguments.docTree }
		);
		var crumbs = [];
		var parent = arguments.page.getParent();

		while( !IsNull( parent ) ) {
			crumbs.prepend( parent.getId() );
			parent = parent.getParent();
		}

		return renderTemplate(
			  template = "layouts/main.cfm"
			, args     = {
				  body    = Trim( renderedPage )
				, page    = arguments.page
				, crumbs  = renderTemplate( template="layouts/breadcrumbs.cfm", args={ crumbs=crumbs, page=arguments.page } )
				, navTree = renderTemplate( template="layouts/sideNavTree.cfm", args={ crumbs=crumbs, docTree=arguments.docTree, pageLineage=arguments.page.getLineage() } )
				, seeAlso = renderTemplate( template="layouts/seeAlso.cfm", args={ links=arguments.page.getRelated() } )
			  }
		);
	}

// PRIVATE HELPERS
	private void function _writePage( required any page, required string buildDirectory, required any docTree ) {
		var filePath      = _getHtmlFilePath( arguments.page, arguments.buildDirectory );
		var fileDirectory = GetDirectoryFromPath( filePath );

		if ( !DirectoryExists( fileDirectory ) ) {
			DirectoryCreate( fileDirectory );
		}

		FileWrite( filePath, renderPage( arguments.page, arguments.docTree ) );

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
		DirectoryCopy( GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/assets", arguments.buildDirectory & "/assets", true );
	}

	private string function _getPageLayoutFile( required any page ) {
		switch( arguments.page.getPageType() ) {
			case "function":
			case "tag":
			case "category":
				return LCase( arguments.page.getPageType() );

			case "listing":
				return "aToZIndex"; // todo, diff layouts depending on arguments.page.getListingStyle()
		}

		return "page";
	}

}