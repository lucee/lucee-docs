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
		var logger = new api.build.Logger();
		if (path contains ".."){
			header statuscode=401;
			abort;
		}
		var importThreads = 4;
		// pegdown doesn't work with parallel build, see MarkdownParser.cfc
		// see https://luceeserver.atlassian.net/browse/LD-109
		var buildThreads = 4;
		if ( path.startsWith( "/lucee/admin") ){
			request.logger (text="ignoring /lucee/admin request #cgi.script_name#");
			return;
		} else if ( path.startsWith( "/build_docs/" ) ){
			logger.enableFlush(true);
			setting requestTimeout=300;
			_renderBuildHeader(path);
			request.logger("Build: importThreads:#importThreads#, buildThreads: #buildThreads#");
			if ( path eq "/build_docs/all/" ) {
				new api.reference.ReferenceImporter(importThreads).importAll();
				new api.build.BuildRunner(buildThreads).buildAll(); // threads disabled for now
			} else if ( path eq "/build_docs/html/" ) {
				new api.build.BuildRunner().build(builderName="html", threads=buildThreads);
			} else if ( path eq "/build_docs/dash/" ) {
				new api.build.BuildRunner().build(builderName="dash", threads=buildThreads);
			} else if ( path eq "/build_docs/import/" ) {
				new api.reference.ReferenceImporter(importThreads).importAll();
			} else if ( path eq "/build_docs/spellCheck/" ) {
				new api.spelling.spellChecker().spellCheck();
			} else if ( path eq "/build_docs/cspell/" ) {
				new api.spelling.spellChecker().buildLuceeCSpell();
			} else {
				if (listlen(path,"/") gt 1 )
					writeOutput("unknown build docs request: #path#");
			}
			fileAppend("/performance.log", "#path# #numberFormat(getTickCount() - request.loggerStart)#ms, "
				& "#importThreads# import threads, #buildThreads# build threads, #server.lucee.version##chr(10)#");
			logger.renderLogs();
		} else if ( path eq "/assets/js/searchIndex.json" ) {
			_renderSearchIndex();
		} else if ( path.startsWith( "/assets" ) ) {
			_renderAsset();
		} else if ( path.startsWith( "/static" ) ) {
				_renderStatic();
		} else if ( path.startsWith( "/editor.html" ) ) {
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
		var buildRunner = _getBuildRunner();
		var docTree     = buildRunner.getDocTree();
		var page        = docTree.getPageByPath( pagePath );

		if ( IsNull( page ) ) {
			_404(pagePath, "/");
		}

		WriteOutput( buildRunner.getBuilder( "html" ).renderPage( page, docTree, true ) );
	}

	private void function _renderSource() {
		var isUpdateRequest = (cgi.request_method eq "POST");
		var buildRunner = _getBuildRunner(); // no need to scan files
		var docTree     = buildRunner.getDocTree();
		var pagePath = Replace(_getRequestUri(), "/source", "");
		var page = docTree.getPageSource(pagePath);

		setting showdebugoutput="no";
		if (isUpdateRequest){
			param name="form.content" default="";
			param name="form.properties" default="";
			param name="form.url";
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
			var result = docTree.updatePageSource(pagePath, form.content, props, form.url);
			//_resetBuildRunner(); // flag for update
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
		setting showdebugoutput="no";
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
		var pageContent = fileRead(staticAssetPath);
		pagecontent = reReplace(pagecontent, '\<a href="\/', '<a href="/static/', 'all');

		header name="cache-control" value="no-cache";
		setting showdebugoutput="no";

		content type=_getMimeTypeForAsset( staticAssetPath );
		writeOutput(pagecontent);
		abort;
	}

	private void function _renderCodeEditor() {
		var editorPath = "/builders/html/assets/trycf/index.html";
		var content    = FileRead( editorPath );
		setting showdebugoutput="no";
		content reset=true;echo(content);abort;
	}

	private void function _renderSearchIndex() {
		var buildRunner = _getBuildRunner();
		var docTree = buildRunner.getDocTree(checkFiles = false);
		var searchIndex = buildRunner.getBuilder( "html" ).renderSearchIndex( docTree );

		header name="cache-control" value="no-cache";
		setting showdebugoutput="no";
		content type="application/json" reset=true;
		writeOutput( searchIndex );
		abort;
	}

	private void function _renderBuildHeader(required string path) {
		var opts = structNew("linked");
		opts.home = {
			title: "Browse Local Documentation",
			menu: "Local Docs",
			href: "/"
		};
		opts.static = {
			title: "Browse Local Static Docs",
			menu: "Local Static",
			href: "/static/"
		};
		opts.prod = {
			title: "Browse Prod Docs",
			menu: "Prod",
			href: "http://docs.lucee.org/"
		};
		opts.git = {
			title: "Lucee Docs Git Repo",
			menu: "Git Repo",
			href: "https://github.com/lucee/lucee-docs"
		};
		opts.all = {
			title: "Importing references, Exporting Dash and HTML ",
			menu: "Build All"
		};
		opts.html = {
			title: "Exporting HTML",
			menu: "Build HTML"
		};
		opts.spellcheck = {
			title: "Spellchecking built HTML",
			menu: "Spell Check HTML"
		};
		opts.dash = {
			title: "Exporting Dash",
			menu: "Build Dash"
		};
		opts.import = {
			Menu: "Import References",
			title: "Importing References (tags, functions, options, methods)"
		};
		var textOnly = (url.KeyExists("textlogs") and url.textlogs );
		var selectedOption = listLast(arguments.path,"/");
		if (textOnly){ // nice for curl --trace http://localhost:4040/build_docs/all/
			writeOutput("#chr(10)#Lucee Documentation Builder - #server.lucee.version##chr(10)#");

			if (opts.keyExists(selectedOption))
				writeOutput("#opts[selectedOption].title##chr(10)##chr(10)#");
			setting showdebugoutput="false";
		} else {
			writeOutput("<h1>Lucee Documentation Builder - #server.lucee.version#</h1>");
			writeOutput('<style>.build-menu li { display: inline; list-style-type: none; padding-right: 10px;} ul, ol {padding-left:0;}</style>');
			writeOutput('<ul class="build-menu">');
			for (var link in opts){
				var _link = "/build_docs/#lCase(link)#/";
				var _target = "";
				if (opts[link].keyExists("href")){
					_link = opts[link].href;
					var _target = " target='_blank'";
				}
				writeOutput('<li><a href="#_link#" #_target# title="#htmlEditFormat(opts[link].title)#" >#htmlEditFormat(opts[link].menu)#</a></li>');
			}
			writeOutput('</ul><hr>');
			if (opts.keyExists(selectedOption))
				writeOutput("<h2>#opts[selectedOption].title#</h2>");
		}

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

	private any function _getBuildRunner() {
		var appKey    = "buildRunnerKey";
		if ( not application.keyExists( appKey ) ){
			request.logger("BuildRunner init");
			application.delete( appKey );
			application[ AppKey ] = new api.build.BuildRunner();
		}
		if (structKeyExists(url, "reload") && url.reload eq "true"){
			if (structKeyExists(url, "force") && url.force eq "true")
				application[ AppKey ] = new api.build.BuildRunner(); // dev mode
			application[ AppKey ].getDocTree(checkfiles=true); // scans for changes
		}
		return application[ AppKey ];
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