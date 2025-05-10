component {

	public any function init() {
		variables.prettyPrinter = getJsonPrettyPrinter();
		return this;
	}

	public void function build( required any docTree, required string buildDirectory, required numeric threads) {
		var pagePaths = arguments.docTree.getPageCache().getPages();

		variables.cfdocsPath = arguments.buildDirectory;
		variables.HtmlBuildRoot = getHtmlBuildDir( arguments.buildDirectory );

		if ( directoryExists( variables.cfdocsPath) )
			directoryDelete( variables.cfdocsPath, true ); // clean slate
		directoryCreate( variables.cfdocsPath  );

		request.filesWritten = 0;
		request.filesToWrite = StructCount(pagePaths);

		request.logger (text="CFDOCS JSON Format directory: #arguments.buildDirectory#");

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
						arrayAppend( tags, "cf" & _page.getName() );
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

		var zipFilename = "lucee-docs-json.zip";
		var doubleZipFilename = "lucee-docs-json-zipped.zip";

		// neat trick, storing then zipping the stored zip reduces the file size from 496 Kb to 216 Kb
		zip action="zip"
			source="#variables.cfdocsPath#"
			file="#variables.cfdocsPath#/lucee-docs-json-store.zip"
			compressionmethod="store"
			recurse="false"
			filter="*.json";

		zip action="zip"
			source="#variables.cfdocsPath#"
			file="#variables.cfdocsPath#/#doubleZipFilename#"
			compressionmethod="deflateUtra" // typo in cfzip!
			recurse="false" {
				zipparam entrypath="#zipFilename#" source="#variables.cfdocsPath#/lucee-docs-json-store.zip";
		};
		fileDelete("#variables.cfdocsPath#/lucee-docs-json-store.zip");

		zip action="zip"
			source="#variables.cfdocsPath#"
			file="#variables.cfdocsPath#/#zipFilename#"
			recurse="false"
			filter="*.json";

		publishWithChecksum("#variables.cfdocsPath#/#zipFilename#",
				"#variables.HtmlBuildRoot#/#zipFilename#");
		publishWithChecksum("#variables.cfdocsPath#/#doubleZipFilename#",
				"#variables.HtmlBuildRoot#/#doubleZipFilename#");

		request.filesWritten +=8;
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
		if ( ( fn.getPageType() == "tag" ) )
			data["name"] = "cf" & fn.getName();
		else
			data["name"] = fn.getName();
		data["type"] = fn.getPageType();
		data["returns"] = lcase((fn.getPageType() == "tag") ? "void" : fn.getReturnType());
		data["description"] = fn.getDescription();

		data["engines"] = {
			"lucee": {
				"docs": "https://docs.lucee.org/reference/"
					& ( fn.getPageType() == "tag" ? "tags" : "functions" )
					& "/#lcase(fn.getName())#.html"
			}
		};
		if ( fn.getIntroduced() gt 0){
			data.engines.lucee["minimum_version"] = fn.getIntroduced();
		} else {
			data.engines.lucee["minimum_version"] = "";
		}
		if ( fn.getUsageNotes() gt 0 ){
			data.engines.lucee["notes"] = fn.getUsageNotes()
		}
		data["params"] = [];
		var required = [];
		var optional = [];
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
				arrayAppend( required, a.type & " " & a.name );
			else
				arrayAppend( optional, "[" & a.type & " " & a.name & "]" );
			arg["description"] = a.description;
			if (! isNull( a.default ) )
				arg["default"] = a.default;
			arg["type"] = lcase(a.type);
			if ( structKeyExists( a, "introduced") && len( a.introduced ) gt 0)
				arg["minimum_version"] = a.introduced;
			arrayAppend( data["params"], arg );
		}
		if ( fn.getPageType() == "tag" ){
			var jsonfile = variables.cfdocsPath & "/cf" & lcase( fn.name ) & ".json";
			if ( len( required ) eq 0 ) {
				data["syntax"] = "<cf" & fn.name & "/>";
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
			var jsonfile = variables.cfdocsPath & "/" & lcase( fn.name ) & ".json";
			var args = ArrayToList( required, ", " );
			if ( len ( optional ) ){
				if (len( args ) )
					args &= ", ";
				args &= ArrayToList( optional, ", " );
			}
			if ( len( args ) ){
				data["syntax"] = fn.name & "( " & args & " )";
			} else {
				data["syntax"] = fn.name & "()";
			}
		}
		if ( FileExists( jsonfile ) )
			throw "File conflict [#jsonfile#] already exists!";
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

	function getHtmlBuildDir( buildDirectory ){
		return left( arguments.buildDirectory, len( arguments.buildDirectory ) - len( "cfdocs" ) ) & "html";
	}

	function publishWithChecksum( src, dest ){
		request.logger (text="CFDOCS Builder copying zip to #dest#");
		fileCopy( src, dest );
		loop list="md5,sha1" item="local.hashType" {
			var checksumPath = left( dest, len( dest ) - 3 ) & hashType;
			filewrite( checksumPath, lcase( hash( fileReadBinary( arguments.src ), hashType ) ) );
			request.logger (text="CFDOCS Builder added #checksumPath# checksum");
		}
	}

}
