component {
	public string function renderLink( required any page, required string title ) {

		if ( IsNull( arguments.page ) ) {
			return '<a class="missing-link">#arguments.title#</a>';
		}

		var link = ReReplace( page.getId(), "^/", "" ) & ".html";

		return '<a href="#link#">#arguments.title#</a>';
	}

	public void function build( docTree, buildDirectory ) {
		var tree = docTree.getTree();

		for( var page in tree ) {
			_writePage( page, arguments.buildDirectory, docTree );
		}

		_copyStaticAssets( arguments.buildDirectory );
	}

// PRIVATE HELPERS
	private void function _writePage( required any page, required string buildDirectory, required any docTree ) {
		var filePath      = _getHtmlFilePath( arguments.page, arguments.buildDirectory );
		var fileDirectory = GetDirectoryFromPath( filePath );

		if ( !DirectoryExists( fileDirectory ) ) {
			DirectoryCreate( fileDirectory );
		}

		FileWrite( filePath, _renderPage( arguments.page, arguments.docTree ) );

		for( var childPage in arguments.page.getChildren() ) {
			_writePage( childPage, arguments.buildDirectory, arguments.docTree );
		}
	}

	private string function _getHtmlFilePath( required any page, required string buildDirectory ) {
		if ( arguments.page.getId() == "/home" ) {
			return arguments.buildDirectory & "/index.html";
		}

		return arguments.buildDirectory & arguments.page.getId() & ".html";
	}

	private string function _renderPage( required any page, required any docTree ){
		var renderedPage = renderTemplate(
			  template = "templates/#_getPageLayoutFile( arguments.page )#.cfm"
			, args     = { page = arguments.page }
		);
		var crumbs = [];
		var parent = arguments.page.getParent();

		while( !IsNull( parent ) ) {
			crumbs.prepend( parent.getSlug() );
			parent = parent.getParent();
		}

		return renderTemplate(
			  template = "layouts/main.cfm"
			, args     = {
				  body    = Trim( renderedPage )
				, page    = arguments.page
				, crumbs  = renderTemplate( template="layouts/breadcrumbs.cfm", args={ crumbs=crumbs, page=arguments.page } )
				, navTree = renderTemplate( template="layouts/sideNavTree.cfm", args={ crumbs=crumbs, docTree=arguments.docTree } )
				, seeAlso = renderTemplate( template="layouts/seeAlso.cfm", args={ links=arguments.page.getRelated() } )
			  }
		);
	}

	private void function _copyStaticAssets( required string buildDirectory ) {
		DirectoryCopy( GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/assets", arguments.buildDirectory & "/assets", true );
	}

	private string function _getPageLayoutFile( required any page ) {
		switch( arguments.page.getPageType() ) {
			case "function":
			case "tag":
				return LCase( arguments.page.getPageType() );

			case "listing":
				return "aToZIndex"; // todo, diff layouts depending on arguments.page.getListingStyle()
		}

		return "page";
	}

}