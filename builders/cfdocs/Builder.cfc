component {

	public any function init() {
		variables.cfdocsPath = expandPath("../builds/cfdocs/en");
		variables.prettyPrinter = getJsonPrettyPrinter();
		if ( !directoryExists( variables.cfdocsPath) )
			directoryCreate( variables.cfdocsPath );
		return this;
	}

	public void function build( required any docTree, required string buildDirectory, required numeric threads) {
		var pagePaths = arguments.docTree.getPageCache().getPages();

		request.filesWritten = 0;
		request.filesToWrite = StructCount(pagePaths);

		request.logger (text="CFDOCS HTML directory: #arguments.buildDirectory#");

		var tags = [];
		var functions = [];

		for ( var path in pagePaths ) {
		//each( pagePaths, function( path ) {
			var tick = getTickCount();
			var _page = pagePaths[ path ].page;
			if ( renderJson( pagePaths[ path ].page ) ){
				request.filesWritten++;
				switch ( _page.getPageType() ){
					case "tag":
						arrayAppend( tags, _page.getName() );
						break;
					case "function":
						arrayAppend( functions, _page.getName() );
						break;
				}
			}
			if ((request.filesWritten mod 50) eq 1){
				request.logger(text="Rendering CFDOCS (#request.filesWritten#) - only tags and functions");
			}
		//}, (arguments.threads > 1), arguments.threads);
		}

		renderIndex( tags, "Tags", "tags");
		renderIndex( functions, "Functions", "functions");
		var all = duplicate(tags);
		ArrayAppend(all, functions, true);
		renderIndex( all, "Tags and Functions", "all");

		request.logger (text="CFDOCS Builder #request.filesWritten# files produced");
	}

	public boolean function renderJson( page ){
		if ( len( arguments.page.getId() ) gt 0 ){
			var name = listRest( arguments.page.getId(), "-" );
			try {
				switch ( arguments.page.getPageType() ){
					case "tag":
						_render( arguments.page);
						return true;
					case "function":
						_render( arguments.page );
						return true;
					default:
						return false;
				}
			} catch( e ){
				dump(page);
				echo(e);
				abort;
			}
		}
		return false;
	}

	public function _render( func ){
		var fn = arguments.func;
		var data = [=];
		data["name"] = fn.getName();
		data["type"] = fn.getPageType();
		data["returns"] = (fn.getPageType() == "tag") ? "void" : fn.getReturnType();
		data["description"] = fn.getDescription();

		data["engines"] = {
			"lucee": {
				"docs": "https://docs.lucee.org/reference/functions/"
					& "#fn.getName()#.html"
			}
		};
		if ( fn.getIntroduced() gt 0){
			data.engines.lucee["minimum_version"] = left(fn.getIntroduced(), 3 );
		}
		if ( fn.getUsageNotes() gt 0 ){
			data.engines.lucee["notes"] = fn.getUsageNotes()
		}
		data["params"] = [];
		var required = [];
		if ( fn.getPageType() == "tag" )
			var params = fn.getAttributes();
		else
			var params = fn.getArguments();

		loop array="#params#" item="local.a" index="local.i" {
			var arg = [=];
			arg["name"] = a.name;
			if ( structKeyExists( a, "alias" ) && len( a.alias ) )
				arg["aliases"] = a.alias;
			arg["required"] = a.required;
			if ( a.required )
				arrayAppend( required, a.name );
			arg["description"] = a.description;
			if (! isNull( a.default ) )
				arg["default"] = a.default;
			arg["type"] = a.type;
			if ( structKeyExists( a, "introduced") && len( a.introduced ) gt 0)
				arg["minimum_version"] = left(a.type, 3);
			arrayAppend( data["params"], arg );
		}
		if ( fn.getPageType() == "tag" ){
			if ( len(required) eq 0 ) {
				data["syntax"] = "<" & fn.name & "/>";
			} else {
				var attrs = [];
				var att = fn.getAttributes();
				arrayEach( att, function( a ){
					if ( !a.required ) return;
					arrayAppend( attrs, '#a.name#=""');
				});
				data["syntax"] = "<" & fn.name & " "
					& ArrayToList( attrs, ", " ) & "/>";
			}
		} else {
			data["syntax"] = fn.name & "( " & ArrayToList( required, ", " ) & " )";
		}
		var jsonfile = variables.cfdocsPath & "/" & lcase(fn.name) & ".json";
		fileWrite( jsonFile, variables.prettyPrinter.prettyPrint( data ) );
		return true;
	}

	function renderIndex( array files, string type, string filename ){
		var indexListing = {
			"related": [],
			"description": "A listing of all CFML #arguments.type#.",
			"type": "listing",
			"name": "All CFML #arguments.type#"
		};
		ArraySort( files, "textnocase" );
		indexListing.related = files;
		var jsonfile = variables.cfdocsPath & "/" & lCase( filename ) & ".json";
		fileWrite( jsonFile, variables.prettyPrinter.prettyPrint( indexListing ) );
		
	}

	public function getJsonPrettyPrinter(){
		return new component javasettings='{
			"maven": ["org.json:json:20240303"]
		  }' {
			import org.json.JSONObject;
			function prettyPrint( jsonString ){
				var jsonObj = new JSONObject( jsonString );
				var str = jsonObj.toString( 4 );
				return str;
			}
		}
	}
	
}
