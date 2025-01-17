component accessors=true {
	property name="pages" type="struct";
    property name="rootDir"    type="string"; // top level folders

	public any function init( required string rootDirectory ) {
		setRootDir(arguments.rootDirectory);
        reset();
		return this;
	}

	public void function reset() {
        setPages(structNew("linked"));
	}

	public void function addPage( required any page, required any path ) {
		lock name="docsAddPageToCache" timeout=5 {
			variables.pages[arguments.path] = {
				page: arguments.page,
				updated: now()
			};
		}
	}

	public struct function getPathCache() {
		var paths = {};
		for (var path in variables.pages){
			paths[path] = variables.pages[path].updated;
		}
		return paths;
	}

	public void function reSort() {
		var paths = _sortArrayPageFilesByDepth( ListToArray(pages.keyList()) );

		var newPageCache = structNew("linked");
		for (var path in paths){
			newPageCache[path] = pages[path];
		}
		setPages(newPageCache);
	}

	public void function removePages(required any pagePaths, required string reason) {
		if (not isArray(arguments.pagePaths)){
			arguments.pagePaths = ListToArray(arguments.pagePaths);
		}
		for ( var path in arguments.pagePaths){
			if ( not pages.keyExists(path))
				request.logger (text="PageCache.remove #path# not in cache", type="warn");
			else
				pages.delete(path);
		}
		/*
		if (arguments.pathPrefix.len() gt 0){
			for ( var path in pages){
				if ( path.startsWith(arguments.pathPrefix) ){
					pages.delete(path);
					request.logger (text="PageCache.remove by path prefix #path#");
				}
			}
		}
		*/
		request.logger (text="PageCache.remove due to #reason#, #ArrayToList(arguments.pagePaths)#");
	}

    public query function getPageFileList(boolean lastModified="false") {
		var startTime = getTickCount();
		if (arguments.lastModified){
			timer label="getPageFileList() slower #variables.rootDir#"{
				local.q_files = DirectoryList( path=variables.rootDir, recurse=true, listInfo="query", filter="*.md" );
				queryDeleteColumn(local.q_files, "mode");
				queryDeleteColumn(local.q_files, "attributes");
				queryDeleteColumn(local.q_files, "type");
				queryDeleteColumn(local.q_files, "size");
				queryAddColumn(local.q_files, "depth");
				queryAddColumn(local.q_files, "src");
				_removeRootDirectoryFromFilePaths(local.q_files);
			}
		} else {
			//  DirectoryList query is slow, don't do it not needed, this is 4x faster
			timer label="getPageFileList() quicker #variables.rootDir#"{
				local.files = DirectoryList( path=variables.rootDir, recurse=true, listInfo="path", filter="*.md" );
				local.q_files = QueryNew("name,directory,depth,src,dateLastModified,fullpath", "varchar,varchar,numeric,varchar,date,varchar");
				var timestamp = CreateDate(2000,1,1);//
				for( var file in local.files){
					file = _removeRootDirectoryFromFilePath(file);
					// if ( ListFirst( file, "/" ) eq "recipes") continue;
					var row = QueryAddRow(local.q_files);
					querySetCell(local.q_files, "name", ListLast(file, "/") , row);
					querySetCell(local.q_files, "fullpath", file , row);
					querySetCell(local.q_files, "directory", GetDirectoryFromPath(file) , row);
					querySetCell(local.q_files, "dateLastModified", timestamp, row);
				}
			}
		}
		//dump(var=local.q_files, expand=false, top=15); //		new api.build.Logger().renderLogs(); 		abort;
		timer label="getPageFileList() processFiles" {
			local.q_files = _processFiles( q_files=local.q_files, appendSlash = arguments.lastModified );
		}
		request.logger (text="Scanned source files, found #local.q_files.recordcount()# pages in #(getTickCount()-startTime)#ms");
		//dump(var=local.q_files, expand=false, top=15); 		new api.build.Logger().renderLogs(); 	//	abort;
		return local.q_files;
	}

	private void function _removeRootDirectoryFromFilePaths( required query q_files) {
		loop query = arguments.q_files {
			querySetCell(arguments.q_files, "directory",
				 _removeRootDirectoryFromFilePath(arguments.q_files.directory[arguments.q_files.currentrow]),
				 arguments.q_files.currentrow );
		}
	}

	private string function _removeRootDirectoryFromFilePath( filePath) {
		//return mid(arguments.filePath, len(variables.rootDir)).replace("\","/","all");
		return arguments.filePath.replace( variables.rootDir, "" ).replace("\","/","all");
	}

	private query function _processFiles( required query q_files, required boolean appendSlash) {
		for( var i = arguments.q_files.recordcount; i > 0; i-- ){
			// identify files which aren't pages, i.e sub files
			if (arguments.appendSlash)
				querySetCell(arguments.q_files, "directory", arguments.q_files.directory[i] & "/", i);
			switch (arguments.q_files.name[i]){
				// these page types have prefixes as they may conflict with methods etc
				case "_object.md":
				case "_method.md":
				case "page.md":
					break;
				default:
					var pos = ReFindNoCase( "/_", arguments.q_files.directory[i]);
					if (pos gt 0 or Left(arguments.q_files.name[i],1) eq "_") {
						querySetCell(arguments.q_files, "src", arguments.q_files.directory[i], i);
						querySetCell(arguments.q_files, "directory", mid(arguments.q_files.directory[i], 1, pos-1), i);
					}
					break;
			}
			querySetCell(arguments.q_files, "depth", ListLen(arguments.q_files.directory[i],"/"), i);
		}
		// find last modified date from all the sub files for a page
		var cfquery="";
		var modified = queryExecute("
			select  max(dateLastModified) dateLastModified, directory
			from    arguments.q_files
			group by directory
		", [], {dbtype="query", returntype="struct", columnkey="directory" });
		// now discard all sub files
		var q_page_files = queryExecute("
			select  name, directory, depth, dateLastModified, '' path
			from    arguments.q_files
			where 	src = ''
			order   by depth, directory, name
		", [], {dbtype="query"});
		// update the page file with the last modified date from all it's sub files
		for ( var i = q_page_files.recordcount; i > 0; i-- ){
			querySetCell(q_page_files, "dateLastModified",
				modified[q_page_files.directory[i]].dateLastModified,
				i
			);
			querySetCell(q_page_files, "path", getPagePathFromMdFilePath(q_page_files.directory[i]), i);
		}
		return q_page_files;
	}

	public string function getPagePathFromMdFilePath( required string filePath ) {
		var fileDir = GetDirectoryFromPath(  arguments.filePath );
		var parts   = fileDir.listToArray( "/" );

		for( var i=1; i <= parts.len(); i++ ) {
			if ( parts[ i ].listLen( "." ) > 1 ) {
				parts[ i ] = parts[ i ].listRest( "." );
			}
		}

		return "/" & parts.toList( "/" );
	}

	public string function createPageDirectory(required string filePath){
		var path = ListToArray(filepath, "/");
		var currentDir = variables.rootDir;
		request.logger("createPageDirectory: #arguments.filePath#");
		for (var dir in path){
			if ( not DirectoryExists(currentDir & "/" & dir ) ){
				dir = _createDirWithPrefixCheck(currentDir, dir);
			}
			currentDir = currentDir & "/" & dir;
			//request.logger("createPageDirectory: #currentDir#");
		}
		return _removeRootDirectoryFromFilePath(currentDir);
	}

	private string function _createDirWithPrefixCheck(required string dir, required string subDir ){
		var q_dir = directoryList(path=arguments.dir, recurse=false, listinfo="query", filter="", sort="asc", type="dir" );
		loop query=q_dir {
			var d = ListToArray(q_dir.name, ".");
			if (d.len() gt 1 and d[2] eq arguments.subdir){
				request.logger("_createDirWithPrefixCheck: matched #q_dir.name# for " & arguments.dir & "/" & arguments.subDir);
				return q_dir.name; // a directory with a numeric prefix, i.e. /010.functions/ exists with the same name
			}
		}
		var newDir = arguments.dir & "/" & arguments.subDir
		request.logger("_createDirWithPrefixCheck:  no match for #newDir#, creating it");
		DirectoryCreate(newDir);
		return subDir;
	}


	private void function _sortPageFilesByDepth( required query q_files ) {
		arguments.q_files.sort(
			function( file1, file2 ){
				var depth1 = arguments.file1.directory.listLen( "\/" );
				var depth2 = arguments.file2.directory.listLen( "\/" );

				if ( depth1 == depth2 )
					return 0;

				return depth1 > depth2 ? 1 : -1;
			}
		);
	}

	private array function _sortArrayPageFilesByDepth( required array pageFiles ) {
		arguments.pageFiles.sort( function( page1, page2 ){
			var depth1 = page1.listLen( "\/" );
			var depth2 = page2.listLen( "\/" );

			if ( depth1 == depth2 ) {
				return page1 > page2 ? 1 : -1;
			}

			return depth1 > depth2 ? 1 : -1;
		} );

		return arguments.pageFiles;
	}

}
