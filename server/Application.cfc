		component {
	this.name = "luceeDocumentationLocalServer-" & Hash( GetCurrentTemplatePath() );

	this.cwd     = GetDirectoryFromPath( GetCurrentTemplatePath() )
	this.baseDir = ExpandPath( this.cwd & "../" );

	this.mappings[ "/api"      ] = this.baseDir & "api";
	this.mappings[ "/builders" ] = this.baseDir & "builders";
	this.mappings[ "/builds"   ] = this.baseDir & "builds";
	this.mappings[ "/docs"     ] = this.baseDir & "docs";
	this.mappings[ "/listener" ] = this.baseDir;

	public void function onApplicationStart()  {
		//_addChangeWatcher();				
	}

	public void function onApplicationEnd()  {
		//_removeChangeWatcher()
	}
	
	public boolean function onRequest( required string requestedTemplate ) output=true {
		var path = _getRequestUri();

		if (path contains ".."){
			header statuscode=401;
			abort;
		}	

		if ( path eq "/assets/js/searchIndex.json" ) {
			_renderSearchIndex();
		} elseif ( path.startsWith( "/assets" ) ) {
			_renderAsset();
		} elseif ( path.startsWith( "/static" ) ) {
				_renderStatic();	
		} elseif ( path.startsWith( "/editor.html" ) ) {
			_renderCodeEditor();
		} else {
			lock name="renderPage" timeout="8" type ="Exclusive" throwontimeout="no" { 
				if ( path.startsWith( "/source" ) ) {
					_renderSource();			
				} else {
					_renderPage();				
				}
			}
		}
		return true;
	}

// PRIVATE
	private void function _renderPage() {
		var pagePath    = _getPagePathFromRequest();
		var buildRunner = _getBuildRunner(checkFiles = true);
		var docTree     = buildRunner.getDocTree();
		var page        = docTree.getPageByPath( pagePath );

		if ( IsNull( page ) ) {
			_404(pagePath, "/");
		}

		WriteOutput( buildRunner.getBuilder( "html" ).renderPage( page, docTree, true ) );
	}

	private void function _renderSource() {
		var isUpdateRequest = (cgi.request_method eq "POST");
		var buildRunner = _getBuildRunner(checkFiles = false); // no need to scan files
		var docTree     = buildRunner.getDocTree();
		var pagePath = Replace(_getRequestUri(), "/source", "");
		var page = docTree.getPageSource(pagePath);

		if (isUpdateRequest){
			param name="form.content" default="";
			param name="form.properties" default="";
			var props = {};
			if (structCount(page.properties) and len(form.properties) eq 0){
				// page had properties
				header statuscode=422;
				WriteOutput("Properties missing");
				abort;
			} else if (isJson(form.properties)){
				props = deserializeJSON(form.properties);
				if (structCount(page.properties) gt 0 and structCount(props) eq 0){
					header statuscode=422 statustext="Properties missing";
					WriteOutput("Page previously had properties defined");
					abort;
				}
			}
			var result = docTree.updatePageSource(pagePath, form.content, props);
			_resetBuildRunner(); // flag for update
			WriteOutput( serializeJSON(result) );
		} else {
			var pageSource = structNew("linked");
			pageSource["file"] = pagePath;
			pageSource["content"] = page.content;
			pageSource["properties"] = page.properties;
			if (structCount(page.properties)){
				pageSource["reference"] = {
					"categories": docTree.getCategories(),
					"pages": docTree.getPageIds()
				};
				pageSource["propertyTypes"] = page.types;
			} else {
				structDelete(page, "properties");
			}
			content type="application/json";
			WriteOutput( serializeJSON(pageSource) );
		}
	}

	private void function _renderAsset() {
		var assetPath = "/builders/html" & _getRequestUri();

		if ( !FileExists( assetPath ) ) {
			_404(assetPath, "/");
		}

		header name="cache-control" value="no-cache";
		content file=assetPath type=_getMimeTypeForAsset( assetPath );
		abort;
	}

	private void function _renderStatic() {
		var staticFile = listRest(_getRequestUri(), "/");
		if (len(staticFile) eq 0)
			staticFile = "index.html";

		var staticAssetPath = "/builds/html/" & staticFile ;

		if ( !FileExists( staticAssetPath ) ) {			
			_404(staticAssetPath, "/static/");			
		}

		header name="cache-control" value="no-cache";
		// TODO need to address hrefs due to removal of base hrefs links
		content file=staticAssetPath type=_getMimeTypeForAsset( staticAssetPath );
		abort;
	}

	private void function _renderCodeEditor() {
		var editorPath = "/builders/html/assets/trycf/index.html";
		var content    = FileRead( editorPath );

		content reset=true;echo(content);abort;
	}

	private void function _renderSearchIndex() {
		var buildRunner = _getBuildRunner(checkFiles = false);
		var docTree = buildRunner.getDocTree();
		var searchIndex = buildRunner.getBuilder( "html" ).renderSearchIndex( docTree );

		header name="cache-control" value="no-cache";
		content type="application/json" reset=true;
		writeOutput( searchIndex );
		abort;
	}

	private string function _getPagePathFromRequest() {
		var path = _getRequestUri();

		path = ReReplace( path, "\.html$", "" );

		if ( path == "/" || path == "/index" ) {
			path = "/home";
		}

 		return path;
	}

	private string function _getRequestUri() {
		return request[ "javax.servlet.forward.request_uri" ] ?: "/";
	}

	private void function _404(required string path, required string baseHref) {
		header statuscode=404;
		var reqType = listLast(arguments.path, ".");
		if (reqType eq "html" or arguments.path does not contain "."){
			var buildRunner = _getBuildRunner(checkFiles = false); // no need to scan files
			var docTree     = buildRunner.getDocTree();
			WriteOutput( buildRunner.getBuilder( "html" ).renderFileNotFound( arguments.path, docTree, arguments.baseHref ) );
			// add the editor to 404 pages
			WriteOutput('<script src="/assets/js/docsEditor.js" type="text/javascript"></script>');
			abort;
		} else {
			content reset="true" type="text/plain";
			writeOutput("File not found: #htmlEditFormat(arguments.path)#");
		}
		abort;
	}

	private string function _getMimeTypeForAsset( required string filePath ) {
		var extension = ListLast( filePath, "." );

		switch( extension ){
			case "css": return "text/css";
			case "js" : return "application/javascript";
			case "jpe": case "jpeg": case "jpg": return "image/jpg";
			case "png": return "image/png";
			case "gif": return "image/gif";
			case "svg": return "image/svg+xml";
			case "woff": return "font/x-woff";
			case "eot": return "application/vnd.ms-fontobject";
			case "otf": return "font/otf";
			case "ttf": return "application/octet-stream";
			case "html": return "text/html";
		}

		return "application/octet-stream";
	}

	private any function _getBuildRunner(required boolean checkfiles) {
		var appKey    = application.buildRunnerKey ?: "";
		if (appKey neq ""){
			if (application.keyExists( appKey ) and not checkfiles )
				return application[ appKey ];
		}
		var newAppKey = _calculateBuildRunnerAppKey(); //  scans and fingerprints the entire doc src dir (SLOW)
		if ( appKey != newAppKey || !application.keyExists( appKey ) ) {
			application.delete( appKey );
			application[ newAppKey ] = new api.build.BuildRunner();
			application.buildRunnerKey = newAppKey;
		}
		return application[ newAppKey ];
	}

	private string function _calculateBuildRunnerAppKey() {		
		var filesEtc = DirectoryList( "/docs", true, "query" ); // this can be slow
		var sig      = Hash( SerializeJson( filesEtc ) );
		return "buildrunner" & sig;
	}

	private void function _resetBuildRunner() {
		var appKey    = application.buildRunnerKey ?: "";
		if (application.keyExists( appKey ) ){
			application.delete( appKey );
			application.buildRunnerKey = "";
		}
	}

	private void function _addChangeWatcher(){
		var password 	= "lucee-docs";
		var admin       = new Administrator( "web", password );

		admin.updateGatewayEntry(
			startupMode="automatic",
			id="watchDocumentFilesForChange",
			class="",
			cfcpath="lucee.extension.gateway.DirectoryWatcher",			
			// this doesn't work, cfc must be under web-inf dir
			// listenerCfcPath="api.build.DocsDirectoryWatcherListener", 
			// i.e. WEB-INF\lucee-web\components\lucee\extension\gateway\docs
			listenerCfcPath="lucee.extension.gateway.Docs.DocsDirectoryWatcherListener", 
			custom='#{
				directory="#expandPath('/docs/')#"
				, recurse=true
				, interval=5000
				, extensions="*.md"
				, changeFunction="onAdd"
				, addFunction="onAdd"
				, deleteFunction="onDelete"
			}#',
			readOnly=false
		);
	}
	private void function _removeChangeWatcher(){
		var password	= "lucee-docs";
		var admin       = new Administrator( "web", password );
		admin.removeGatewayEntry(id="watchDocumentFilesForChange");
	}	

}