component {
	public string function renderReference( required any page ) {
		var link = ReReplace( page.getId(), "^/", "" ) & ".html";

		return '<a href="#link#">#page.getTitle()#</a>';
	}

	public void function build( docTree, buildDirectory ) {
		var tree = docTree.getTree();

		for( var page in tree ) {
			_writePage( page, arguments.buildDirectory );
		}

		_copyStaticAssets( arguments.buildDirectory );
	}

// PRIVATE HELPERS
	private void function _writePage( required any page, required string buildDirectory ) {
		var filePath      = arguments.buildDirectory & arguments.page.getId() & ".html";
		var fileDirectory = GetDirectoryFromPath( filePath );

		if ( !DirectoryExists( fileDirectory ) ) {
			DirectoryCreate( fileDirectory );
		}

		FileWrite( filePath, _renderPage( arguments.page ) );

		for( var childPage in arguments.page.getChildren() ) {
			_writePage( childPage, arguments.buildDirectory );
		}
	}

	private string function _renderPage( required any page ){
		var renderedPage = renderTemplate(
			  template = "templates/#page.getPageType()#.cfm"
			, args     = { page = arguments.page }
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
				  body   = Trim( renderedPage )
				, page   = arguments.page
				, crumbs = crumbs
			  }
		);
	}


	private void function _copyStaticAssets( required string buildDirectory ) {
		DirectoryCopy( GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/assets", arguments.buildDirectory & "/assets", true );
	}

}