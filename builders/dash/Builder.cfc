component extends="builders.html.Builder" {

// PUBLIC API
	public void function build( required any docTree, required string buildDirectory, required numeric threads) {
		var docsetRoot    = arguments.buildDirectory & "/lucee.docset/";
		var contentRoot   = docsetRoot & "Contents/";
		var resourcesRoot = contentRoot & "Resources/";
		var docsRoot      = resourcesRoot & "Documents/";
		var ignorePages   = { "download": true };

		var pagePaths = arguments.docTree.getPageCache().getPages();
		request.filesWritten = 0;
		request.filesToWrite = StructCount(pagePaths);
		request.logger (text="Builder DASH directory: #arguments.buildDirectory#");

		if ( !DirectoryExists( arguments.buildDirectory ) ) { DirectoryCreate( arguments.buildDirectory ); }
		if ( !DirectoryExists( docsetRoot               ) ) { DirectoryCreate( docsetRoot               ); }
		if ( !DirectoryExists( contentRoot              ) ) { DirectoryCreate( contentRoot              ); }
		if ( !DirectoryExists( resourcesRoot            ) ) { DirectoryCreate( resourcesRoot            ); }
		if ( !DirectoryExists( docsRoot                 ) ) { DirectoryCreate( docsRoot                 ); }

		new api.parsers.ParserFactory().getMarkdownParser(); // so the parser in use shows up in logs

		try {
			_setupSqlLite( resourcesRoot );
			_setAutoCommit(false);
			//for ( var path in pagePaths ) {
			each(pagePaths, function(path){
				if ( !ignorePages.keyExists( pagePaths[arguments.path].page.getId() ) ) {
					_writePage( pagePaths[arguments.path].page, buildDirectory & "/", docTree );
					request.filesWritten++;
					if ((request.filesWritten mod 100) eq 0)
						request.logger("Rendering Documentation (#request.filesWritten# / #request.filesToWrite#)");
					_storePageInSqliteDb( pagePaths[arguments.path].page );
				}
			}, (arguments.threads > 1), arguments.threads);
			//}
			_setAutoCommit(true);
		} catch ( any e ) {
			rethrow;
		} finally {
			_closeDbConnection();
		}
		request.logger (text="Dash Builder #request.filesWritten# files produced");
		_copyResources( docsetRoot );
		_renameSqlLiteDb( resourcesRoot );
		_setupFeedXml( arguments.buildDirectory & "/" );
	}

	public string function renderLink( any page, required string title ) {

		if ( IsNull( arguments.page ) ) {
			return '<a class="missing-link">#HtmlEditFormat( arguments.title )#</a>';
		}

		var link = arguments.page.getId() & ".html";

		return '<a href="#link#">#HtmlEditFormat( arguments.title )#</a>';
	}

// PRIVATE HELPERS
	private string function _getHtmlFilePath( required any page, required string buildDirectory ) {
		if ( arguments.page.getPath() == "/home" ) {
			return arguments.buildDirectory & "/index.html";
		}

		return arguments.buildDirectory & arguments.page.getId() & ".html";
	}

	private void function _copyResources( required string rootDir ) {
		FileCopy( "/builders/dash/resources/Info.plist", arguments.rootDir & "Contents/Info.plist" );
		FileCopy( "/builders/dash/resources/icon.png", arguments.rootDir & "icon.png" );
		DirectoryCopy( "/builders/html/assets/css/", arguments.rootDir & "Contents/Resources/Documents/assets/css", true, "*", true );
		DirectoryCopy( "/builders/html/assets/images/", arguments.rootDir & "Contents/Resources/Documents/assets/images", true, "*", true );
		DirectoryCopy( "/docs/_images/", arguments.rootDir & "Contents/Resources/Documents/images", true, "*", true );
	}

	private void function _setupSqlLite( required string rootDir ) {
		variables.sqlite = _getSqlLiteCfc();
		variables.dbFile = sqlite.createDb( dbName="docSet", destDir=arguments.rootDir & "/" );
		variables.dbConnection  = sqlite.getConnection( dbFile );

		variables.sqlite.executeSql( dbFile, "CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT)", false, variables.dbConnection );
		variables.sqlite.executeSql( dbFile, "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path)", false, variables.dbConnection );
	}

	private any function _getSqlLiteCfc() {
		return new api.sqlitecfc.SqliteCFC(
			  tempdir        = ExpandPath( "/api/sqlitecfc/tmp/" )
			, libdir         = ExpandPath( "/api/sqlitecfc/lib/" )
			, model_path     = "/api/sqlitecfc"
			, dot_model_path = "api.sqlitecfc"
		);
	}

	private void function _storePageInSqliteDb( required any page ) {
		var data = {};

		switch( arguments.page.getPageType() ){
			case "function":
				data = { name=arguments.page.getTitle(), type="Function" };
				break;
			case "tag":
				data = { name="cf" & arguments.page.getSlug(), type="Tag" };
				break;
			case "_object":
				data = { name=arguments.page.getTitle(), type="Object" };
				break;
			case "_method":
				data = { name=arguments.page.getTitle(), type="Method" };
				break;
			case "category":
				data = { name=Replace( arguments.page.getTitle(), "'", "''", "all" ), type="Category" };
				break;
			default:
				data = { name=Replace( arguments.page.getTitle(), "'", "''", "all" ), type="Guide" };
		}

		data.path = arguments.page.getId() & ".html";

		variables.sqlite.executeSql( variables.dbFile, "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#data.name#', '#data.type#', '#data.path#')", false, variables.dbConnection );
	}

	private void function _closeDbConnection() {
		if ( StructKeyExists( variables, "dbConnection" ) ) {
			dbConnection.close();
		}
	}

	private void function _setAutoCommit(required boolean autoCommit) {
		if ( StructKeyExists( variables, "dbConnection" ) ) {
			variables.dbConnection.setAutoCommit(arguments.autocommit);
		} else {
			throw message="_setAutoCommit: no active sqlLite dbConnection";
		}
	}

	private void function _renameSqlLiteDb( required string rootDir ) {
		FileMove( arguments.rootDir & "docSet.db", arguments.rootDir & "docSet.dsidx" );
	}

	private void function _setupFeedXml( required string rootDir ) {
		var feedXml = FileRead( "/builders/dash/resources/feed.xml" );
		var buildProps = new api.build.BuildProperties();

		feedXml = Replace( feedXml, "{url}"    , buildProps.getDashDownloadUrl(), "all" );
		feedXml = Replace( feedXml, "{version}", buildProps.getDashBuildNumber(), "all" );

		FileWrite( arguments.rootDir & "lucee.xml", feedXml );

	}
}